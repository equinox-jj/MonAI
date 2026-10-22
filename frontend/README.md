# MonAI Frontend

The Flutter client for [MonAI](../README.md). It covers sign-in, home, transactions, wallets, categories, budgets, monthly reports, AI quick add, receipt scanning, CSV export, profile and settings, and talks to the [Go API](../backend/README.md).

- **Stack:** Flutter (Dart SDK `^3.13.5`), flutter_bloc, go_router, drift, dio, get_it, freezed + json_serializable, fpdart, flutter_secure_storage
- **Platforms:** Android is the primary target (`com.djtech.monai`). Receipt OCR uses a native ML Kit plugin, so it is Android-only for now.
- **Contract:** [`../backend/api/api-spec.yaml`](../backend/api/api-spec.yaml)

## Getting started

### Requirements

- Flutter with Dart SDK 3.13.5 or newer
- An Android emulator or device (with `adb` on your `PATH`)
- The backend running locally (see [`../backend/README.md`](../backend/README.md)), or a deployed API

### Run

```sh
flutter pub get
flutter run
```

The API base URL is a compile-time setting and defaults to `http://localhost:8080/api/v1`. On an emulator or device, forward the API and MinIO ports so `localhost` reaches your machine (MinIO serves avatars, receipts and provider logos):

```sh
adb reverse tcp:8080 tcp:8080
adb reverse tcp:9000 tcp:9000
```

To point at another server:

```sh
flutter run --dart-define=API_BASE_URL=https://api.example.com/api/v1
```

## Commands

| Command | What it does |
|---|---|
| `flutter pub get` | Installs dependencies |
| `flutter run [--dart-define=API_BASE_URL=…]` | Runs the app |
| `flutter analyze` | Runs the (strict) lints in `analysis_options.yaml` |
| `dart format lib test` | Formats the code (width 80) |
| `flutter test` | Runs all tests |
| `flutter test path/to/file_test.dart` / `--plain-name "…"` | Runs one file or one test by name |
| `./script/build_runner.sh` | Regenerates freezed, json_serializable and drift code. Run it after editing any `@freezed`, `@JsonSerializable` or drift class. Generated `*.freezed.dart` / `*.g.dart` files are committed. |
| `./script/gen_translate.sh` | Regenerates localizations after editing the ARB files |
| `dart run flutter_launcher_icons` / `dart run flutter_native_splash:create` | Regenerates the launcher icons and splash screen from their YAML configs |

## Architecture

Clean architecture, organized by feature, with `flutter_bloc` for state, `go_router` for navigation and `get_it` for dependency injection.

```
lib/
├── main.dart
├── app_router.dart          # routes and the session redirect
├── route_path.dart          # route paths (AppRoutes)
├── core/
│   ├── app/                 # DI (injector.dart), startup (session_helper.dart)
│   ├── base/                # base data source / repository / use case, error mapping
│   ├── data/                # database (drift), network (dio), storage, platform services
│   ├── model/               # enums shared by the DB, domain and UI
│   ├── ui/                  # design system (tokens, theme, icons, components), l10n
│   └── utils/               # formatting helpers and extensions
└── features/
    ├── auth, home, dashboard, transactions, wallets, categories, budgets,
    │   reports, quickadd, receipt, export, profile, settings
    └── shared/              # data and domain code used by more than one feature
```

Each feature has the same shape: `data/` (remote and local data sources, models, mappers, repository implementations), `domain/` (entities, repository interfaces, use cases), `presentation/` (pages with their blocs, widgets) and `di/` (its `get_it` registrations). Features never import each other; anything shared lives in `features/shared/`.

### Key rules

- **Errors:** data sources throw typed exceptions, and repositories convert them to `Either<Failure, T>` exactly once. Use cases return `Future<Either<Failure, T>>`, and the UI localizes from the backend's `error.code`.
- **Offline cache:** the drift database (`monai.sqlite`) caches server data for offline reading, with a full-text index for transaction search. It is a cache only: a schema change recreates the tables, and it is cleared on logout or when the session expires.
- **Session:** the access token lives in `flutter_secure_storage`. A `401` clears it and the cache, and a session-expired dialog covers the app until you sign in again.
- **AI quick add:** a local parser drafts transactions as you type; unclear drafts are sent to `POST /ai/parse-transaction`, falling back to the local result if the backend is slow or unavailable.
- **Receipts:** photos are compressed on the device, read with ML Kit, then parsed by `POST /ai/parse-receipt` into a draft you review before saving.
- **UI:** business logic lives only in use cases. Screens render state and forward events; widget rebuilds are kept narrow with `BlocSelector` / `buildWhen`.
- **Localization:** ARB files in `lib/core/ui/l10n/arb/` (English template, Indonesian preferred), accessed through `context.l10n`.

## Tests

Tests mirror `lib/` under `test/` and use `mocktail`. They cover use cases, blocs, repositories, data sources, the network layer, DAOs (on an in-memory database from `test/helpers/database_fixtures.dart`) and the router. Each test is structured as Arrange / Act / Assert.

```sh
flutter test
```
