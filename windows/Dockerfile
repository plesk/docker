# Plesk the latest available version container

FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL maintainer="plesk-dev-leads@plesk.com"

ARG LICENSE
ARG AI_HOST=installer-win.plesk.com

RUN powershell -Command \
    wget https://$env:AI_HOST/plesk-installer.exe -OutFile C:\plesk-installer.exe ; \
    \
    C:\plesk-installer.exe install panel release \
    --source https://$env:AI_HOST \
    --preset Recommended \
    --options "PLESK_INSTALLDIR=C:\Plesk" \
    --options "PLESK_DATADIR=C:\PleskData" \
    --options "PLESK_VHOSTSDIR=C:\PleskVhosts" \
    --tries 9 ; \
    \
    Remove-Item C:\plesk-installer.exe ; \
    Remove-Item -Recurse -Force C:\ProgramData\Plesk\Installer

RUN powershell -Command Set-Content -Path 'C:\PleskData\var\cloud_id' -Value 'DOCKER'

RUN powershell -Command \
    C:\Plesk\bin\init_conf.exe \
    --init \
    -email changeme@example.com \
    -passwd changeme1Q** \
    -allow-weak-passwords \
    -hostname-not-required ; \
    \
    C:\Plesk\bin\license.exe -i $env:LICENSE ; \
    C:\Plesk\bin\settings.exe --set admin_info_not_required=true ; \
    C:\Plesk\bin\settings.exe --set login_timeout=3600 ; \
    C:\Plesk\bin\poweruser.exe --off

ADD https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.10/ServiceMonitor.exe C:/ServiceMonitor.exe

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

ENTRYPOINT  ["C:\\ServiceMonitor.exe", "w3svc"]
