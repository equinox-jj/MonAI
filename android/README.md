# MonAI Android

The Android client for [MonAI](../README.md), an expense tracker for Indonesian users. Amounts are in rupiah and the default time zone is `Asia/Jakarta`. It talks to the Go API in [`../backend`](../backend/README.md), whose contract is [`../backend/api/api-spec.yaml`](../backend/api/api-spec.yaml).

## Features

- **Auth:** register, login, sign out of every device, change password, delete account, and session-expiry handling
- **Home:** total balance, wallets, monthly spending, budget status and recent transactions
- **Transactions:** a paged list with offline full-text search, an add/edit form, a detail screen, receipt photos, and delete and restore
- **Wallets, categories, monthly budgets and reports**
- **Quick add:** type `makan siang 35rb pakai gopay` and get drafts as you type, without a network connection. The AI is asked only when the amount or category is unclear.
- **Receipt scanning:** capture with CameraX, read the text on the phone with ML Kit, then the backend builds a draft
- **Auto-categorization:** your history first, then keywords, then the AI
- **CSV export, profile and avatar, settings** (including the admin screen for the payment provider catalog)
- English and Indonesian, light and dark themes, and layouts for phones and tablets (forms open as side sheets on wide screens)

## Tech stack

| Area | Libraries |
|---|---|
| Language and build | Kotlin 2.4, AGP 9.4, Gradle 9.6, KSP, version catalog in [`gradle/libs.versions.toml`](gradle/libs.versions.toml) |
| UI | Jetpack Compose (BOM), Material 3, Navigation 3, Coil 3, SplashScreen |
| DI | Hilt |
| Network | Retrofit 3, OkHttp 5, kotlinx.serialization |
| Local data | Room 3 (bundled SQLite, FTS4), Paging 3 with RemoteMediator, DataStore with a Keystore AES-GCM token cipher |
| Camera and ML | CameraX, ML Kit Text Recognition (bundled Latin model) |
| Async | Kotlin coroutines and Flow |
| Tests | JUnit 4, kotlinx-coroutines-test, OkHttp MockWebServer, Paging testing, Compose UI tests, Hilt testing |

- **SDK levels:** `minSdk 26`, `compileSdk` and `targetSdk 37`, Java 11 bytecode
- **Package:** `com.djtech.monai`

## Getting started

### Requirements

- A recent Android Studio that supports AGP 9.4, or JDK 17+ for command-line builds
- An Android emulator or device running API 26+
- The backend running locally for the `dev` flavor (see [`../backend/README.md`](../backend/README.md))

### Build flavors

There is one flavor dimension, `environment`:

| Flavor | Application ID | API base URL | Notes |
|---|---|---|---|
| `dev` | `com.djtech.monai.dev` ("MonAI Dev") | `http://10.0.2.2:8080/api/v1/` | `10.0.2.2` is your machine as seen from the emulator. Cleartext HTTP is allowed only in this flavor (`src/dev`). Installs alongside `prod`. |
| `prod` | `com.djtech.monai` | Gradle property `monai.apiBaseUrl` | Set in [`gradle.properties`](gradle.properties), or override with `-Pmonai.apiBaseUrl=https://…/api/v1/`. HTTPS only. |

Both flavors expose the URL as `BuildConfig.API_BASE_URL`.

Images from local MinIO (avatars, receipts, provider logos) are signed for `localhost:9000`. After every `assembleDevDebug` or `installDevDebug`, the `adbReverseMinio` task runs `adb reverse tcp:9000 tcp:9000` so the device can load them. Run it again by hand with `./gradlew adbReverseMinio` if you reconnect the device.

### Run

```sh
./gradlew installDevDebug
```

You can also open `android/` in Android Studio and run the `devDebug` variant. With the backend's demo data seeded, sign in as `demo@monai.local` / `demo12345`.

## Commands

Run these from `android/`:

```sh
./gradlew assembleDevDebug                # build the dev flavor (local backend)
./gradlew installDevDebug                 # install on a device or emulator
./gradlew assembleProdRelease             # build the production release (R8 on)
./gradlew testDevDebugUnitTest            # JVM unit tests
./gradlew testDevDebugUnitTest --tests "com.djtech.monai.core.network.ApiCallerTest"   # one class
./gradlew testDevDebugUnitTest --tests "*ApiCallerTest.someMethodName"                # one test
./gradlew connectedDevDebugAndroidTest    # instrumented tests (needs a device)
./gradlew lintDevDebug                    # Android lint
```

The release build is signed with the debug key so it installs locally. Use a real keystore before uploading to the Play Store. R8 keep rules are in `app/src/main/keepRules/rules.keep`.

## Architecture

The app has a single `:app` module organized by feature, with clean-architecture layers and MVI in the UI.

```
app/src/main/java/com/djtech/monai/
├── core/
│   ├── common/        # Outcome result type, AppClock, dispatchers, UiText, EffectQueue, Rupiah formatting
│   ├── database/      # Room read cache: entities, DAOs, FTS search, paging remote keys
│   ├── datastore/     # SessionStore (encrypted token, session state), onboarding, theme, search history
│   ├── designsystem/  # MonAITheme tokens, shared components, icons
│   ├── di/            # Network, database, datastore, dispatcher modules
│   ├── media/         # image processing for uploads
│   ├── model/         # plain domain models (User, Wallet, Transaction, …)
│   └── network/       # ApiCaller, error mapping, auth interceptor and authenticator, uploads
├── feature/
│   ├── auth, home, transactions, quickadd, receipt, wallets,
│   ├── categories, budgets, reports, profile, settings, export
│   └── <feature>/{data, domain, presentation}
└── navigation/        # Navigation 3 route keys, tab shell, one <Feature>Navigation.kt per flow
```

The data flows **Retrofit/Room → repository → use case → ViewModel → screen**.

- **Data:** each feature's `data/` holds its Retrofit `<Name>ApiService`, DTOs, mappers and `Api<Name>Repository`. Every call goes through `ApiCaller`, which returns `Outcome<T, ApiError>` instead of throwing. Repositories map API errors to feature errors and write results into Room.
- **Offline reads:** the API is the source of truth, and Room is a read-only cache. Writes go to the API first, then the repository caches the result. The cache is wiped on sign-out or session expiry.
- **Domain:** each operation is its own use case (`<Verb><Thing>UseCase`). ViewModels never call repositories directly. Validation lives in use cases.
- **Presentation:** strict MVI. Each screen has one immutable `State`, `Intent`s handled by a single entry point, and one-off `Effect`s for navigation and snackbars. Each screen folder holds `<Screen>Contract.kt`, `<Screen>Screen.kt` and `<Screen>ViewModel.kt`, plus `components/`, `model/`, `mapper/` and `preview/` subfolders.
- **Auth:** `AuthInterceptor` adds the bearer token from memory. There is no refresh token, so a 401 on an authenticated request ends the session and the app shows a "session expired" dialog.
- **AI drafts:** a field with confidence below `0.7` is highlighted for review. Drafts travel between screens inside serializable route keys, so they survive process death. Nothing is saved until the user confirms.

## Tests

- **Unit tests** (`src/test`) cover repositories, use cases, ViewModels, network error mapping, interceptors, stores, validators and the quick-add parser. They use in-memory repository fakes and shared model builders (`core/model/ModelFixtures.kt`).
- **Instrumented tests** (`src/androidTest`) cover Room DAOs (with an in-memory database) and Compose screens. They run with `HiltTestRunner`.
- **Quick-add golden set:** `src/test/resources/golden/quick_add_phrases.json` scores the local parser in `QuickAddGoldenTest`. At least 80% of phrases must be handled without the AI, and at most 5% of the fields it marks as sure may be wrong. Add real phrases there whenever a parse goes wrong.
