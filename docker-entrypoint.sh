#!/bin/bash
# Docker entrypoint script to wait for database before starting Django

set -e

# Wait for database to be ready
echo "Waiting for database connection..."
while ! pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" > /dev/null 2>&1; do
    echo "Database is unavailable - sleeping"
    sleep 1
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
