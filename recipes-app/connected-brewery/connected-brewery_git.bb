SUMMARY = "Automation for a home brewery"
HOMEPAGE = "https://github.com/leograba/connectedBrewery"
SECTION = "app"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=52ae06cc6439742d42d13b3d3f1ee373"

PROVIDES = "connected-brewery"

#DEPENDS = "gtk+ glib-2.0 xfce4-dev-tools-native intltool-native"
DEPENDS = "nginx"
RDEPENDS_${PN} = "php-fpm nginx nodejs"

SRC_URI = "git://github.com/leograba/connectedBrewery.git;branch=master"
SRCREV = "5bffd6ceb5676671e51102d600c00581dc6e0813"
PV = "1.0.0"
S = "${WORKDIR}/git"

NGINX_WWWDIR ?= "${localstatedir}/www/localhost"

do_install () {
    install -d ${D}${NGINX_WWWDIR}/html
    cp -a ${S}/www/* ${D}${NGINX_WWWDIR}/html/
    chown -R root:root ${D}${NGINX_WWWDIR}/html
}

#inherit xfce-git gettext pkgconfig autotools gtk-icon-cache distro_features_check

#REQUIRED_DISTRO_FEATURES = "x11"

# install tap files for thunar-archive-plugin in ${libdir}/thunar-archive-plugin
#EXTRA_OECONF += "--libexecdir=${libdir}"

#EXTRA_OECONF += "--enable-maintainer-mode"

FILES_${PN} += "${NGINX_WWWDIR}/*"

#RRECOMMENDS_${PN} = "lzop zip tar bzip2 unzip xz"