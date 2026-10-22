# MonAI Backend

The Go REST API for [MonAI](../README.md), consumed by the [Flutter app](../frontend/README.md). It handles accounts, wallets, categories, transactions, budgets, reports, the payment provider catalog, file uploads and AI-drafted transactions.

- **Stack:** Go 1.27.2, Fiber v3, Uber fx, GORM (pgx), PostgreSQL 18, MinIO, Gemini Flash-Lite (`google.golang.org/genai`), golang-migrate, Viper
- **Contract:** [`api/api-spec.yaml`](api/api-spec.yaml) (OpenAPI 3.1). Every path in it is implemented.
- **Base URL (local):** `http://localhost:8080/api/v1`

## Getting started

### Requirements

- Go 1.27.2 or newer
- Docker with Compose v2 (for PostgreSQL and MinIO)
- A Gemini API key (optional; without it, `/ai/*` returns `503`)

### 1. Configure

```sh
cp .env.example .env
```

Fill in the passwords and secrets. `.env.example` explains every variable. Generate secrets with `openssl rand -hex 32` (JWT) or `openssl rand -hex 24` (passwords). Use URL-safe characters for `DB_APP_PASSWORD`, since it goes into a connection URL.

Settings are read from environment variables first, then from `.env` in the current directory, so run the commands below from `backend/`.

### 2. Start PostgreSQL and MinIO

```sh
docker compose -f docker-compose.dev.yml up -d monai-db minio minio-init monai-db-init
```

| Service | Purpose |
|---|---|
| `monai-db` | PostgreSQL 18 on `127.0.0.1:5432` |
| `minio` | Object storage: API on `127.0.0.1:9000`, console on `127.0.0.1:9001` |
| `minio-init` | One-shot job: creates the buckets, the public-read policy, the rule that expires unattached receipts after a day, and the API's own MinIO user |
| `monai-db-init` | One-shot job: creates `DB_APP_USER`, a database role that can read and write rows but not change the schema |

Every port is bound to `127.0.0.1`. Both init jobs are safe to rerun.

### 3. Migrate, seed and run

```sh
go run ./cmd/migrate up     # apply migrations/ (also: down [N] | version | force V)
go run ./cmd/seed           # optional demo data (see Commands)
go run ./cmd/api            # serve on :8080
```

Check it with:

```sh
curl http://localhost:8080/api/v1/health
```

You can also run the API in a container. Run `docker compose -f docker-compose.dev.yml up -d --build api`, which connects as the limited `DB_APP_USER`. Apply migrations from your machine first.

## Commands

| Command | What it does |
|---|---|
| `go run ./cmd/api` | Starts the API |
| `go run ./cmd/migrate [up \| down [N] \| version \| force V]` | Runs the SQL migrations embedded from `migrations/`. `up` is the default; `down` rolls back one step unless you pass N. |
| `go run ./cmd/seed [--email] [--password] [--name] [--months]` | Development only. Creates a demo user (default `demo@monai.local` / `demo12345`) with Cash, BCA and GoPay wallets and 3 months of transactions. Does nothing if the email already exists, and refuses to run when `APP_ENV=production`. |
| `go run ./cmd/seed-admin --email you@example.com` | Promotes an existing user to `admin`. Nobody can register as an admin. A running API picks up the change within 1 minute. |
| `go build ./...` / `go vet ./...` | Builds or vets all packages || `go run golang.org/x/vuln/cmd/govulncheck@latest ./...` | Scans for known vulnerabilities (run it after bumping Go or a dependency) |

## Configuration

The main variables are listed below. See [`.env.example`](.env.example) for all of them.

| Variable | Notes |
|---|---|
| `APP_ENV` | `development` or `production`. Production switches to JSON logs and requires `MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY`. |
| `API_PORT` | Default `8080` |
| `DATABASE_URL` | Must include `timezone=UTC` |
| `DB_MAX_OPEN_CONNS`, `DB_MAX_IDLE_CONNS`, `DB_CONN_MAX_LIFETIME` | Connection pool settings (default `20` / `10` / `30m`) |
| `TRUSTED_PROXIES` | Comma-separated proxy IPs or CIDRs whose `X-Forwarded-For` header is trusted. Leave it empty locally; it is required behind a reverse proxy, or every client shares one rate-limit bucket. |
| `MINIO_*` | Endpoint, the API's own credentials, the bucket names (`expense-private`, `expense-public`) and `MINIO_PUBLIC_URL`, which presigned and public URLs are built with |
| `JWT_SECRET`, `JWT_ISSUER`, `JWT_ACCESS_TTL` | HS256 access token, valid for 7 days by default |
| `GEMINI_API_KEY`, `GEMINI_MODEL`, `GEMINI_TIMEOUT` | Leave the key empty to turn off `/ai/*` |

## API overview

| Area | Endpoints |
|---|---|
| Auth | `POST /auth/register`, `POST /auth/login`, `POST /auth/logout-all`, `PUT /auth/password` |
| Profile | `GET/PATCH/DELETE /me`, `PUT/DELETE /me/avatar` |
| Wallets | `GET/POST /wallets`, `GET/PATCH/DELETE /wallets/{id}` |
| Categories | `GET/POST /categories`, `PATCH/DELETE /categories/{id}` |
| Transactions | `GET/POST /transactions`, `GET/PATCH/DELETE /transactions/{id}`, `POST /transactions/{id}/restore`, `POST /transactions/receipt` |
| Budgets | `GET/PUT/DELETE /budgets/{month}` |
| Reports | `GET /reports/monthly` |
| AI | `POST /ai/parse-transaction`, `POST /ai/parse-receipt` |
| Providers | `GET /payment-providers` (public, ETag), `/admin/payment-providers/**` (requires a permission) |
| Health | `GET /health` (pings PostgreSQL and MinIO) |

### Conventions

- Every response uses the envelope `{ success, message, data }`. `meta` is added on paginated lists, and `error: { code, fields }` on failures. Clients branch on `error.code`; `message` is only an English fallback.
- JSON keys are snake_case and enums are UPPER_SNAKE_CASE. IDs are UUIDs, dates are `YYYY-MM-DD`, and timestamps are RFC 3339 in UTC.
- Money is an integer number of whole rupiah (`BIGINT` / `int64`), never a float.
- Optional fields are returned as `null` and empty lists as `[]`; neither is ever left out.
- Requesting another user's record returns `404 not_found`, not `403`.
- Auth uses `Authorization: Bearer <JWT>`. `POST /auth/logout-all` and `PUT /auth/password` revoke every older token immediately.

## Project layout

A modular monolith organized by feature, with a thin controller → service → repository stack in each feature.

```
backend/
├── api/api-spec.yaml        # OpenAPI 3.1 contract
├── cmd/
│   ├── api/                 # composition root: wires every fx module, starts Fiber
│   ├── migrate/             # golang-migrate runner
│   ├── seed/                # dev demo data
│   └── seed-admin/          # promote a user to admin
├── internal/
│   ├── auth, user, rbac, wallet, category, transaction,
│   │   budget, report, provider, health
│   ├── ai/                  # TransactionParser interface, draft sanitizing
│   │   └── gemini/          # Gemini implementation
│   └── platform/            # shared infrastructure, no business logic
│       ├── config/          # Viper: env vars, then .env
│       ├── database/        # GORM setup, transaction manager, error helpers
│       ├── httpx/           # server, envelope, validation, pagination, auth, rate limits
│       ├── storage/         # MinIO: upload, presigned GET, stat, delete
│       ├── logger/, period/, security/
└── migrations/              # versioned .sql files (000001–000015)
```

Each feature package contains `controller.go`, `service.go`, `repository.go`, `model.go` (GORM entities), `dto.go` (request and response types), `errors.go`, `routes.go` and `module.go` (its fx module). Only `module.go` files and `cmd/` import fx. Everything else is a plain constructor that takes interfaces.

### Key rules

- **Ownership:** every query on user data filters by the `user_id` from the token. The transaction → wallet and transaction → category foreign keys include `user_id`.
- **Derived values are never stored.** Wallet balances, budget progress and reports are always calculated from `transactions`.
- **RBAC is data-driven.** `roles`, `permissions` and `role_permissions` live in the database, and routes check permission codes, never role names. Permissions are loaded per request and cached for 1 minute.
- **Multi-step operations run in one DB transaction:** registering (user, Cash wallet and default categories), switching the default wallet, and deleting a category with `move_to`.
- **Uploads:** the content type is detected from the file's bytes. Receipts first land in `receipts-pending/` and move to `receipts/` when attached to a transaction. A background cleaner deletes receipts of transactions soft-deleted more than 30 days ago.
- **AI safeguards:** the backend validates every draft field and sets invalid ones to `null`: unknown IDs, a category of the wrong type, a non-positive amount or a future date. The quick-add parse gives up after 3 seconds so the app can fall back to its local parser.
- **Rate limits** cover register, login, password change, account deletion, uploads, `/health` and `/ai/*`.
- **Logging** never includes tokens, passwords, query strings or request bodies.

## Deployment

[`docker-compose.prod.yml`](docker-compose.prod.yml) is a production stack meant for [Dokploy](https://dokploy.com), with Compose Path `./backend/docker-compose.prod.yml`.

- It publishes no host ports. Traefik routes one domain to `api:8080` and one to `minio:9000` (the public files domain).
- Startup order: `monai-db` and `minio` become healthy, then the one-shot `minio-init`, `monai-db-init` and `migrate` jobs run, then `api` starts.
- Required variables: `POSTGRES_PASSWORD`, `DB_APP_PASSWORD`, `MINIO_ROOT_USER`/`MINIO_ROOT_PASSWORD`, `MINIO_ACCESS_KEY`/`MINIO_SECRET_KEY`, `MINIO_PUBLIC_URL`, `JWT_SECRET`, and `TRUSTED_PROXIES` (Traefik's network CIDR). The stack refuses to start without them.
- The [`Dockerfile`](Dockerfile) builds a distroless image containing `/api`, `/migrate` and `/seed-admin`. It has no shell, so run tools with `docker exec <api container> /seed-admin --email …`.
- `api` connects as the limited `DB_APP_USER`, and `migrate` as the database owner. Run migrations through the `migrate` service.
- Set the secrets before the first deploy. PostgreSQL and MinIO keep the credentials they were first started with in their volumes.
