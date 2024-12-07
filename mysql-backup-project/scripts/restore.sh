#!/bin/bash

BACKUP_DIR="/var/backups"
FULL_BACKUP="$BACKUP_DIR/full/full_backup.sql"
INCREMENTAL_DIR="$BACKUP_DIR/incremental"
MYSQL_USER="root"
MYSQL_PASSWORD="rootpassword"

echo "Restoring full backup..."
mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" < "$FULL_BACKUP"

if [ $? -eq 0 ]; then
  echo "Full backup restored successfully."
else
  echo "Full backup restore failed."
  exit 1
fi

echo "Applying incremental backups..."
for FILE in $(ls $INCREMENTAL_DIR/*.sql | sort); do
  echo "Applying $FILE..."
  mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" < "$FILE"
done

echo "Restore completed successfully."
