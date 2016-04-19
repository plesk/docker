#!/bin/bash

for SERVICE in sw-engine sw-cp-server nginx mysql apache2; do
    service $SERVICE start
done
plesk bin ipmanage --reread
exec plesk log --all
