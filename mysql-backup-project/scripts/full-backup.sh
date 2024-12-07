#!/bin/bash

BACKUP_DIR="/var/backups/full"
DATE=$(date +%F_%T)
MYSQL_USER="root"
MYSQL_PASSWORD="rootpassword"

mkdir -p "$BACKUP_DIR"

echo "Starting full backup..."
mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --all-databases --flush-logs --routines --events > "$BACKUP_DIR/full_backup_$DATE.sql"

if [ $? -eq 0 ]; then
  echo "Full backup completed: $BACKUP_DIR/full_backup_$DATE.sql"
else
  echo "Full backup failed."
fi
