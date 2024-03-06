#!/bin/bash

export PGPASSFILE="../.pgpass"

# PostgreSQL server configuration
# =====================================================================
PORT="5432"
HOST="<host>"
USER="<user>"


# Logs output file path
# =====================================================================
LOG_FILE="logs/globals-dump.log"


# Dump result output file path
# =====================================================================
OUTPUT_FILE="../schema/globals-$(date +"%Y-%m-%d %H:%M:%S").sql"


# Functions
# =====================================================================

log() {
  local message="$1"
  echo "[$(date +"%Y-%m-%d %H:%M:%S")]: $message" | tee -a "$LOG_FILE"
}


# Main script execution - Perform the global objects dump.
# =====================================================================

log "INFO: Dumping global objects started."

time pg_dumpall --no-password --host="$HOST" --port="$PORT" --username="$USER" \
--globals-only --no-role-passwords --verbose  --file="$OUTPUT_FILE" 2>&1 | tee -a "$LOG_FILE"

log "INFO: Dumping global objects completed."
