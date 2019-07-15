SUMMARY = "Automation for a home brewery"
HOMEPAGE = "https://github.com/leograba/connectedBrewery"
SECTION = "app"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f"

DEPENDS = "gtk+ glib-2.0 xfce4-dev-tools-native intltool-native"

SRC_URI = "git://github.com/schnitzeltony/xarchiver.git;branch=master"
SRCREV = "5a26dd8ceab0af71b30c83286d7c7398a858c814"
PV = "0.5.3"
S = "${WORKDIR}/git"

inherit xfce-git gettext pkgconfig autotools gtk-icon-cache distro_features_check

REQUIRED_DISTRO_FEATURES = "x11"

# install tap files for thunar-archive-plugin in ${libdir}/thunar-archive-plugin
EXTRA_OECONF += "--libexecdir=${libdir}"

EXTRA_OECONF += "--enable-maintainer-mode"

FILES_${PN} += "${libdir}/thunar-archive-plugin"

RRECOMMENDS_${PN} = "lzop zip tar bzip2 unzip xz"