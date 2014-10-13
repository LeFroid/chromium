--- third_party/ffmpeg/chromium/config/Chromium/linux/ia32/config.h.orig	2014-10-10 09:16:20 UTC
+++ third_party/ffmpeg/chromium/config/Chromium/linux/ia32/config.h
@@ -1,7 +1,7 @@
 /* Automatically generated by configure - do not modify! */
 #ifndef FFMPEG_CONFIG_H
 #define FFMPEG_CONFIG_H
-#define FFMPEG_CONFIGURATION "--disable-everything --disable-all --disable-doc --disable-static --enable-avcodec --enable-avformat --enable-avutil --enable-fft --enable-rdft --enable-shared --disable-bzlib --disable-error-resilience --disable-iconv --disable-lzo --disable-network --disable-symver --disable-xlib --disable-zlib --disable-dxva2 --disable-vaapi --disable-vda --disable-vdpau --enable-decoder='theora,vorbis,vp8' --enable-decoder='pcm_u8,pcm_s16le,pcm_s24le,pcm_f32le' --enable-decoder='pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw' --enable-demuxer='ogg,matroska,wav' --enable-parser='opus,vp3,vorbis,vp8' --optflags='\"-O2\"' --arch=i686 --enable-yasm --extra-cflags='\"-m32\"' --extra-ldflags='\"-m32\"' --enable-pic"
+#define FFMPEG_CONFIGURATION "--disable-everything --disable-all --disable-doc --disable-static --enable-avcodec --enable-avformat --enable-avutil --enable-fft --enable-rdft --enable-shared --disable-bzlib --disable-error-resilience --disable-iconv --disable-lzo --disable-network --disable-symver --disable-xlib --disable-zlib --disable-dxva2 --disable-vaapi --disable-vda --disable-vdpau --enable-decoder='theora,vorbis,vp8' --enable-decoder='pcm_u8,pcm_s16le,pcm_s24le,pcm_f32le' --enable-decoder='pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw' --enable-demuxer='ogg,matroska,wav' --enable-parser='opus,vp3,vorbis,vp8' --optflags='\"-O2\"' --arch=i686 --enable-yasm --extra-cflags='\"-m32,-mstack-alignment=16,-mstackrealign\"' --extra-ldflags='\"-m32\"' --enable-pic"
 #define FFMPEG_LICENSE "LGPL version 2.1 or later"
 #define CONFIG_THIS_YEAR 2014
 #define FFMPEG_DATADIR "/usr/local/share/ffmpeg"
