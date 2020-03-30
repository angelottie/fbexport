#!/bin/bash

sed -i -e '/RemoteBindAddress =/ s/= .*/= /' /etc/firebird/2.5/firebird.conf

fbguard -d

TABLE_NAMES=(
    "ARTIKEL"
    "BEST"
    "BESTERL"
    "BESTPOS"
    "CUSTOMER"
    "EINHEIT"
    "FIRMA"
    "LIEFRANT"
    "LIEFRANTERL"
    "NEBENKOS"
    "PEINHEIT"
    "REWAKON"
    "REWAKONABWMWST"
    "REWAKONERL"
    "REWAKONPOS"
    "REWAKONPROTOKOLL"
    "WAEIN"
    "WAEINERL"
    "WAEINPOS"
    "WAEINPOSP"
    "WANEBKOS"
    "WANEBKOSDEL"
)

for tablename in ${TABLE_NAMES[@]}; do
    fbexport -S -H "" -D "${MOUNTED_DIR}/${DATABASE_NAME}" -U sysdba -P masterkey -F "${MOUNTED_DIR}/${tablename}.fbx" -V ${tablename}
done
