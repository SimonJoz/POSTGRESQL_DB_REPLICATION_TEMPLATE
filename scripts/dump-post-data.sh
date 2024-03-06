#!/bin/bash

export PGPASSFILE="../.pgpass"

# PostgreSQL server configuration
# =====================================================================
PORT="5432"
HOST="<host>"
USER="<user>"


# Logs output file path
# =====================================================================
LOG_FILE="logs/post-data-dump.log"


# Dump result output file path
# =====================================================================
OUTPUT_FILE="../schema/post-data-$(date +"%Y-%m-%d %H:%M:%S").sql"


# Functions
# =====================================================================

log() {
  local message="$1"
  echo "[$(date +"%Y-%m-%d %H:%M:%S")]: $message" | tee -a "$LOG_FILE"
}


# Main script execution - Perform the post-data schema dump.
# =====================================================================

log "INFO: Dumping post-data schema started."

time pg_dump --no-password --host="$HOST" --port="$PORT" --username="$USER" \
--schema-only --section=post-data --verbose --file="$OUTPUT_FILE" 2>&1 | tee -a "$LOG_FILE"

log "INFO: Dumping post-data schema completed."
