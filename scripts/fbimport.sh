#!/bin/sh

if [ $# -lt 4 ]; then
    echo "usage: $0 <database.fdb> <path> <user> <password>";
    exit 1;
fi

dbfile=$1

if [ ! -f $dbfile ]; then
    echo "database file <$dbfile> not found";
    exit 1;
fi

path=$2
user=$3
pass=$4

meta="_meta";

isql="isql-fb -q -u '${user}' -p '${pass}' -ch UTF8" 

if [ ! -f $path/$meta.sql ]; then
    echo "${path}/${meta}.sql not found";
    exit;
fi

if [ ! -f $dbfile ]; then
    echo "creating database $dbfile from metadata";
    $isql -i $path/$meta.sql;
fi

for f in $path/*.sql; do
    table=`basename -s .sql $f`;
    if [ $table != $meta ]; then
        echo "$table <- $f";
        $isql -i $f $dbfile;
    fi
done