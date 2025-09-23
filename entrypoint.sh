#!/bin/bash

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle install
rails db:migrate
rails db:seed

echo "Starting Rails application..."

# Execute the main command
exec "$@"