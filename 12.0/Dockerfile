# Plesk 12.0 container

FROM ubuntu:14.04

MAINTAINER plesk-dev-leads@plesk.com

ENV DEBIAN_FRONTEND noninteractive
ENV PLESK_DISABLE_HOSTNAME_CHECKING 1
ENV PSA_PASSWORD changeme

# allow services to start
RUN sed -i -e 's/exit.*/exit 0/g' /usr/sbin/policy-rc.d

RUN apt-get update \
    && apt-get install -y wget \
    && wget -q -O /root/ai http://autoinstall.plesk.com/plesk-installer \
    && chmod +x /root/ai \
    && /root/ai \
        --select-product-id=plesk \
        --select-release-id=PLESK_12_0_18 \
        --install-component common \
        --install-component panel \
        --install-component psa-autoinstaller \
        --install-component phpgroup \
        --install-component sitebuilder \
        --install-component web-hosting \
        --install-component mod_fcgid \
        --install-component proftpd \
        --install-component webservers \
        --install-component nginx \
        --install-component mysqlgroup \
        --install-component php5.6 \
    && plesk sbin ch_admin_passwd

CMD /etc/init.d/psa startall && exec plesk log --all

EXPOSE 21 80 8880
