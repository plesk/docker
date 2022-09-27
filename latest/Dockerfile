# Plesk container with real systemd
# Run in background: 'docker run -d --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 8443:8443 IMAGE'
# Run in foreground: 'docker run -ti --rm --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 8443:8443 IMAGE', stop with 'halt' instead of Ctrl+D

ARG OS=ubuntu:20.04
FROM $OS

LABEL maintainer="plesk-dev-leads@plesk.com"

ENV container docker

# allow services to start
RUN sed -i -e 's/exit.*/exit 0/g' /usr/sbin/policy-rc.d

RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        tzdata \
        python3 \
        rsyslog \
        systemd \
        systemd-sysv \
        ; \
    rm -rf /var/lib/apt/lists/*; \
    :

# prepare fake systemctl used only during build
ADD https://github.com/gdraheim/docker-systemctl-replacement/raw/v1.5.4260/files/docker/systemctl3.py /usr/bin/fake-systemctl
RUN set -eux; \
    sed -i \
        -e '/^\s*logg.error("the ..include. syntax is deprecated. Use x.service.d. drop-in files!")$/d' \
        -e '/Loaded:/ s/({filename}, {enabled})/({filename}; {enabled})/' \
        -e '/^\s*def do_\(start\|stop\)_unit_from(/,/^\s*def / s/return False/return conf.name().endswith(".path")/' \
        /usr/bin/fake-systemctl; \
    chmod 755 /usr/bin/fake-systemctl; \
    :

ARG LICENSE
ARG AI_SOURCE=http://autoinstall.plesk.com
ARG AI_ARGS=
ARG EXT_CATALOG=https://ext.plesk.com

# Do not install:
# - additional PHP versions as we don't need them
# - majority of extensions (except wp-toolkit) as we don't need them
ENV PLESK_DISABLE_HOSTNAME_CHECKING 1
ENV PLESK_CONFIG__extensions__catalog__url $EXT_CATALOG
ENV PLESK_CONFIG__taskManager__enabled 0
RUN set -eux; \
    : Use fake systemctl during build; \
    dpkg-divert --divert /bin/systemctl.real --rename --add /bin/systemctl; \
    ln -snf /usr/bin/fake-systemctl /bin/systemctl; \
    : Install Plesk; \
    wget -nv -O /root/ai $AI_SOURCE/plesk-installer; \
    bash /root/ai install plesk all \
        --source $AI_SOURCE \
        --ext-catalog-url $EXT_CATALOG \
        --preset Recommended \
        --without \
            config-troubleshooter advisor letsencrypt git \
            xovi imunifyav sslit repair-kit composer monitoring \
            log-browser ssh-terminal site-import \
        $AI_ARGS \
        ; \
    : Configure Plesk; \
    printf "[extensions]\ncatalog.url=${EXT_CATALOG}\n" >> /usr/local/psa/admin/conf/panel.ini; \
    printf "[taskManager]\nenabled=off\n" >> /usr/local/psa/admin/conf/panel.ini; \
    echo DOCKER > /usr/local/psa/var/cloud_id; \
    plesk bin license -i $LICENSE; \
    plesk bin init_conf --init -email changeme@example.com -passwd "changeme1Q**" -allow-weak-passwords -hostname-not-required; \
    plesk bin settings --set admin_info_not_required=true; \
    plesk bin poweruser --off; \
    plesk bin extension --install-url https://github.com/plesk/ext-default-login/releases/download/1.2-1/default-login-1.2-1.zip; \
    plesk bin cloning -u -prepare-public-image true -reset-license false -reset-init-conf false -skip-update true; \
    : Stop services and clean up; \
    /usr/lib/plesk-9.0/psa_service stopall; \
    plesk installer stop; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /root/ai /root/parallels /var/cache/parallels_installer /*.inf3 /pool /PHP* /SITEBUILDER* /run/lock/lmlib/*; \
    rm -f /usr/local/psa/admin/conf/panel.ini; \
    : Switch to real systemctl; \
    rm -f /bin/systemctl; \
    dpkg-divert --rename --remove /bin/systemctl; \
    :

COPY container-systemd-autologin.conf /etc/systemd/system/console-getty.service.d/override.conf
COPY plesk-cloning-set-password.conf /etc/systemd/system/plesk-cloning.service.d/password.conf

# Running image with any other command will execute it as PID 1, rendering systemctl broken
CMD ["/sbin/init"]

STOPSIGNAL SIGRTMIN+3

# Port to expose
# 21 - ftp
# 25 - smtp
# 53 - dns
# 80 - http
# 110 - pop3
# 143 - imaps
# 443 - https
# 3306 - mysql
# 8880 - plesk via http
# 8443 - plesk via https
# 8447 - autoinstaller
EXPOSE 21 80 443 8880 8443 8447

# vim: ts=4 sts=4 sw=4 et :
