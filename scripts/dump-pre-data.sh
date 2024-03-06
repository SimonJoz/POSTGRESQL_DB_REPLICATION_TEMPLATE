#!/bin/bash

export PGPASSFILE="../.pgpass"

# PostgreSQL server configuration
# =====================================================================
PORT="5432"
HOST="<host>"
USER="<user>"


# Logs output file path
# =====================================================================
LOG_FILE="logs/pre-data-dump.log"


# Dump result output file path
# =====================================================================
OUTPUT_FILE="../schema/pre-data-$(date +"%Y-%m-%d %H:%M:%S").sql"


# Functions
# =====================================================================

log() {
  local message="$1"
  echo "[$(date +"%Y-%m-%d %H:%M:%S")]: $message" | tee -a "$LOG_FILE"
}


# Main script execution - Perform the pre-data schema dump.
# =====================================================================

log "INFO: Dumping pre-data schema started."

time pg_dump --no-password --host="$HOST" --port="$PORT" --username="$USER" \
--schema-only --section=pre-data --verbose --file="$OUTPUT_FILE" 2>&1 | tee -a "$LOG_FILE"

log "INFO: Dumping pre-data schema completed."
