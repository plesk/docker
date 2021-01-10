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

if [ "x$MYSQL_HOST" = "x" ]; then
	# mysql should be started by sysvinit script due fake systemctl can't handle `unset-environment`
	chmod +x /usr/sbin/mysqld
	find /var/lib/mysql -type f -exec touch {} \; && service mysql start
fi

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

if [ "x$MYSQL_HOST" != "x" ]; then
	mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD psa < /root/psa.sql
	mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD < /root/apsc.sql
	mysql -h $MYSQL_HOST -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON apsc.* TO 'admin'@'%';"
	echo -e "[general]\ndatabase.dbname=psa\ndatabase.username=admin\ndatabase.host=$MYSQL_HOST\ndatabase.password=$MYSQL_PASSWORD" > /etc/psa/private/dsn.ini
	plesk bin settings -s aps_login=admin
	plesk bin settings -s aps_host=$MYSQL_HOST
	plesk bin settings -s aps_password=$MYSQL_PASSWORD
fi

# startup services required by Plesk
for s in psa sw-engine plesk-web-socket sw-cp-server apache nginx xinetd bind9; do
	[ "$s" = "bind9" -a ! -f /lib/systemd/system/bind9.service ] && continue
	plesk sbin pleskrc "$s" start
done

cron
exec plesk log --all
