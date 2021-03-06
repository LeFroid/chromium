--- base/process/launch.h.orig	2015-05-13 18:23:01.000000000 -0400
+++ base/process/launch.h	2015-05-20 09:13:38.326203000 -0400
@@ -131,7 +131,7 @@
   // will be the same as its pid.
   bool new_process_group;
 
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_FREEBSD)
   // If non-zero, start the process using clone(), using flags as provided.
   // Unlike in clone, clone_flags may not contain a custom termination signal
   // that is sent to the parent when the child dies. The termination signal will
@@ -144,7 +144,7 @@
 
   // Sets parent process death signal to SIGKILL.
   bool kill_on_parent_death;
-#endif  // defined(OS_LINUX)
+#endif  // defined(OS_LINUX) || defined(OS_FREEBSD)
 
 #if defined(OS_POSIX)
   // If not empty, change to this directory before execing the new process.
