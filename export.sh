#!/bin/bash

sed -i -e '/RemoteBindAddress =/ s/= .*/= /' /etc/firebird/2.5/firebird.conf

fbguard -d

ISC_USER=sysdba ISC_PASSWORD=masterkey isql-fb "${MOUNTED_DIR}/${DATABASE_NAME}" -ex -o "${MOUNTED_DIR}/db_meta.sql"

if [ -f "/usr/local/bin/tables.conf" ]; then
    readarray -t TABLE_NAMES <"/usr/local/bin/tables.conf"
fi

for tablename in ${TABLE_NAMES[@]}; do
    fbexport -S -H "" -D "${MOUNTED_DIR}/${DATABASE_NAME}" -U sysdba -P masterkey -F "${MOUNTED_DIR}/${tablename}.fbx" -V ${tablename}
done
