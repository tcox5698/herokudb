#!/bin/bash

export DBWORK_DIR="./dbwork"
export CUR_DATE=`date "+%Y%m%d-%H:%M:%S"`
export SRC_ENV="$1"
export TARGET_ENV="$2"

if [ "$1" == "" -o   "$1" == "-h" -o "$2" == "" ]; then
    echo " "
    echo " "
    echo "Usage: ./heroku_txf [src_env] [target_env]"
    echo "  where [src_env] and [target_env] are heroku applications"
    echo " "
    exit 0
fi

heroku pgbackups:capture --app $SRC_ENV
heroku pgbackups:restore DATABASE `heroku pgbackups:url --app $SRC_ENV` --app $TARGET_ENV