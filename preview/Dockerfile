# Plesk next version preview container

FROM ubuntu:14.04

MAINTAINER plesk-dev-leads@odin.com

ENV DEBIAN_FRONTEND noninteractive
ENV PLESK_DISABLE_HOSTNAME_CHECKING 1

# allow services to start
RUN sed -i -e 's/exit.*/exit 0/g' /usr/sbin/policy-rc.d

RUN apt-get update \
    && apt-get install -y wget \
    && wget -q -O /root/ai http://autoinstall.plesk.com/plesk-installer \
    && chmod +x /root/ai \
    && /root/ai \
        --all-versions \
        --select-product-id=plesk \
        --select-release-id=PLESK_12_5_29 \
        --install-component panel \
        --install-component phpgroup \
        --install-component web-hosting \
        --install-component mod_fcgid \
        --install-component proftpd \
        --install-component webservers \
        --install-component nginx \
        --install-component mysqlgroup \
        --install-component php5.6 \
        --install-component l10n \
        --install-component heavy-metal-skin \
    && plesk bin init_conf --init \
        -email changeme@example.com \
        -passwd changeme \
        -hostname-not-required \
    && plesk bin license -i A00H00-327Q03-HD4W13-0BDZ18-V0E652 \
    && plesk bin settings --set admin_info_not_required=true \
    && plesk bin poweruser --off \
    && plesk db "DELETE FROM IP_Addresses" \
    && plesk db "DELETE FROM ip_pool"

ADD run.sh /run.sh
CMD /run.sh

EXPOSE 21 80 8880
