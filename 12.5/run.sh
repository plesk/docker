#!/bin/bash

export PATH=/usr/lib/plesk-9.0:/usr/lib64/plesk-9.0:$PATH
psa_service execute_actions
psa_service startall
plesk sbin pleskrc nginx start
exec plesk log --all
