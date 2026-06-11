# Greenspaces App Excerpt

Portfolio excerpt of a Flutter mobile application for green-space inspection
workflows. The original app supported field workers who create and manage
inspection protocols, attach media, work with map-based territory data, and
sync structured records with a backend.

This repository is a sanitized code excerpt. Production backend URLs, Firebase
identifiers, and client-specific Android/iOS package IDs have been replaced with
placeholders.

## What This Shows

- Flutter mobile application structure for Android and iOS.
- Layered code organization: `data`, `domain`, `presentation`, and `internal`.
- REST API integration through `Dio` with DTOs, mappers, repositories, and use
  cases.
- Redux-style state management with actions, reducers, thunk actions, and view
  models.
- Protocol creation flows with multi-step forms, media attachments, history,
  representatives, territory selection, and work category screens.
- Map UI based on `flutter_map`, location markers, custom layers, and clustering.
- Local persistence setup with `Hive` and `shared_preferences`.
- Firebase initialization and Crashlytics wiring with placeholder config.

## Tech Stack

- Flutter / Dart
- Redux, `flutter_redux`, `redux_thunk`
- Dio
- Hive / Hive Flutter
- Firebase Core / Crashlytics
- AutoRoute
- Flutter Map, LatLng, geolocation, compass
- Camera, photo manager, file picker, gallery saver

## Project Layout

```text
lib/
  config/         app constants, theme, routing, Dio setup
  data/           API services, DTOs, mappers, repositories
  domain/         entities, repository contracts, use cases, utilities
  internal/       app composition and dependency modules
  presentation/   pages, UI kit, Redux state, view models
  resources/      generated asset references and sample data
```

## Sanitization Notes

The repository is intended for code review and portfolio inspection, not as a
drop-in runnable production app.

- Firebase config files contain placeholder project IDs and API keys.
- Backend API base URL is set to `https://api.example.invalid`.
- Android package ID is `com.example.greenspaces_portfolio`.
- iOS bundle ID is `com.example.greenspacesPortfolio`.
- Generated build output, IDE metadata, and local Flutter state are excluded.

## Local Setup

This project targets an older Flutter/Dart toolchain:

```yaml
environment:
  sdk: ">=2.17.5 <3.3.3"
```

Use a compatible Flutter SDK before running dependency resolution or analysis.
With a matching SDK, the typical commands are:

```bash
flutter pub get
flutter analyze
flutter test
```

Code generation commands used by the original project:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
```

## Status

This is a portfolio excerpt with sanitized configuration. It is useful for
reviewing architecture, state management, UI flows, API integration, and mobile
project organization.
