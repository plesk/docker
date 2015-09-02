#!/bin/bash

/etc/init.d/psa startall
plesk bin ipmanage --reread
/etc/init.d/nginx start
exec plesk log --all
