#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Wait for database to be ready
echo "Waiting for database..."
while ! pg_isready -h rails_auth_db -p 5432 -U ${POSTGRES_USER} -d ${POSTGRES_DB} -q; do
  echo "Database is not ready yet. Waiting..."
  sleep 2
done

while ! pg_isready -h test_rails_auth_db -p 5432 -U ${POSTGRES_USER} -d ${POSTGRES_TEST_DB} -q; do
  echo "Test database is not ready yet. Waiting..."
  sleep 2
done

echo "Database is ready!"

# Install/update bundle
echo "Running bundle install..."
bundle install

# Create databases if they don't exist
echo "Creating databases if they don't exist..."
bundle exec rails db:create

# Run migrations
echo "Running database migrations..."
bundle exec rails db:migrate

# Run seeds
echo "Running database seeds..."
bundle exec rails db:seed

# Install and sign overcommit if present
if [ -f .overcommit.yml ]; then
  echo "Setting up overcommit..."
  bundle exec overcommit --install
  bundle exec overcommit --sign
fi

echo "Starting Rails application..."

# Execute the main command
exec "$@"