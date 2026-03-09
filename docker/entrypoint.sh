#!/bin/bash
set -e

echo "Starting Horilla HR..."

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
while ! nc -z db 5432; do
  sleep 1
done
echo "PostgreSQL is ready!"

# Run migrations
echo "Running migrations..."
python manage.py makemigrations --noinput
python manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

# Compile translations
echo "Compiling translations..."
python manage.py compilemessages || echo "Warning: compilemessages failed (non-fatal)"

echo "Starting server..."
exec "$@"
