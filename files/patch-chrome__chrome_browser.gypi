--- chrome/chrome_browser.gypi.orig	2014-10-10 09:15:30 UTC
+++ chrome/chrome_browser.gypi
@@ -3245,7 +3245,7 @@
             '../device/media_transfer_protocol/media_transfer_protocol.gyp:device_media_transfer_protocol',
           ],
         }],
-        ['OS=="linux" and chromeos==0', {
+        ['(OS=="linux" and chromeos==0) or os_bsd==1', {
           'dependencies': [
             '../build/linux/system.gyp:libspeechd',
           ],
@@ -3302,7 +3302,7 @@
             }],
           ],
         }],
-        ['os_posix == 1 and OS != "mac" and OS != "ios"', {
+        ['os_posix == 1 and OS != "mac" and OS != "ios" and os_bsd != 1', {
           'sources': [
             'app/chrome_crash_reporter_client.cc',
             'app/chrome_crash_reporter_client.h',
@@ -3391,6 +3391,13 @@
           ],
           'sources': [ '<@(chrome_browser_android_sources)' ],
         }],
+        ['os_bsd==1', {
+          'sources/': [
+            ['exclude', '^browser/chrome_browser_main_linux.cc'],
+            ['exclude', '^browser/chrome_browser_main_linux.h'],
+            ['exclude', '^browser/media_galleries/linux/'],
+          ],
+        }],
         ['OS=="mac"', {
           'dependencies': [
             '../third_party/google_toolbox_for_mac/google_toolbox_for_mac.gyp:google_toolbox_for_mac',
@@ -3474,7 +3481,7 @@
             }],
           ],
         }],
-        ['OS=="linux"', {
+        ['OS=="linux" or os_bsd==1', {
           'sources': [ '<@(chrome_browser_linux_sources)' ],
           'conditions': [
             ['use_aura==1', {