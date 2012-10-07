#!/bin/bash

export DBWORK_DIR="./dbwork"
export CUR_DATE=`date "+%Y%m%d-%H:%M:%S"`
export PROD_ENV="$1"
export STAGE_ENV="$2"
export LOCAL_STAGEDB="$3"
export LOCAL_TESTDB="$4"
export LOCAL_DEVDB="$5"
export PROJECT_DIR="$6"
export DBSCRIPTS_DIR=$PWD

if [ "$1" == "" -o   "$1" == "-h" -o "$2" == "" -o "$3" == "" -o "$4" == "" -o "$5" == "" -o "$6" == "" ]; then
    echo " "
    echo " "
    echo "Usage: ./stageLocally [prod_env] [stage_env] [local_stagedb] [local_testdb] [local_devdb] [abs_project_directory]"
    echo "  where [prod_env] and [stage_env] are heroku applications"
    echo " "
    echo " This script executes the following:"
    echo " 1. Copies DB from heroku [prod_env] to [stage_env]"    
    echo " 2. Dumps [stage_env] to a local dump file"
    echo " 3. Restores the dump file into the [local_stagedb]"
    echo " 4. Copies the [local_stagedb] to the [local_testdb] and [local_devdb]"
    echo " 5. Performs grails dbm-update on [local_testdb] and [local_devdb]"
    echo " 6. Purges the [local_testdb] so it is ready for automated tests"
    echo " 7. Runs grails test-app"    
    echo " 8. Starts the grails app so you can test it yourself."
    echo ""
    exit 0
fi

bash heroku_txf.sh $PROD_ENV $STAGE_ENV

bash heroku_backup.sh $STAGE_ENV

bash db_restore_from_dump.sh $LOCAL_STAGEDB $STAGE_ENV.dump

bash db_reset.sh $LOCAL_STAGEDB $LOCAL_TESTDB

bash db_reset.sh $LOCAL_STAGEDB $LOCAL_DEVDB

cd $PROJECT_DIR
grails dbm-update -Dgrails.env=dev
grails dbm-update -Dgrails.env=test

cd $DBSCRIPTS_DIR
bash db_purge.sh $LOCAL_TESTDB

cd $PROJECT_DIR
grails test-app

echo "STARTING THE APP SO YOU CAN TEST IT"
grails run-app

exit 1