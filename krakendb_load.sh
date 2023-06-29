#!/bin/bash

# Kraken DB files and hashes
DB_PATH=$1
DB_HASH='hash.k2d'
DB_OPTS='opts.k2d'
DB_TAXO='taxo.k2d'
MD5_HASH="0ef062f3dae7f497fe258f67c2e542fe"
MD5_OPTS="e77f42c833b99bf91a8315a3c19f83f7"
MD5_TAXO="f6591859824de9d1893002d5e8d1eee0"

OLDDIR=`pwd`
OLDIFS=$IFS; IFS=",";
cd $DB_PATH

# Check existing DB files or download new ones
for PAIR in $DB_OPTS,$MD5_OPTS $DB_TAXO,$MD5_TAXO
do
    SPLIT=($=PAIR)
    FILE=$SPLIT[1]
    HASH=$SPLIT[2]
    if [ ! -r $FILE ]
    then
        wget -c https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/$FILE
    elif [ `md5 -q $FILE` != $HASH ]
    then
        wget -c https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/$FILE
    fi
done

# Restore variables
IFS=$OLDIFS
cd $OLDDIR