#!/bin/bash

DB_HOST="54.232.148.128"
DB_USER="root"
DB_PASS="4tu0Myz3quhTj3aO"
DB_NAMES=("pagoveloz_db")
BACKUP_PARENT_DIR="/var/backups/sql"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$BACKUP_PARENT_DIR/backup_$TIMESTAMP.log"

mkdir -p "$BACKUP_PARENT_DIR/$TIMESTAMP"

exec 2> "$LOG_FILE"

for DB in "${DB_NAMES[@]}"; do
    TARGET_FILE="$BACKUP_PARENT_DIR/$TIMESTAMP/${DB}.sql.gz"
    
    mysqldump --opt --single-transaction --extended-insert \
        -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB" \
        | gzip -9 > "$TARGET_FILE"
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        SIZE=$(du -sh "$TARGET_FILE" | cut -f1)
        echo "Success: $DB ($SIZE)" >> "$LOG_FILE"
    else
        echo "Failure: $DB" >> "$LOG_FILE"
        rm -f "$TARGET_FILE"
    fi
done

find "$BACKUP_PARENT_DIR" -maxdepth 1 -type d -mtime +14 -exec rm -rf {} +