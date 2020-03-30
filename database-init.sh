#!/bin/bash

DB_DIR=/var/lib/firebird/3.0/data
INIT_DIR=/etc/firebird/3.0/init

GENERATED_FILES=(
    "db_create_tables.sql"
    "db_create_index.sql"
)

function database_init() {
    export FIREBIRD_DATABASE=$1

    exits=$(grep /var/lib/firebird/3.0/data/${FIREBIRD_DATABASE} /etc/firebird/3.0/databases.conf)
    if [ "$?" -ne 0 ]; then
        echo "${FIREBIRD_DATABASE} = /var/lib/firebird/3.0/data/${FIREBIRD_DATABASE}.fdb" >> /etc/firebird/3.0/databases.conf
    fi

    cat "${INIT_DIR}/db_create.sql" | envsubst | isql-fb

    for filename in ${GENERATED_FILES[@]}; do
        isql-fb -i "${GEN_CONF_DIR}/${filename}" "${DB_DIR}/${FIREBIRD_DATABASE}.fdb"
    done

    isql-fb -i "${INIT_DIR}/db_auth.sql" "${DB_DIR}/${FIREBIRD_DATABASE}.fdb"
}

