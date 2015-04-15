--- ui/app_list/views/app_list_view.cc.orig	Tue Mar 10 23:41:42 2015
+++ ui/app_list/views/app_list_view.cc	Wed Mar 11 07:22:50 2015
@@ -75,7 +75,7 @@
           ::switches::kDisableDwmComposition)) {
     return false;
   }
-#elif defined(OS_LINUX) && !defined(OS_CHROMEOS)
+#elif (defined(OS_LINUX) || defined(OS_BSD)) && !defined(OS_CHROMEOS)
   // Shadows are not supported on (non-ChromeOS) Linux.
   return false;
 #endif
@@ -549,7 +549,7 @@
   // the taskbar for these versions of Windows.
   if (base::win::GetVersion() >= base::win::VERSION_WIN7)
     params->force_show_in_taskbar = true;
-#elif defined(OS_LINUX)
+#elif defined(OS_LINUX) || defined(OS_BSD)
   // Set up a custom WM_CLASS for the app launcher window. This allows task
   // switchers in X11 environments to distinguish it from main browser windows.
   params->wm_class_name = kAppListWMClass;