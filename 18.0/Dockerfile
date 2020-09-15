# Plesk the latest available version container

FROM ubuntu:18.04

LABEL maintainer="plesk-dev-leads@plesk.com"

ARG LICENSE
ARG AI_HOST=autoinstall.plesk.com

ENV DEBIAN_FRONTEND noninteractive
ENV PLESK_DISABLE_HOSTNAME_CHECKING 1

# allow services to start
RUN sed -i -e 's/exit.*/exit 0/g' /usr/sbin/policy-rc.d

# prepare fake systemctl
ADD https://github.com/gdraheim/docker-systemctl-replacement/raw/master/files/docker/systemctl.py /usr/bin/systemctl
# disable annoing log entities that have no sense in ubuntu18 and setup permissions
RUN sed -i '/^\s*logg.error("the ..include. syntax is deprecated. Use x.service.d. drop-in files!")$/d' /usr/bin/systemctl \
    && chmod 755 /usr/bin/systemctl \
    && ln -s /usr/bin/systemctl /bin/systemctl

RUN apt-get update \
    && apt-get install -y \
        wget \
        libicu60 \
        tzdata \
    && wget -q -O /root/ai http://$AI_HOST/plesk-installer \
    && bash /root/ai \
        --all-versions \
        --source http://$AI_HOST \
        --select-product-id=plesk \
        --select-release-latest \
        --install-component panel \
        --install-component phpgroup \
        --install-component web-hosting \
        --install-component mod_fcgid \
        --install-component proftpd \
        --install-component webservers \
        --install-component nginx \
        --install-component mysqlgroup \
        --install-component php7.3 \
        --install-component l10n \
        --install-component heavy-metal-skin \
        --install-component wp-toolkit \
    && plesk bin init_conf --init \
        -email changeme@example.com \
        -passwd changeme1Q** \
        -hostname-not-required \
    && plesk bin license -i $LICENSE \
    && plesk bin settings --set admin_info_not_required=true \
    && plesk bin poweruser --off \
    && plesk bin extension --install-url https://github.com/plesk/ext-default-login/releases/download/1.1-1/default-login-1.1-1.zip \
    && plesk bin cloning -u -prepare-public-image true -reset-license false -reset-init-conf false -skip-update true \
    && echo DOCKER > /usr/local/psa/var/cloud_id \
    && touch /root/first_run \
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
