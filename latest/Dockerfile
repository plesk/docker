# Plesk the latest available version container

FROM ubuntu:18.04

LABEL maintainer="plesk-dev-leads@plesk.com"

ARG LICENSE

ENV DEBIAN_FRONTEND noninteractive
ENV PLESK_DISABLE_HOSTNAME_CHECKING 1
ENV PORT 80
ENV HOST 0.0.0.0
ENV PORT 8880
ENV HOST 0.0.0.0
ENV PORT 443
ENV HOST 0.0.0.0
ENV PORT 8447
ENV HOST 0.0.0.0
ENV PORT 8443
ENV HOST 0.0.0.0
ENV PORT 21
ENV HOST 0.0.0.0
ENV PORT 22
ENV HOST 0.0.0.0

# allow services to start
RUN sed -i -e 's/exit.*/exit 0/g' /usr/sbin/policy-rc.d

ADD https://github.com/gdraheim/docker-systemctl-replacement/raw/master/files/docker/systemctl.py /usr/bin/systemctl

RUN apt-get update \
    && apt-get install -y \
        wget \
        libicu60 \
        tzdata \
    && wget -q -O /root/ai http://autoinstall.plesk.com/plesk-installer \
    && bash /root/ai \
        --all-versions \
        --select-product-id=plesk \
        --select-release-latest \
        --tier testing \
        --install-component panel \
        --install-component phpgroup \
        --install-component web-hosting \
        --install-component mod_fcgid \
        --install-component proftpd \
        --install-component webservers \
        --install-component nginx \
        --install-component mysqlgroup \
        --install-component php5.6 \
        --install-component php7.2 \
        --install-component l10n \
        --install-component heavy-metal-skin \
        --install-component git \
        --install-component passenger \
        --install-component ruby \
        --install-component nodejs \
        --install-component wp-toolkit \
    && plesk bin init_conf --init \
        -email changeme@example.com \
        -passwd changeme \
        -hostname-not-required \
    && plesk bin license -i $LICENSE \
    && plesk bin settings --set admin_info_not_required=true \
    && plesk bin poweruser --off \
    && plesk bin extension --install-url https://github.com/plesk/ext-default-login/releases/download/1.0-1/default-login-1.0-1.zip \
    && plesk bin cloning -u -prepare-public-image true -reset-license false -reset-init-conf false -skip-update true \
    && plesk bin ipmanage --auto-remap-ip-addresses true \
    && echo DOCKER > /usr/local/psa/var/cloud_id \
    && touch /root/set_admin_password \
    && apt-get clean \
    && rm -rf /root/ai /root/parallels

ADD run.sh /run.sh
CMD /run.sh

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
