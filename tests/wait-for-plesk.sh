#!/bin/bash
### Copyright 1999-2024. WebPros International GmbH.

COUNTER=1

while : ; do
    curl -ksL https://plesk:8443/ | grep "<title>Plesk" > /dev/null
    if [ $? -eq 0 ]; then
        echo "Plesk was successfully initialized."
        exit 0
    fi
    echo "($COUNTER) Waiting for the Plesk initialization..."
    sleep 5
    COUNTER=$((COUNTER + 1))
    if [ $COUNTER -eq 60 ]; then
        echo "Too long, interrupting..."
        exit 1
    fi
done
