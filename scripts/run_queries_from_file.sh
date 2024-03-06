#!/bin/bash

export PGPASSFILE="../.pgpass"

set -e

# PostgreSQL server configuration
# =====================================================================
PORT="5432"
HOST="<host>"
USER="<user>"
DB_NAME="<db_name>"


# Logs output file path
# =====================================================================
LOG_FILE="../log/<log_file_name>"


# File containing SQL queries to run
# =====================================================================
INPUT_FILE="<my_file>.sql"


# Main command
# =====================================================================

psql --no-password --host="$HOST" --port="$PORT" --username="$USER" --dbname="$DB_NAME" \
-v ON_ERROR_STOP=1 --echo-all --echo-errors --echo-queries --log-file="$LOG_FILE" --file="$INPUT_FILE"
