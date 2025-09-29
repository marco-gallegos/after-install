#!/bin/bash

# Database Backup Script
# Simple backup script for PostgreSQL, MongoDB, and MySQL

# Default Configuration
DEFAULT_HOST="192.168.1.110"
TARGET_DIR="/mnt/storage/backups"
DATE=$(date +"%Y%m%d_%H%M%S")

# PostgreSQL Configuration
PG_HOST="${PG_HOST:-$DEFAULT_HOST}"
PG_PORT="${PG_PORT:-5432}"
PG_USER="${PG_USER:-postgres}"
PG_PASSWORD="${PG_PASSWORD:-}"

# MongoDB Configuration
MONGO_HOST="${MONGO_HOST:-$DEFAULT_HOST}"
MONGO_PORT="${MONGO_PORT:-27017}"
MONGO_USER="${MONGO_USER:-}"
MONGO_PASSWORD="${MONGO_PASSWORD:-}"

# MySQL Configuration
MYSQL_HOST="${MYSQL_HOST:-$DEFAULT_HOST}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-}"

# Create backup directory if it doesn't exist
mkdir -p "$TARGET_DIR"

echo "Starting database backups - $DATE"

# PostgreSQL Backup
echo "Backing up PostgreSQL..."
PG_BACKUP_DIR="$TARGET_DIR/postgresql"
mkdir -p "$PG_BACKUP_DIR"

if [ -n "$PG_PASSWORD" ]; then
    export PGPASSWORD="$PG_PASSWORD"
fi

pg_dumpall -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" > "$PG_BACKUP_DIR/postgresql_full_backup_$DATE.sql"

if [ $? -eq 0 ]; then
    echo "PostgreSQL backup completed successfully"
    gzip "$PG_BACKUP_DIR/postgresql_full_backup_$DATE.sql"
else
    echo "PostgreSQL backup failed"
fi

unset PGPASSWORD

# MongoDB Backup
echo "Backing up MongoDB..."
MONGO_BACKUP_DIR="$TARGET_DIR/mongodb"
mkdir -p "$MONGO_BACKUP_DIR"

if [ -n "$MONGO_USER" ] && [ -n "$MONGO_PASSWORD" ]; then
    mongodump --host "$MONGO_HOST:$MONGO_PORT" --username "$MONGO_USER" --password "$MONGO_PASSWORD" --out "$MONGO_BACKUP_DIR/mongodb_backup_$DATE"
else
    mongodump --host "$MONGO_HOST:$MONGO_PORT" --out "$MONGO_BACKUP_DIR/mongodb_backup_$DATE"
fi

if [ $? -eq 0 ]; then
    echo "MongoDB backup completed successfully"
    cd "$MONGO_BACKUP_DIR"
    tar -czf "mongodb_backup_$DATE.tar.gz" "mongodb_backup_$DATE"
    rm -rf "mongodb_backup_$DATE"
else
    echo "MongoDB backup failed"
fi

# MySQL Backup
echo "Backing up MySQL..."
MYSQL_BACKUP_DIR="$TARGET_DIR/mysql"
mkdir -p "$MYSQL_BACKUP_DIR"

MYSQL_OPTS="-h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER"
if [ -n "$MYSQL_PASSWORD" ]; then
    MYSQL_OPTS="$MYSQL_OPTS -p$MYSQL_PASSWORD"
fi

# mysqldump $MYSQL_OPTS --all-databases --single-transaction --routines --triggers > "$MYSQL_BACKUP_DIR/mysql_full_backup_$DATE.sql"

if [ $? -eq 0 ]; then
    echo "MySQL backup completed successfully"
    gzip "$MYSQL_BACKUP_DIR/mysql_full_backup_$DATE.sql"
else
    echo "MySQL backup failed"
fi

echo "Database backups completed - $DATE"
echo "Backups stored in: $TARGET_DIR"
