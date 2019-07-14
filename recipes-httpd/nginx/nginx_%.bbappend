# Override configuration file

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += " \
    file://nginx.conf \
"

do_install_append () {
    install -d ${D}${sysconfdir}/nginx
    install -m 0644 ${WORKDIR}/nginx.conf ${D}${sysconfdir}/nginx/nginx.conf
}