#!/bin/bash
export PGPASSWORD="password"
export DBWORK_DIR="./dbwork"
export CUR_DATE=`date "+%Y%m%d-%H:%M:%S"`
export TARGET_DB="$1"

if [ "$1" == ""  -o   "$1" == "-h" ]; then
    echo " "
    echo " "
    echo "Usage: ./db_backup [target_db]"
    echo "  where [target_db] is the name of a postgres database instance"
    echo " "
    exit 0
fi

if [ -f $DBWORK_DIR/$TARGET_DB.bak ] ; then
  mv $DBWORK_DIR/$TARGET_DB.bak $DBWORK_DIR/x$TARGET_DB.bak.$CUR_DATE
fi

pg_dump -U postgres -f $DBWORK_DIR/$TARGET_DB.bak $TARGET_DB

echo "$TARGET_DB has been backed up - BUT YOU BETTER VERIFY CAUSE NON-EXISTENT DBs BACKUP SUCCESSFULLY"