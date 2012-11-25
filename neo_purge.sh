#!/bin/bash
export NEO_PATH="$1"
export CUR_DATE=`date "+%Y%m%d-%H:%M:%S"`

if [ "$1" == ""  -o   "$1" == "-h" ]; then
    echo " "
    echo " "
    echo "Usage: ./neo_purge [path_to_neo_instance]"
    echo "  where [path_to_neo_instance] is the directory containing neo server"
    echo " "
    exit 0
fi

cd $NEO_PATH

# shutdown neo instance
./bin/neo4j stop
# backup neo database

zip -r neo_backup.$CUR_DATE.zip data
# delete neo database
rm -rf data
# create new neo database
mkdir data
# start neo instance
./bin/neo4j start
