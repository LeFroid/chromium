--- ./chrome/browser/ui/webui/options/browser_options_handler.cc.orig	2014-08-20 21:02:02.000000000 +0200
+++ ./chrome/browser/ui/webui/options/browser_options_handler.cc	2014-08-22 15:06:25.000000000 +0200
@@ -332,7 +332,8 @@
     { "toolbarShowHomeButton", IDS_OPTIONS_TOOLBAR_SHOW_HOME_BUTTON },
     { "translateEnableTranslate",
       IDS_OPTIONS_TRANSLATE_ENABLE_TRANSLATE },
-#if defined(OS_LINUX) && !defined(OS_CHROMEOS)
+#if defined(OS_POSIX) && !defined(OS_CHROMEOS) && !defined(OS_MACOSX) && \
+    !defined(OS_ANDROID)
     { "showWindowDecorations", IDS_SHOW_WINDOW_DECORATIONS },
     { "themesNativeButton", IDS_THEMES_GTK_BUTTON },
     { "themesSetClassic", IDS_THEMES_SET_CLASSIC },
@@ -647,7 +648,8 @@
       "requestProfilesInfo",
       base::Bind(&BrowserOptionsHandler::HandleRequestProfilesInfo,
                  base::Unretained(this)));
-#if defined(OS_LINUX) && !defined(OS_CHROMEOS)
+#if defined(OS_POSIX) && !defined(OS_CHROMEOS) && !defined(OS_MACOSX) && \
+    !defined(OS_ANDROID)
   web_ui()->RegisterMessageCallback(
       "themesSetNative",
       base::Bind(&BrowserOptionsHandler::ThemesSetNative,
@@ -1272,7 +1274,8 @@
   ThemeService* theme_service = ThemeServiceFactory::GetForProfile(profile);
   bool is_system_theme = false;
 
-#if defined(OS_LINUX) && !defined(OS_CHROMEOS)
+#if defined(OS_POSIX) && !defined(OS_CHROMEOS) && !defined(OS_MACOSX) && \
+    !defined(OS_ANDROID)
   bool profile_is_supervised = profile->IsSupervised();
   is_system_theme = theme_service->UsingSystemTheme();
   base::FundamentalValue native_theme_enabled(!is_system_theme &&
@@ -1294,7 +1297,8 @@
   ThemeServiceFactory::GetForProfile(profile)->UseDefaultTheme();
 }
 
-#if defined(OS_LINUX) && !defined(OS_CHROMEOS)
+#if defined(OS_POSIX) && !defined(OS_CHROMEOS) && !defined(OS_MACOSX) && \
+    !defined(OS_ANDROID)
 void BrowserOptionsHandler::ThemesSetNative(const base::ListValue* args) {
   content::RecordAction(UserMetricsAction("Options_GtkThemeSet"));
   Profile* profile = Profile::FromWebUI(web_ui());
