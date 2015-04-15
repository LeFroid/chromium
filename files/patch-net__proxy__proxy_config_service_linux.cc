--- net/proxy/proxy_config_service_linux.cc.orig	2015-01-21 20:05:44 UTC
+++ net/proxy/proxy_config_service_linux.cc
@@ -12,7 +12,13 @@
 #include <limits.h>
 #include <stdio.h>
 #include <stdlib.h>
+#if defined(OS_FREEBSD)
+#include <sys/types.h>
+#include <sys/event.h>
+#include <sys/time.h>
+#else
 #include <sys/inotify.h>
+#endif
 #include <unistd.h>
 
 #include <map>
@@ -852,9 +858,10 @@
                              public base::MessagePumpLibevent::Watcher {
  public:
   explicit SettingGetterImplKDE(base::Environment* env_var_getter)
-      : inotify_fd_(-1), notify_delegate_(NULL), indirect_manual_(false),
-        auto_no_pac_(false), reversed_bypass_list_(false),
-        env_var_getter_(env_var_getter), file_task_runner_(NULL) {
+      : inotify_fd_(-1), config_fd_(-1), notify_delegate_(NULL),
+        indirect_manual_(false),  auto_no_pac_(false),
+        reversed_bypass_list_(false), env_var_getter_(env_var_getter),
+        file_task_runner_(NULL) {
     // This has to be called on the UI thread (http://crbug.com/69057).
     base::ThreadRestrictions::ScopedAllowIO allow_io;
 
@@ -918,9 +925,10 @@
     // and pending tasks may then be deleted without being run.
     // Here in the KDE version, we can safely close the file descriptor
     // anyway. (Not that it really matters; the process is exiting.)
-    if (inotify_fd_ >= 0)
+    if (inotify_fd_ >= 0 || config_fd_ >= 0)
       ShutDown();
     DCHECK(inotify_fd_ < 0);
+    DCHECK(config_fd_ < 0);
   }
 
   bool Init(const scoped_refptr<base::SingleThreadTaskRunner>& glib_task_runner,
@@ -929,11 +937,20 @@
     // This has to be called on the UI thread (http://crbug.com/69057).
     base::ThreadRestrictions::ScopedAllowIO allow_io;
     DCHECK(inotify_fd_ < 0);
+#if defined(OS_FREEBSD)
+    inotify_fd_ = kqueue();
+#else
     inotify_fd_ = inotify_init();
+#endif
     if (inotify_fd_ < 0) {
+#if defined(OS_FREEBSD)
+      PLOG(ERROR) << "kqueue failed";
+#else
       PLOG(ERROR) << "inotify_init failed";
+#endif
       return false;
     }
+#if !defined(OS_FREEBSD)
     int flags = fcntl(inotify_fd_, F_GETFL);
     if (fcntl(inotify_fd_, F_SETFL, flags | O_NONBLOCK) < 0) {
       PLOG(ERROR) << "fcntl failed";
@@ -941,6 +958,7 @@
       inotify_fd_ = -1;
       return false;
     }
+#endif
     file_task_runner_ = file_task_runner;
     // The initial read is done on the current thread, not
     // |file_task_runner_|, since we will need to have it for
@@ -956,21 +974,39 @@
       close(inotify_fd_);
       inotify_fd_ = -1;
     }
+    if (config_fd_ >= 0) {
+      close(config_fd_);
+      config_fd_ = -1;
+    }
   }
 
   bool SetUpNotifications(
       ProxyConfigServiceLinux::Delegate* delegate) override {
     DCHECK(inotify_fd_ >= 0);
+    DCHECK(config_fd_ >= 0);
     DCHECK(file_task_runner_->BelongsToCurrentThread());
     // We can't just watch the kioslaverc file directly, since KDE will write
     // a new copy of it and then rename it whenever settings are changed and
     // inotify watches inodes (so we'll be watching the old deleted file after
     // the first change, and it will never change again). So, we watch the
     // directory instead. We then act only on changes to the kioslaverc entry.
+#if defined(OS_FREEBSD)
+    config_fd_ = HANDLE_EINTR(open(kde_config_dir_.value().c_str(), O_RDONLY));
+
+    if (config_fd_ == -1)
+      return false;
+
+    struct kevent ev;
+    EV_SET(&ev, config_fd_, EVFILT_VNODE, EV_ADD | EV_CLEAR, NOTE_WRITE,
+            0, NULL);
+    if (kevent(inotify_fd_, &ev, 1, NULL, 0, NULL) == -1)
+      return false;
+#else
     if (inotify_add_watch(inotify_fd_, kde_config_dir_.value().c_str(),
                           IN_MODIFY | IN_MOVED_TO) < 0) {
       return false;
     }
+#endif
     notify_delegate_ = delegate;
     if (!base::MessageLoopForIO::current()->WatchFileDescriptor(
             inotify_fd_, true, base::MessageLoopForIO::WATCH_READ,
@@ -991,7 +1027,19 @@
   void OnFileCanReadWithoutBlocking(int fd) override {
     DCHECK_EQ(fd, inotify_fd_);
     DCHECK(file_task_runner_->BelongsToCurrentThread());
+#if defined(OS_FREEBSD)
+    struct kevent ev;
+    int rv = kevent(inotify_fd_, NULL, 0, &ev, 1, NULL);
+
+    if (rv != -1 && (ev.flags & EV_ERROR) == 0) {
+      OnChangeNotification();
+    } else {
+      LOG(ERROR) << "kevent() failure; no longer watching kioslaverc!";
+      ShutDown();
+    }
+#else
     OnChangeNotification();
+#endif
   }
   void OnFileCanWriteWithoutBlocking(int fd) override { NOTREACHED(); }
 
@@ -1264,8 +1312,11 @@
   void OnChangeNotification() {
     DCHECK_GE(inotify_fd_,  0);
     DCHECK(file_task_runner_->BelongsToCurrentThread());
-    char event_buf[(sizeof(inotify_event) + NAME_MAX + 1) * 4];
     bool kioslaverc_touched = false;
+#if defined(OS_FREEBSD)
+    kioslaverc_touched = true;
+#else
+    char event_buf[(sizeof(inotify_event) + NAME_MAX + 1) * 4];
     ssize_t r;
     while ((r = read(inotify_fd_, event_buf, sizeof(event_buf))) > 0) {
       // inotify returns variable-length structures, which is why we have
@@ -1302,6 +1353,7 @@
         inotify_fd_ = -1;
       }
     }
+#endif
     if (kioslaverc_touched) {
       // We don't use Reset() because the timer may not yet be running.
       // (In that case Stop() is a no-op.)
@@ -1317,6 +1369,7 @@
                    std::vector<std::string> > strings_map_type;
 
   int inotify_fd_;
+  int config_fd_;
   base::MessagePumpLibevent::FileDescriptorWatcher inotify_watcher_;
   ProxyConfigServiceLinux::Delegate* notify_delegate_;
   base::OneShotTimer<SettingGetterImplKDE> debounce_timer_;