#!/bin/sh

if [ $# -lt 3 ]; then
    echo "usage: $0 <database.fdb> <user> <password>";
    exit 1;
fi

dbfile=$1

if [ ! -f $dbfile ]; then
    echo "database file <$dbfile> not found";
    exit 1;
fi

user=$2
pass=$3

export=`basename -s .fdb $dbfile`

mkdir $export 2> /dev/null;

isql="isql-fb -u '${user}' -p '${pass}'"
iconv="iconv -f 'cp1251' -t 'UTF-8'"

$isql -ex -d /db_test/${export}_export.fdb $dbfile | sed -f fbexport.sed > $export/_meta.sql;

tables=`echo "SHOW TABLES;" | $isql "$dbfile"`;
for t in $tables; do
    fbexport -Si -D "$dbfile" -U "$user" -P "$pass" -E "WIN1251" -V $t | $iconv > $export/$t.sql;
done
