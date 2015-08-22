#!/bin/bash

/etc/init.d/psa startall
plesk bin ipmanage --reread
exec plesk log --all
