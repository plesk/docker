#!/bin/bash

# create temporary directories like systemd-tmpfiles does it
while read type path mode owner group age args; do
	[ -n "$path" ] || continue
	[ -n "${mode//-/}" ] && mode="--mode=$mode"		|| mode=
	[ -n "${owner//-/}" ] && owner="--owner=$owner"	|| owner=
	[ -n "${group//-/}" ] && group="--group=$group"	|| group=
	install $mode $owner $group -d "$path"
done <<<  `grep --no-filename -rE '^d\s' /usr/lib/tmpfiles.d/*.conf`

# create plesk-web-socket directory manually due fake systemctl can't do it
install -m 770 -o psaadm -g psaadm -d /run/plesk-web-socket

# mysql should be started by sysvinit script due fake systemctl can't handle `unset-environment`
find /var/lib/mysql -type f -exec touch {} \; && service mysql start

# remap IP
plesk bin reconfigurator --autoconfigure

# handle first run
if [ -f /root/first_run ]; then
	# start cloning that has been planned on image creation stage
	/opt/psa/admin/sbin/reset_instance_data start --do-what-I-say

	# admin password
	ADMIN_PASSWORD="changeme1Q**"
	[ -n "$PSA_PASSWORD" ] && ADMIN_PASSWORD=""
	plesk bin admin --set-password -passwd "$ADMIN_PASSWORD"

	rm /root/first_run
fi

# startup services required by Plesk
for s in psa sw-engine plesk-web-socket sw-cp-server apache nginx xinetd; do
	plesk sbin pleskrc "$s" start
done

cron
exec plesk log --all
