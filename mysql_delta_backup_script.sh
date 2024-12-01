#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 -h HOSTNAME -P PORT -d DATABASE -u USERNAME -p PASSWORD -s START_DATE -e END_DATE -b BACKUP_FILE"
    echo "  -h HOSTNAME     The MySQL server hostname (default: localhost)."
    echo "  -P PORT         The MySQL server port (default: 3306)."
    echo "  -d DATABASE     The name of the database."
    echo "  -u USERNAME     The MySQL username."
    echo "  -p PASSWORD     The MySQL password."
    echo "  -s START_DATE   The start date (format: YYYY-MM-DD HH:MM:SS)."
    echo "  -e END_DATE     The end date (format: YYYY-MM-DD HH:MM:SS)."
    echo "  -b BACKUP_FILE  The name of the backup file."
    exit 1
}

# Default values
HOSTNAME="localhost"
PORT="3306"

# Parse arguments
while getopts ":h:P:d:u:p:s:e:b:" opt; do
  case $opt in
    h) HOSTNAME="$OPTARG" ;;
    P) PORT="$OPTARG" ;;
    d) DB_NAME="$OPTARG" ;;
    u) USERNAME="$OPTARG" ;;
    p) PASSWORD="$OPTARG" ;;
    s) START_DATE="$OPTARG" ;;
    e) END_DATE="$OPTARG" ;;
    b) BACKUP_FILE="$OPTARG" ;;
    *) usage ;;
  esac
done

# Validate arguments
if [ -z "$DB_NAME" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$START_DATE" ] || [ -z "$END_DATE" ] || [ -z "$BACKUP_FILE" ]; then
    usage
fi

# Get the list of tables created within the date range
TABLES=$(mysql -h "$HOSTNAME" -P "$PORT" -u "$USERNAME" -p"$PASSWORD" -N -B -e "
SELECT TABLE_NAME 
FROM information_schema.tables
WHERE TABLE_SCHEMA = '$DB_NAME'
  AND CREATE_TIME BETWEEN '$START_DATE' AND '$END_DATE';")

# Check if tables are found
if [ -z "$TABLES" ]; then
    echo "No tables found in the specified date range."
    exit 1
fi

# Backup the tables
echo "Backing up tables: $TABLES"
mysqldump -h "$HOSTNAME" -P "$PORT" -u "$USERNAME" -p"$PASSWORD" "$DB_NAME" $TABLES > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
else
    echo "Backup failed."
    exit 1
fi
