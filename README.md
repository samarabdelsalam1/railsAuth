# Rails Authentication Project

A Ruby on Rails application demonstrating authentication functionality using Devise and Google OAuth2. This project includes both traditional email/password authentication and social login capabilities.

## Prerequisites

- Docker
- Docker Compose
- Git

## Technical Stack

- Ruby 3.3.5
- Rails 8.x
- PostgreSQL
- Node.js & Yarn

## Setup

1. Clone the repository
```bash
git clone <repository-url>
cd railsAuth
```

2. Set up environment variables
```bash
cp env.example .env
```

Edit `.env` and configure:
- Database credentials
- Google OAuth2 credentials (`GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`)

3. Build and start the application

First time setup:
```bash
docker compose build
```

Start the application:
```bash
docker compose up
```

The application will be available at `http://localhost:3000`

To run in detached mode:
```bash
docker compose up -d
```

To stop the application:
```bash
docker compose down
```

## Google OAuth2 Setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select an existing one
3. Enable the Google+ API
4. Go to Credentials
5. Create an OAuth 2.0 Client ID
6. Add authorized redirect URI: `http://localhost:3000/users/auth/google_oauth2/callback`
7. Copy the Client ID and Client Secret to your `.env` file

## Running Tests

Execute tests using Docker:
```bash
# Run all specs
docker compose exec rails_auth bundle exec rspec

# Run specific spec file
docker compose exec rails_auth bundle exec rspec spec/path/to/file_spec.rb

# Run specs with documentation format
docker compose exec rails_auth bundle exec rspec --format documentation

# Run specs and generate coverage report
docker compose exec rails_auth bundle exec rspec --format documentation --format html --out coverage/index.html
```

### Viewing Test Coverage

After running the tests with coverage, you can open the coverage report in your browser:
```bash
open coverage/index.html
```

## Common Docker Commands

```bash
# View running containers
docker compose ps

# View logs
docker compose logs

# Access Rails console
docker compose exec rails_auth rails console

# Run database migrations
docker compose exec rails_auth rails db:migrate

# Rebuild containers after Gemfile changes
docker compose build

# Open bash shell in container
docker compose exec rails_auth bash

# Check container status
docker compose ps rails_auth
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
