#!/bin/bash
export PGPASSWORD="password"
export DBWORK_DIR="./dbwork"
export CUR_DATE=`date "+%Y%m%d-%H:%M:%S"`
export TARGET_DB="$1"

if [ "$1" == ""  -o   "$1" == "-h" ]; then
    echo " "
    echo " "
    echo "Usage: ./db_purge [target_db]"
    echo "  where [target_db] is the name of a postgres database instance"
    echo " "
    exit 0
fi

if [ -f $DBWORK_DIR/$TARGET_DB.binbak ] ; then
  mv $DBWORK_DIR/$TARGET_DB.binbak $DBWORK_DIR/x$TARGET_DB.binbak.$CUR_DATE
fi

pg_dump -U postgres -Fc -f $DBWORK_DIR/$TARGET_DB.binbak $TARGET_DB

echo "$TARGET_DB has been binary backed up - BUT YOU BETTER VERIFY CAUSE NON-EXISTENT DBs BACKUP SUCCESSFULLY"

./db_drop_create.sh $TARGET_DB

# pgrestore schema only
pg_restore --verbose --schema-only --clean --no-acl --no-owner -h localhost -U postgres -d $TARGET_DB $DBWORK_DIR/$TARGET_DB.binbak


