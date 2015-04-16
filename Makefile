# Created by: Florent Thoumie <flz@FreeBSD.org>
# $FreeBSD: head/www/chromium/Makefile 379471 2015-02-20 23:27:20Z rene $

PORTNAME=	chromium
PORTVERSION=	41.0.2272.118
CATEGORIES=	www
MASTER_SITES=	http://commondatastorage.googleapis.com/chromium-browser-official/
DISTFILES=	${DISTNAME}${EXTRACT_SUFX}

MAINTAINER=	chromium@FreeBSD.org
COMMENT=	Google web browser based on WebKit

LICENSE=	BSD3CLAUSE LGPL21 MPL
LICENSE_COMB=	multi

CFLAGS+=	-isystem${LOCALBASE}/include

BUILD_DEPENDS=	${LOCALBASE}/bin/gperf:${PORTSDIR}/devel/gperf \
		bash:${PORTSDIR}/shells/bash \
		yasm:${PORTSDIR}/devel/yasm \
		flock:${PORTSDIR}/sysutils/flock \
		${LOCALBASE}/include/linux/videodev2.h:${PORTSDIR}/multimedia/v4l_compat \
		${LOCALBASE}/share/usbids/usb.ids:${PORTSDIR}/misc/usbids

LIB_DEPENDS=	libcairo.so:${PORTSDIR}/graphics/cairo \
		libdbus-1.so:${PORTSDIR}/devel/dbus \
		libdbus-glib-1.so:${PORTSDIR}/devel/dbus-glib \
		libasound.so:${PORTSDIR}/audio/alsa-lib \
		libfreetype.so:${PORTSDIR}/print/freetype2 \
		libnss3.so:${PORTSDIR}/security/nss \
		libFLAC.so:${PORTSDIR}/audio/flac \
		libgnome-keyring.so:${PORTSDIR}/security/libgnome-keyring \
		libharfbuzz.so:${PORTSDIR}/print/harfbuzz \
		libcups.so:${PORTSDIR}/print/cups-client \
		libevent.so:${PORTSDIR}/devel/libevent2 \
		libexif.so:${PORTSDIR}/graphics/libexif \
		libgcrypt.so:${PORTSDIR}/security/libgcrypt \
		libpci.so:${PORTSDIR}/devel/libpci \
		libdrm.so:${PORTSDIR}/graphics/libdrm \
		libicuuc.so:${PORTSDIR}/devel/icu \
		libjpeg.so:${PORTSDIR}/graphics/jpeg \
		libjsoncpp.so:${PORTSDIR}/devel/jsoncpp \
		libnspr4.so:${PORTSDIR}/devel/nspr \
		libpng.so:${PORTSDIR}/graphics/png \
		libre2.so:${PORTSDIR}/devel/re2 \
		libsnappy.so:${PORTSDIR}/archivers/snappy \
		libspeechd.so:${PORTSDIR}/accessibility/speech-dispatcher \
		libspeex.so:${PORTSDIR}/audio/speex \
		libxml2.so:${PORTSDIR}/textproc/libxml2 \
		libwebp.so:${PORTSDIR}/graphics/webp

RUN_DEPENDS=	${LOCALBASE}/lib/alsa-lib/libasound_module_pcm_oss.so:${PORTSDIR}/audio/alsa-plugins \
		droid-fonts-ttf>0:${PORTSDIR}/x11-fonts/droid-fonts-ttf \
		xdg-open:${PORTSDIR}/devel/xdg-utils

ONLY_FOR_ARCHS=	i386 amd64
USES=		bison compiler:c++11-lib cpe desktop-file-utils pkgconfig \
		perl5 shebangfix ninja tar:xz python:2,build execinfo
CPE_VENDOR=	google
CPE_PRODUCT=	chrome
USE_PERL5=	build
USE_XORG=	scrnsaverproto x11 xproto xscrnsaver xtst
USE_GNOME=	glib20 gtk20 dconf libxslt
SHEBANG_FILES=	chrome/tools/build/linux/chrome-wrapper
ALL_TARGET=	chrome
INSTALLS_ICONS=	yes

#TODO bz@ : if you do undestand the gyp stuff, third_party/widevine/cdm/widevine_cdm.gyp talks about it (plz install libwidevinecdm.so)
# See build/common.gypi for all the available variables.
GYP_DEFINES+=	\
		clang_use_chrome_plugins=0 \
		linux_breakpad=0 \
		linux_use_heapchecker=0 \
		linux_strip_binary=1 \
		test_isolation_mode=noop \
		disable_nacl=1 \
		enable_extensions=1 \
		enable_one_click_signin=1 \
		enable_openmax=1 \
		enable_webrtc=1 \
		werror= \
		no_gc_sections=1 \
		os_ver=${OSVERSION} \
		prefix_dir=${LOCALBASE} \
		python_ver=${PYTHON_VER} \
		use_allocator=none \
		use_cups=1 \
		linux_link_gsettings=1 \
		linux_link_libpci=1 \
		linux_link_libspeechd=1 \
		libspeechd_h_prefix=speech-dispatcher/ \
		usb_ids_path=${LOCALBASE}/share/usbids/usb.ids \
		want_separate_host_toolset=0 \
		use_system_bzip2=1 \
		use_system_flac=1 \
		use_system_harfbuzz=1 \
		use_system_icu=1 \
		use_system_jsoncpp=1 \
		use_system_libevent=1 \
		use_system_libexif=1 \
		use_system_libjpeg=1 \
		use_system_libpng=1 \
		use_system_libusb=1 \
		use_system_libwebp=1 \
		use_system_libxml=1 \
		use_system_libxslt=1 \
		use_system_nspr=1 \
		use_system_protobuf=0 \
		use_system_re2=1 \
		use_system_snappy=1 \
		use_system_speex=1 \
		use_system_xdg_utils=1 \
		use_system_yasm=1
# allow removal of third_party/adobe
GYP_DEFINES+=	flapper_version_h_file='${WRKSRC}/flapper_version.h'

# FreeBSD Chromium Api Key
# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys .
# Note: these are for FreeBSD use ONLY. For your own distribution,
# please get your own set of keys.
GYP_DEFINES+=	google_api_key=AIzaSyBsp9n41JLW8jCokwn7vhoaMejDFRd1mp8 \
		google_default_client_id=996322985003.apps.googleusercontent.com \
		google_default_client_secret=IR1za9-1VK0zZ0f_O8MVFicn

SUB_FILES=	chromium-browser.desktop chrome
SUB_LIST+=	COMMENT="${COMMENT}"

OPTIONS_DEFINE=	CODECS GCONF PULSEAUDIO TEST KERBEROS DEBUG
CODECS_DESC=	Compile and enable patented codecs like H.264

OPTIONS_DEFAULT=	CODECS GCONF KERBEROS

GCONF_USE=	GNOME=gconf2
PULSEAUDIO_LIB_DEPENDS=	libpulse.so:${PORTSDIR}/audio/pulseaudio

#TEST_DISTFILES=	${PORTNAME}-${DISTVERSION}-testdata${EXTRACT_SUFX}

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MCODECS}
GYP_DEFINES+=	ffmpeg_branding=Chrome
GYP_DEFINES+=	proprietary_codecs=1
.else
GYP_DEFINES+=	ffmpeg_branding=Chromium
GYP_DEFINES+=	proprietary_codecs=0
.endif

.if ${PORT_OPTIONS:MGCONF}
GYP_DEFINES+=	use_gconf=1
.else
GYP_DEFINES+=	use_gconf=0
.endif

.if ${PORT_OPTIONS:MPULSEAUDIO}
GYP_DEFINES+=	use_pulseaudio=1
.else
GYP_DEFINES+=	use_pulseaudio=0
.endif

.if ! ${MACHINE_CPU:Msse2}
GYP_DEFINES+=	disable_sse2=1
.endif

.if !exists(/usr/libdata/pkgconfig/libusb-1.0.pc)
EXTRA_PATCHES+=	${FILESDIR}/extra-patch-libusb-pc
.endif

# pointed out by "Tomek" on freebsd-chromium@
.if !exists(/usr/lib/libexecinfo.so)
CFLAGS+=	-fno-omit-frame-pointer
EXTRA_PATCHES+=	${FILESDIR}/extra-patch-fixup-ffmpeg
.endif

.if ${PORT_OPTIONS:MTEST}
.include "Makefile.tests"
ALL_TARGET+=	${TEST_TARGETS}
.endif

DEBUG_MAKE_ENV=	V=1
.if ${PORT_OPTIONS:MDEBUG}
BROKEN=		Produces empty binary
BUILDTYPE=	Debug
.else
BUILDTYPE=	Release
.endif

CONFIGURE_ENV+=	CC="${CC}" \
		CXX="${CXX}" \
		GYP_GENERATORS=ninja \
		GYP_DEFINES="${GYP_DEFINES}"
MAKE_ENV+=	BUILDTYPE=${BUILDTYPE} \
		GPERF="${LOCALBASE}/bin/gperf"
MAKE_ARGS=	-C out/${BUILDTYPE}

.include <bsd.port.pre.mk>

.if ${CHOSEN_COMPILER_TYPE} == gcc
GYP_DEFINES+=	gcc_version=${CXX:S/g++//}
EXTRA_PATCHES+=	${FILESDIR}/extra-patch-gcc
CFLAGS+=	-fno-stack-protector # gcc 4.8 cannot find __stack_chk_fail_local
.else
GYP_DEFINES+=	clang=1
CFLAGS+=	-Wno-unknown-warning-option
#EXTRA_PATCHES+=	${FILESDIR}/extra-patch-clang
CONFIGURE_ENV+=	AR=/usr/bin/ar
.endif

.if ! ${PORT_OPTIONS:MKERBEROS}
GYP_DEFINES+=	use_kerberos=0
.endif

# according to portlint the below is passed via bsd.port.mk,
# but 'make -V CONFIGURE_ENV' does not show it:
CONFIGURE_ENV+=	CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"

pre-everything::
	@${ECHO_MSG}
	@${ECHO_MSG} "To build Chromium, you should have around 2 GB of memory"
.if ${PORT_OPTIONS:MDEBUG}
	@${ECHO_MSG} "and lots of free diskspace (~ 8.5GB)."
.else
	@${ECHO_MSG} "and a fair amount of free diskspace (~ 3.7GB)."
.endif
	@${ECHO_MSG}
	@${ECHO_MSG} "Make sure you have Python build with the SEM option ON"
	@${ECHO_MSG} "(default in python27-2.7.8 since r361735)"

post-patch:
	@${REINPLACE_CMD} -e "s|/usr/local|${LOCALBASE}|" \
		${WRKSRC}/crypto/crypto.gyp \
		${WRKSRC}/v8/tools/gyp/v8.gyp \
		${WRKSRC}/v8/build/toolchain.gypi
	@${REINPLACE_CMD} -e "s|/usr/local|${PREFIX}|" \
		${WRKSRC}/chrome/common/chrome_paths.cc \
		${WRKSRC}/base/base.gyp

pre-configure:
	# phajdan-jr: list of things *not* to remove, so maybe the script
	#             should be called "keep_bundled_libraries.py"
	cd ${WRKSRC} && ${PYTHON_CMD} \
		./build/linux/unbundle/remove_bundled_libraries.py \
		'base/third_party/dmg_fp' \
		'base/third_party/dynamic_annotations' \
		'base/third_party/icu' \
		'base/third_party/nspr' \
		'base/third_party/superfasthash' \
		'base/third_party/symbolize' \
		'base/third_party/valgrind' \
		'base/third_party/xdg_mime' \
		'base/third_party/xdg_user_dirs' \
		'breakpad/src/third_party/curl' \
		'chrome/third_party/mock4js' \
		'chrome/third_party/mozilla_security_manager' \
		'courgette/third_party' \
		'crypto/third_party/nss' \
		'net/third_party/mozilla_security_manager' \
		'net/third_party/nss' \
		'third_party/WebKit' \
		'third_party/angle' \
		'third_party/angle/src/third_party' \
		'third_party/blanketjs' \
		'third_party/brotli' \
		'third_party/boringssl' \
		'third_party/cacheinvalidation' \
		'third_party/cld' \
		'third_party/cros_system_api' \
		'third_party/dom_distiller_js' \
		'third_party/dom_distiller_js/package/proto_gen/third_party/dom_distiller_js' \
		'third_party/ffmpeg' \
		'third_party/gardiner_mod' \
		'third_party/fips181' \
		'third_party/flot' \
		'third_party/google_input_tools' \
		'third_party/google_input_tools/third_party/closure_library' \
		'third_party/google_input_tools/third_party/closure_library/third_party/closure' \
		'third_party/hunspell' \
		'third_party/iccjpeg' \
		'third_party/icu/icu.isolate' \
		'third_party/jinja2' \
		'third_party/jstemplate' \
		'third_party/khronos' \
		'third_party/leveldatabase' \
		'third_party/libaddressinput' \
		'third_party/libjingle' \
		'third_party/libphonenumber' \
		'third_party/libsrtp' \
		'third_party/libvpx' \
		'third_party/libvpx/source/libvpx/third_party/x86inc' \
		'third_party/libxml/chromium' \
		'third_party/libXNVCtrl' \
		'third_party/libyuv' \
		'third_party/lss' \
		'third_party/lzma_sdk' \
		'third_party/markupsafe' \
		'third_party/mesa' \
		'third_party/modp_b64' \
		'third_party/mt19937ar' \
		'third_party/npapi' \
		'third_party/openmax_dl' \
		'third_party/opus' \
		'third_party/ots' \
		'third_party/pdfium' \
		'third_party/pdfium/third_party' \
		'third_party/ply' \
		'third_party/polymer' \
		'third_party/protobuf' \
		'third_party/pywebsocket' \
		'third_party/qcms' \
		'third_party/qunit' \
		'third_party/readability' \
		'third_party/sfntly' \
		'third_party/sinonjs' \
		'third_party/skia' \
		'third_party/smhasher' \
		'third_party/sqlite' \
		'third_party/tcmalloc' \
		'third_party/tlslite' \
		'third_party/trace-viewer' \
		'third_party/trace-viewer/third_party' \
		'third_party/trace-viewer/third_party/tvcm/third_party' \
		'third_party/undoview' \
		'third_party/usrsctp' \
		'third_party/webdriver' \
		'third_party/webrtc' \
		'third_party/widevine' \
		'third_party/x86inc' \
		'third_party/yasm' \
		'third_party/zlib' \
		'url/third_party/mozilla' \
		'v8/src/third_party/valgrind' \
		'v8/src/third_party/fdlibm' \
		--do-remove || ${FALSE}
	cd ${WRKSRC} && ${PYTHON_CMD} \
		./build/linux/unbundle/replace_gyp_files.py \
		${GYP_DEFINES:C/^/-D/} || ${FALSE}
	# allow removal of third_party/adobe
	${ECHO_CMD} > ${WRKSRC}/flapper_version.h

do-configure:
	cd ${WRKSRC} && ${SETENV} ${CONFIGURE_ENV} ${PYTHON_CMD} \
		./build/gyp_chromium chrome/chrome.gyp --depth .

test regression-test: build
.for t in ${TEST_TARGETS}
	cd ${WRKSRC}/out/${BUILDTYPE} && ${SETENV} LC_ALL=en_US.UTF-8 \
		./${t} --gtest_filter=-${EXCLUDE_${t}:ts:} || ${TRUE}
.endfor

do-install:
	@${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_MAN} ${WRKSRC}/out/${BUILDTYPE}/chrome.1 ${STAGEDIR}${MANPREFIX}/man/man1
.for s in 22 24 48 64 128 256
	@${MKDIR} ${STAGEDIR}${PREFIX}/share/icons/hicolor/${s}x${s}/apps
	${INSTALL_DATA} ${WRKSRC}/chrome/app/theme/chromium/product_logo_${s}.png \
		${STAGEDIR}${PREFIX}/share/icons/hicolor/${s}x${s}/apps/chrome.png
.endfor
	${INSTALL_SCRIPT} ${WRKSRC}/chrome/tools/build/linux/chrome-wrapper \
		${STAGEDIR}${DATADIR}
.for p in chrome_100_percent content_resources keyboard_resources resources
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/${p}.pak \
		${STAGEDIR}${DATADIR}
.endfor
	${INSTALL_PROGRAM} ${WRKSRC}/out/${BUILDTYPE}/chrome \
		${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/out/${BUILDTYPE}/libffmpegsumo.so \
		${STAGEDIR}${DATADIR}
	${INSTALL_LIB} ${WRKSRC}/out/${BUILDTYPE}/libpdf.so \
		${STAGEDIR}${DATADIR}
	cd ${WRKSRC}/out/${BUILDTYPE} && \
		${COPYTREE_SHARE} "locales resources" ${STAGEDIR}${DATADIR}
	@${MKDIR} ${STAGEDIR}${DESKTOPDIR}
	${INSTALL_DATA} ${WRKDIR}/chromium-browser.desktop \
		${STAGEDIR}${DESKTOPDIR}
	${INSTALL_SCRIPT} ${WRKDIR}/chrome ${STAGEDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} ${WRKSRC}/out/${BUILDTYPE}/mksnapshot \
		${STAGEDIR}${DATADIR}/mksnapshot

.include <bsd.port.post.mk>
