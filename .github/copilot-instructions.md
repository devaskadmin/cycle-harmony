# Cycle Harmony – Copilot Instructions

## Project Overview
**Cycle Harmony** is a Flutter application targeting Android, iOS, Web, Windows, Linux, and macOS. It is currently in early scaffolding — the core app shell lives in `lib/main.dart`. The domain focus is menstrual/wellness cycle tracking (inferred from the name and theme).

## Architecture
- **Entry point:** `lib/main.dart` — contains `CycleHarmonyApp` (root `MaterialApp`) and `CycleHarmonyHome` (initial screen).
- **State management:** Not yet introduced. Add new features as `StatelessWidget` or `StatefulWidget` until a state management solution is chosen and documented here.
- **Theme:** Material 3 with `seedColor: Colors.pinkAccent`. All UI must use `Theme.of(context)` rather than hardcoded colors.
- **Package name:** `cycle_harmony` (used in imports, e.g. `package:cycle_harmony/main.dart`).

## SDK & Dependencies
- Flutter SDK, Dart `>=3.3.0 <4.0.0`
- `flutter_lints: ^3.0.0` — linting is enforced via `analysis_options.yaml` (includes `package:flutter_lints/flutter.yaml`)
- No third-party packages yet; add to `pubspec.yaml` and run `flutter pub get`

## Developer Workflows

```bash
# Get dependencies
flutter pub get

# Run on a connected device/emulator
flutter run

# Run all tests
flutter test

# Analyze for lint/type errors
flutter analyze

# Build for a specific platform
flutter build apk          # Android
flutter build web          # Web
flutter build windows      # Windows
```

## Conventions & Patterns
- All widgets use `const` constructors with `super.key` (see `CycleHarmonyApp` and `CycleHarmonyHome`).
- Each logical screen or feature should be placed in its own file under `lib/` (e.g. `lib/screens/home_screen.dart`).
- Prefer `ColorScheme`-based theming over direct color literals.
- Widget tests live in `test/` and import via `package:cycle_harmony/...`.

## Key Files
| File | Purpose |
|------|---------|
| [lib/main.dart](../lib/main.dart) | App root, theme, and home screen |
| [pubspec.yaml](../pubspec.yaml) | Dependencies and Flutter config |
| [analysis_options.yaml](../analysis_options.yaml) | Lint rules |
| [test/widget_test.dart](../test/widget_test.dart) | Smoke test for app shell |
