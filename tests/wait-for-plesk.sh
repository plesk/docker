#!/bin/bash
### Copyright 1999-2024. WebPros International GmbH.

COUNTER=1

while : ; do
    curl -ksL https://localhost:8443/ | grep "<title>Plesk" > /dev/null
    [ $? -eq 0 ] && exit 0
    echo "($COUNTER) Waiting for the Plesk initialization..."
    sleep 5
    COUNTER=$((COUNTER + 1))
    if [ $COUNTER -eq 60 ]; then
        echo "Too long, interrupting..."
        exit 1
    fi
done
