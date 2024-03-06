#!/bin/bash

export PGPASSFILE="../.pgpass"

set -e

# Source Configuration
# =====================================================================
SOURCE_HOST="<source_host>"
SOURCE_PORT="5432"
SOURCE_USER="<source_user>"
SOURCE_DB_NAME="<source_db_name>"
NO_OF_DUMP_JOBS=1


# Target Configuration
# =====================================================================
TARGET_HOST="<target_host>"
TARGET_PORT="5432"
TARGET_USER="<target_user>"
TARGET_DB_NAME="<target_db_name>"
NO_OF_RESTORE_JOBS=1


# Logs output file path
# =====================================================================
LOG_FILE="../logs/dump-restore-data.log"


# List of tables/partitions to dump and restore
# =====================================================================
TABLES=(
  "table1"
  "table2"
)

# Functions
# =====================================================================

log() {
  local message="$1"
  echo "[$(date +"%Y-%m-%d %H:%M:%S")]: $message" | tee -a "$LOG_FILE"
}

dump() {
  local table="$1"
  local dir="$2"

  log "INFO: Dumping table '$table'."

  time pg_dump --no-password --host="$SOURCE_HOST" --port="$SOURCE_PORT" --username="$SOURCE_USER" \
  --dbname="$SOURCE_DB_NAME" --table="$table" --verbose --section=data --data-only \
  --jobs="$NO_OF_DUMP_JOBS" --compress=0 --format=d --file="$dir" 2>&1 | tee -a "$LOG_FILE"

  log "INFO: Dumping completed in for table '$table'."
}

restore() {
  local table="$1"
  local dir="$2"

  log "INFO: Restoring table '$table'."

  time pg_restore --no-password --host="$TARGET_HOST" --port="$TARGET_PORT" --username="$TARGET_USER" \
  --dbname="$TARGET_DB_NAME" --exit-on-error --verbose --section=data --data-only --jobs="$NO_OF_RESTORE_JOBS" \
  --format=d --file="$dir" 2>&1 | tee -a "$LOG_FILE"

  log "INFO: Restoring completed for table '$table'."
}


# Main script execution - Perform dump and restore of given tables.
# =====================================================================

for table in "${TABLES[@]}"; do
  log "INFO: Process started."

  dir="${table}_dump"
  mkdir -p "$dir"

  dump "$table" "$dir"
  restore "$table" "$dir"

  rm -r "$dir"

  log "INFO: Process completed."
done
