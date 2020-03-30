#!/bin/bash

docker build -t firebird:3.0 -f Dockerfile.fb-3.0 .

(
cat <<EOF
demo-1
demo-2
EOF
) >/tmp/databases.conf

docker rm -f firebird-ut

id=$(docker run -d --mount type=bind,source=/tmp/databases.conf,target=/etc/firebird/3.0/conf.d/databases.conf \
    -p 3050:3050 -e FIREBIRD_PASSWORD=admin --name firebird-ut firebird:3.0)
echo "${id}"

sleep 5

# Expect a client to be able to connect through the network and list the tables.
docker run --entrypoint=/bin/bash firebird:3.0 -c \
    "echo show tables\; | ISC_USER=machine ISC_PASSWORD=admin isql-fb host.docker.internal:demo-1"

#docker rm -f firebird-ut