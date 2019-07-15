# Enable systemd service php-fpm.conf

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_class-target += " \
    file://php-fpm.conf \
"

# inherit systemd

# Have to copy everything since the bb file defines append :/
# Maybe it's why I cannot have the systemd file properly installed?
do_install_append_class-target() {
    install -d ${D}${sysconfdir}/
    if [ -d ${RECIPE_SYSROOT_NATIVE}${sysconfdir} ];then
         install -m 0644 ${RECIPE_SYSROOT_NATIVE}${sysconfdir}/pear.conf ${D}${sysconfdir}/
    fi
    rm -rf ${D}/${TMPDIR}
    rm -rf ${D}/.registry
    rm -rf ${D}/.channels
    rm -rf ${D}/.[a-z]*
    rm -rf ${D}/var
    rm -f  ${D}/${sysconfdir}/php-fpm.conf.default
    sed -i 's:${STAGING_DIR_NATIVE}::g' ${D}${sysconfdir}/pear.conf
    install -m 0644 ${WORKDIR}/php-fpm.conf ${D}/${sysconfdir}/php-fpm.conf
    install -d ${D}/${sysconfdir}/apache2/conf.d
    install -m 0644 ${WORKDIR}/php-fpm-apache.conf ${D}/${sysconfdir}/apache2/conf.d/php-fpm.conf
    install -d ${D}${sysconfdir}/init.d
    sed -i 's:=/usr/sbin:=${sbindir}:g' ${B}/sapi/fpm/init.d.php-fpm
    sed -i 's:=/etc:=${sysconfdir}:g' ${B}/sapi/fpm/init.d.php-fpm
    sed -i 's:=/var:=${localstatedir}:g' ${B}/sapi/fpm/init.d.php-fpm
    install -m 0755 ${B}/sapi/fpm/init.d.php-fpm ${D}${sysconfdir}/init.d/php-fpm
    install -m 0644 ${WORKDIR}/php-fpm-apache.conf ${D}/${sysconfdir}/apache2/conf.d/php-fpm.conf

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)};then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/php-fpm.service ${D}${systemd_unitdir}/system/
        sed -i -e 's,@SYSCONFDIR@,${sysconfdir},g' \
            -e 's,@LOCALSTATEDIR@,${localstatedir},g' \
            ${D}${systemd_unitdir}/system/php-fpm.service
    fi
    install -d ${D}/etc/systemd/system/multi-user.target.wants
    ln -s /lib/systemd/system/php-fpm.service ${D}/etc/systemd/system/multi-user.target.wants/php-fpm.service


    TMP=`dirname ${D}/${TMPDIR}`
    while test ${TMP} != ${D}; do
        if [ -d ${TMP} ]; then
            rmdir ${TMP}
        fi
        TMP=`dirname ${TMP}`;
    done

    if ${@bb.utils.contains('PACKAGECONFIG', 'apache2', 'true', 'false', d)}; then
        install -d ${D}${libdir}/apache2/modules
        install -d ${D}${sysconfdir}/apache2/modules.d
        install -d ${D}${sysconfdir}/php/apache2-php${PHP_MAJOR_VERSION}
        install -m 755  libs/libphp${PHP_MAJOR_VERSION}.so ${D}${libdir}/apache2/modules
        install -m 644  ${WORKDIR}/70_mod_php${PHP_MAJOR_VERSION}.conf ${D}${sysconfdir}/apache2/modules.d
        sed -i s,lib/,${libdir}/, ${D}${sysconfdir}/apache2/modules.d/70_mod_php${PHP_MAJOR_VERSION}.conf
        cat ${S}/php.ini-production | \
            sed -e 's,extension_dir = \"\./\",extension_dir = \"/usr/lib/extensions\",' \
            > ${D}${sysconfdir}/php/apache2-php${PHP_MAJOR_VERSION}/php.ini
        rm -f ${D}${sysconfdir}/apache2/httpd.conf*
    fi
}

FILES_${PN}-fpm +=  "/etc/systemd/system/multi-user.target.wants/php-fpm.service"
# SYSTEMD_SERVICE_${PN}-fpm = "php-fpm.service"