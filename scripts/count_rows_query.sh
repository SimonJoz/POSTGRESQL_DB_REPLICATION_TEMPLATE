#!/bin/bash

export PGPASSFILE="../.pgpass"

set -e

# PostgreSQL server configuration
PORT="5432"
HOST="<host>"
USER="<user>"
DB_NAME="<db_name>"


# Logs output file path
LOG_FILE="../log/<log_file_name>"


# List of tables to query
TABLES=(
  "table1"
  "table2"
)

# Main logic
for table in "${TABLES[@]}";
do

 query="SELECT COUNT(*) FROM $table;"

 psql --no-password --host="$HOST" --port="$PORT" --username="$USER" --dbname="$DB_NAME" \
 -v ON_ERROR_STOP=1 --echo-all --echo-errors --echo-queries --log-file="$LOG_FILE" --command="$query"

done


