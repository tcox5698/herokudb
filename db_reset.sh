#!/bin/bash
export PGPASSWORD="password"
export DBWORK_DIR="./dbwork"
export CUR_DATE=`date "+%Y%m%d-%H:%M:%S"`
export SRC_DB="$1"
export TARGET_DB="$2"

if [ "$1" == "" -o   "$1" == "-h" -o "$2" == "" ]; then
    echo " "
    echo " "
    echo "Usage: ./db_reset [src_db] [target_db]"
    echo "  where [src_db] and [target_db] are names of postgres database instances"
    echo " "
    exit 0
fi


if [ ! -f $DBWORK_DIR/$SRC_DB.bak ] ; then
  echo "no backup file exists for $SRC_DB.  Expected: $DBWORK_DIR/$SRC_DB.bak"
  exit 0
fi

echo "resetting $TARGET_DB with the snapshot $DBWORK_DIR/$SRC_DB.bak"

psql -U postgres $TARGET_DB < db_disconnect_users.sql
dropdb -U postgres $TARGET_DB
createdb -U postgres $TARGET_DB
psql -U postgres $TARGET_DB < $DBWORK_DIR/$SRC_DB.bak

echo "$TARGET_DB has been restored from $DBWORK_DIR/$SRC_DB.bak"
