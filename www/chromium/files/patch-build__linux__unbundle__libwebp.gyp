--- build/linux/unbundle/libwebp.gyp.orig	2014-07-15 21:03:13.000000000 +0200
+++ build/linux/unbundle/libwebp.gyp	2014-08-13 00:48:51.000000000 +0200
@@ -14,13 +14,7 @@
       },
       'link_settings': {
         'libraries': [
-          # Check for presence of webpdemux library, use it if present.
-          '<!(python <(DEPTH)/tools/compile_test/compile_test.py '
-          '--code "int main() { return 0; }" '
-          '--run-linker '
-          '--on-success "-lwebp -lwebpdemux" '
-          '--on-failure "-lwebp" '
-          '-- -lwebpdemux)',
+          '-lwebp -lwebpdemux',
         ],
       },
     }
