#!/bin/bash

export PATH=/usr/lib/plesk-9.0:/usr/lib64/plesk-9.0:$PATH
find /var/lib/mysql -type f -exec touch {} \; && service mysql start
psa_service execute_actions
if [ -f /root/set_admin_password ]; then
    ADMIN_PASSWORD="changeme"
    [ -n "$PSA_PASSWORD" ] && ADMIN_PASSWORD=""
    plesk bin admin --set-password -passwd "$ADMIN_PASSWORD"
    rm /root/set_admin_password
fi
psa_service startall
plesk sbin pleskrc nginx start
cron
exec plesk log --all
