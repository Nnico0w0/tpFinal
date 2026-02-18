#!/bin/bash
# Docker entrypoint script to wait for database before starting Django

set -e

# Validate required environment variables
if [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ] || [ -z "$DB_USER" ]; then
    echo "Error: Required environment variables are not set"
    echo "Please ensure DB_HOST, DB_PORT, and DB_USER are defined"
    exit 1
fi

# Configuration
MAX_RETRIES=30
RETRY_COUNT=0

# Wait for database to be ready
echo "Waiting for database connection at $DB_HOST:$DB_PORT..."
while ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" > /dev/null 2>&1; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "Error: Database failed to become available after $MAX_RETRIES attempts"
        exit 1
    fi
    echo "Database is unavailable - sleeping (attempt $RETRY_COUNT/$MAX_RETRIES)"
    sleep 2
done

echo "Database is up - continuing..."

# Run migrations
echo "Running database migrations..."
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start server
echo "Starting Django server..."
exec "$@"
