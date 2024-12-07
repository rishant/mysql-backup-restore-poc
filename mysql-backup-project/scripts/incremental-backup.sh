#!/bin/bash

BINLOG_DIR="/var/log/mysql"
BACKUP_DIR="/var/backups/incremental"
LAST_BACKUP_FILE="$BACKUP_DIR/last_binlog"
DATE=$(date +%F_%T)
MYSQL_USER="root"
MYSQL_PASSWORD="rootpassword"

mkdir -p "$BACKUP_DIR"

if [ -f "$LAST_BACKUP_FILE" ]; then
  LAST_BINLOG=$(cat "$LAST_BACKUP_FILE")
else
  LAST_BINLOG="mysql-bin.000001"
fi

echo "Starting incremental backup from binary log: $LAST_BINLOG..."
NEW_BINLOGS=$(mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW BINARY LOGS;" | awk '{print $1}' | grep -A 100 "$LAST_BINLOG" | tail -n +2)

for BINLOG in $NEW_BINLOGS; do
  mysqlbinlog "$BINLOG_DIR/$BINLOG" > "$BACKUP_DIR/incremental_backup_$DATE_$BINLOG.sql"
  echo "$BINLOG" > "$LAST_BACKUP_FILE"
done

echo "Incremental backup completed."
