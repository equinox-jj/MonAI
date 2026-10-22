# MonAI

MonAI is an expense tracker for people in Indonesia who pay with a mix of cash, bank accounts and e-wallets (GoPay, OVO, DANA, …). Logging a transaction should take under 5 seconds: type it in, scan a receipt, or write a short phrase such as `makan siang 35rb pakai gopay` and let the AI fill in the draft.

![MonAI: home, AI quick add, receipt scan, monthly report, wallets and dark mode](frontend/screenshots/showcase.png)

This repository is a monorepo with two apps:

| Folder | What it is | Stack |
|---|---|---|
| [`frontend/`](frontend/README.md) | The mobile client | Flutter, Dart 3.13, flutter_bloc, go_router, drift, dio, get_it |
| [`backend/`](backend/README.md) | The REST API | Go, Fiber v3, Uber fx, GORM, PostgreSQL 18, MinIO, Gemini |

## Features

- **Wallets:** cash, bank, e-wallet and other wallets, each linked to a provider from a shared catalog. Balances are always calculated from the transactions.
- **Transactions:** income, expenses and transfers, with search, cursor pagination, soft delete and restore, and receipt photos.
- **Categories and budgets:** default categories are created when you register, and you can set a monthly budget (status `OK`, `WARNING` or `EXCEEDED`).
- **Reports:** monthly totals and a breakdown by category, compared with the previous month.
- **AI quick add:** an offline parser on the phone turns a phrase into drafts as you type. When the amount or category is unclear, the backend asks Gemini.
- **Receipt scanning:** ML Kit reads the text on the phone, then the backend turns it into a draft. Nothing is saved until you confirm.
- **Auto-categorization:** checks your history first, then keywords, then the AI.
- **CSV export**, English and Indonesian UI, light and dark themes, and offline reading from a local drift (SQLite) cache.
- **Admin:** role-based access control (RBAC) driven by data in the database, and a screen in Settings for managing the payment provider catalog.

## Screenshots

<table>
  <tr>
    <td align="center"><img src="frontend/screenshots/05-home.png" width="200" alt="Home"/><br/><sub>Home</sub></td>
    <td align="center"><img src="frontend/screenshots/06-home-budget-spending.png" width="200" alt="Budget and spending on Home"/><br/><sub>Budget and spending</sub></td>
    <td align="center"><img src="frontend/screenshots/08-ai-quick-add.png" width="200" alt="AI quick add"/><br/><sub>AI quick add</sub></td>
    <td align="center"><img src="frontend/screenshots/09-ai-quick-add-review.png" width="200" alt="Reviewing a quick-add draft"/><br/><sub>Review drafts</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="frontend/screenshots/10-receipt-scan-draft.png" width="200" alt="Draft from a scanned receipt"/><br/><sub>Receipt scan</sub></td>
    <td align="center"><img src="frontend/screenshots/11-transactions.png" width="200" alt="Transaction list"/><br/><sub>Transactions</sub></td>
    <td align="center"><img src="frontend/screenshots/12-transaction-search.png" width="200" alt="Transaction search"/><br/><sub>Search</sub></td>
    <td align="center"><img src="frontend/screenshots/14-add-expense.png" width="200" alt="Add an expense"/><br/><sub>Add expense</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="frontend/screenshots/16-wallets.png" width="200" alt="Wallets"/><br/><sub>Wallets</sub></td>
    <td align="center"><img src="frontend/screenshots/17-wallet-detail.png" width="200" alt="Wallet detail"/><br/><sub>Wallet detail</sub></td>
    <td align="center"><img src="frontend/screenshots/19-monthly-report.png" width="200" alt="Monthly report"/><br/><sub>Monthly report</sub></td>
    <td align="center"><img src="frontend/screenshots/07-monthly-budget.png" width="200" alt="Set a monthly budget"/><br/><sub>Monthly budget</sub></td>
  </tr>
</table>

**Dark theme**

<table>
  <tr>
    <td align="center"><img src="frontend/screenshots/24-dark-home.png" width="200" alt="Home in dark theme"/></td>
    <td align="center"><img src="frontend/screenshots/26-dark-transactions.png" width="200" alt="Transactions in dark theme"/></td>
    <td align="center"><img src="frontend/screenshots/27-dark-wallets.png" width="200" alt="Wallets in dark theme"/></td>
    <td align="center"><img src="frontend/screenshots/28-dark-settings.png" width="200" alt="Settings in dark theme"/></td>
  </tr>
</table>

<details>
<summary>More screens</summary>

<table>
  <tr>
    <td align="center"><img src="frontend/screenshots/01-onboarding-quick-add.png" width="200" alt="Onboarding: quick add"/><br/><sub>Onboarding</sub></td>
    <td align="center"><img src="frontend/screenshots/02-onboarding-wallets.png" width="200" alt="Onboarding: wallets"/><br/><sub>Onboarding</sub></td>
    <td align="center"><img src="frontend/screenshots/03-onboarding-budget.png" width="200" alt="Onboarding: budget"/><br/><sub>Onboarding</sub></td>
    <td align="center"><img src="frontend/screenshots/04-login.png" width="200" alt="Sign in"/><br/><sub>Sign in</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="frontend/screenshots/13-transaction-detail.png" width="200" alt="Transaction detail"/><br/><sub>Transaction detail</sub></td>
    <td align="center"><img src="frontend/screenshots/15-transfer.png" width="200" alt="Transfer between wallets"/><br/><sub>Transfer</sub></td>
    <td align="center"><img src="frontend/screenshots/18-add-wallet.png" width="200" alt="Add a wallet"/><br/><sub>Add wallet</sub></td>
    <td align="center"><img src="frontend/screenshots/20-monthly-report-categories.png" width="200" alt="Report by category"/><br/><sub>Report by category</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="frontend/screenshots/21-categories.png" width="200" alt="Categories"/><br/><sub>Categories</sub></td>
    <td align="center"><img src="frontend/screenshots/22-settings.png" width="200" alt="Settings"/><br/><sub>Settings</sub></td>
    <td align="center"><img src="frontend/screenshots/23-export-csv.png" width="200" alt="CSV export"/><br/><sub>CSV export</sub></td>
    <td align="center"><img src="frontend/screenshots/25-dark-home-budget-spending.png" width="200" alt="Budget and spending in dark theme"/><br/><sub>Dark: budget and spending</sub></td>
  </tr>
</table>

</details>

## Architecture

```mermaid
flowchart LR
    App["Flutter app<br/>(drift cache)"] -- "REST + JWT<br/>/api/v1" --> API["Go API<br/>(Fiber)"]
    API --> DB[("PostgreSQL")]
    API --> S3[("MinIO<br/>avatars · receipts · logos")]
    API --> AI["Gemini<br/>Flash-Lite"]
    App -. "presigned / public URLs" .-> S3
```

- The API is the source of truth. The app reads from its local cache and needs a connection to create, edit or delete.
- Files (avatars, receipts, provider logos) are uploaded to the API as `multipart/form-data`. The API stores them in MinIO and returns presigned URLs that expire after 15 minutes for private files, or public URLs for provider logos.
- Only the backend calls Gemini, and it sends as little data as possible. AI endpoints return drafts only and never save anything.
- The API contract is [`backend/api/api-spec.yaml`](backend/api/api-spec.yaml) (OpenAPI 3.1). Both apps follow it.

## Quick start

You need Docker (with Compose), Go 1.27.2+, Flutter (Dart SDK 3.13.5+), and an Android emulator or device.

```sh
# 1. Backend: Postgres, MinIO, migrations, API on http://localhost:8080/api/v1
cd backend
cp .env.example .env          # then fill in the passwords and secrets
docker compose -f docker-compose.dev.yml up -d monai-db minio minio-init monai-db-init
go run ./cmd/migrate up
go run ./cmd/seed             # optional: demo@monai.local / demo12345 with 3 months of data
go run ./cmd/api

# 2. Frontend: forward the API and MinIO ports to the device, then run
cd ../frontend
adb reverse tcp:8080 tcp:8080
adb reverse tcp:9000 tcp:9000
flutter pub get
flutter run
```

See [`backend/README.md`](backend/README.md) and [`frontend/README.md`](frontend/README.md) for configuration, commands, tests and deployment.

## Repository layout

```
MonAI/
├── frontend/   # Flutter app (package monai, Android id com.djtech.monai)
└── backend/    # Go API, SQL migrations, Docker Compose stacks, OpenAPI spec
```
