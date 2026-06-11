# Architecture

This project follows a layered Flutter application structure. The code is split
by responsibility rather than by screen alone, which keeps API integration,
domain modeling, state transitions, and UI composition separate.

## Top-Level Structure

```text
lib/
  config/         app constants, theme, router, Dio settings
  data/           API services, DTOs, mappers, repository implementations
  domain/         entities, repository contracts, use cases, utilities
  internal/       dependency composition and application bootstrap
  presentation/   screens, UI components, Redux state, view models
  resources/      generated asset references and sample data
```

## Application Bootstrap

`lib/main.dart` initializes the app runtime:

- defers the first frame while preload and platform services are prepared;
- initializes local storage through shared preferences and Hive;
- initializes Firebase with sanitized placeholder options;
- wires Crashlytics error handling;
- locks orientation to portrait before starting the Flutter app.

`lib/internal/application.dart` creates the root `MaterialApp.router`, sets up
localization/theme/routing, and provides the Redux store to the widget tree.

## Data Layer

The `data` layer owns external data formats and service communication.

- `data/api/service/` contains API service clients.
- `data/api/request/` contains request body models.
- `data/dto/` contains transport-oriented response models.
- `data/mapper/` converts DTOs into domain entities.
- `data/repository/` implements domain repository contracts.

`ApiUtil` acts as a facade over lower-level API services and local dictionary
storage. It calls remote services, maps DTOs, and reads/writes cached reference
data through Hive-backed services.

## Domain Layer

The `domain` layer contains app concepts independent of Flutter widgets and
network DTOs.

- `domain/entity/` defines business entities for users, dictionaries,
  protocols, map data, and selectable values.
- `domain/repository/` defines repository interfaces.
- `domain/use_cases/` coordinates user and protocol workflows.
- `domain/utils/` contains reusable services for storage, media, and map control.

This layer is where UI-facing flows get business-level operations without
depending directly on transport models.

## Presentation Layer

The `presentation` layer contains UI, navigation flows, Redux state, and
view-model projections.

- `presentation/pages/` contains feature screens for authentication, home,
  media, and protocol workflows.
- `presentation/uikit/` contains reusable UI widgets, buttons, inputs, loaders,
  map helpers, and painters.
- `presentation/state/actions/` defines state transition inputs.
- `presentation/state/reducers/` applies synchronous state updates.
- `presentation/state/thunk_actions/` coordinates async operations.
- `presentation/state/view_models/` shapes state for UI consumption.

The main inspection workflow is organized as a protocol flow with separate
screens for general information, territory, objects, media, representatives,
history, work categories, and work conditions.

## State Flow

The app uses Redux with thunk middleware:

```text
Widget event
  -> action or thunk action
  -> use case / repository / API facade
  -> DTO mapping or local storage
  -> Redux action
  -> reducer
  -> AppState
  -> view model
  -> widget rebuild
```

This keeps async work outside widgets and makes complex multi-step form state
explicit.

## Routing

Routing is handled through AutoRoute-generated files:

- `config/router/app_auto_router.dart`
- `config/router/app_auto_router.gr.dart`
- `config/router/home_route_guard.dart`

The router centralizes screen definitions and guards access based on local
session state.

## Local Persistence

The app uses two local persistence mechanisms:

- `shared_preferences` for lightweight session and preference values;
- `Hive` for structured cached data such as dictionaries and locally reused
  reference data.

This supports field-oriented workflows where parts of the app need fast access
to dictionary data and previously fetched records.

## External Integrations

The excerpt includes wiring for:

- REST APIs through Dio;
- Firebase Core and Crashlytics;
- camera/gallery/file-picker flows;
- map rendering and location-related features.

All production-specific config values are sanitized in this repository.

## Excerpt Limitations

This public repository is meant for architecture and implementation review.
Running it as-is requires replacing placeholder backend and Firebase values and
using a Flutter SDK compatible with the project's Dart constraint.
