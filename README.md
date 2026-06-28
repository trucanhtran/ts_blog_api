# ts_blog — Quick Start

Minimal instructions to run the application for local development using Docker.

Technologies

- Ruby: 4.0.1
- Rails: ~> 8.1.2
- PostgreSQL: 17
- Redis: 7

Quick start (Docker Compose)

Build and start:

```bash
docker compose build
docker compose up --build
```

Install gems and prepare DB (optional):

```bash
docker compose run --rm web bundle install --jobs 4 --retry 3
docker compose run --rm web bin/rails db:create db:migrate
docker compose up
```

Stop and remove volumes:

```bash
docker compose down -v
```

Notes

- The project is mounted at `/rails` in the container. `docker-compose.yml` runs
  `bundle check || bundle install` on startup if gems are missing.

### Authentication API

Devise with JWT is configured for JSON-based user signup/login:

1. **Sign up** – `POST /api/v1/signup` with JSON body:

   ```json
   {
     "user": {
       "email": "user@example.com",
       "password": "...",
       "password_confirmation": "...",
       "name": "..."
     }
   }
   ```

   On success you'll receive `201 Created`, the new user object, and an
   `Authorization: Bearer <token>` header.

2. **Login** – `POST /api/v1/login` with similar body. Successful response is
   `200 OK` plus the JWT header.

3. **Logout** – `DELETE /api/v1/logout` invalidates the supplied token (include
   `Authorization` header).

All other API controllers derive from `Api::BaseController`; requests require
an authenticated user (pass the JWT in `Authorization: Bearer`).

Code quality (Rubocop - Rails Omakase)

Run linter:

```bash
docker compose run --rm web bundle exec rubocop
```

Fix issues automatically:

```bash
docker compose run --rm web bundle exec rubocop -A
```

Main folders

- `app/` — controllers, models, views
- `bin/` — scripts (rails, thrust, docker-entrypoint)
- `config/` — routes, environments, credentials
- `db/` — migrations, seeds
- `lib/` — libraries
- `log/`, `tmp/` — logs and temporary files
- `public/` — static and compiled assets
- `storage/` — Active Storage files
