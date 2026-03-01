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
- If you encounter permission errors for mounted volumes, run:

```bash
sudo chown -R $(id -u):$(id -g) .
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
