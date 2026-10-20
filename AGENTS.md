# Agents

MA Studio E-Commerce: a Flutter catalog application (Windows/PowerShell environment).

## Commands

Run from the repo root:

- Install dependencies: `flutter pub get`
- Static analysis: `flutter analyze`
- Run all tests: `flutter test`
- Run a single suite: `flutter test test/shopping_bag_selection_test.dart`
- Run the app: `flutter run --debug`

## Project Layout

- `lib/main.dart`: entry point. `main()` awaits `MockDataService().initialize()` before `runApp` — keep that ordering, the catalog Initializers provide JSON-seeded data.
- `lib/helpers`: utilities such as currency formatting.
- `lib/models`: domain models.
- `lib/services`: data layer; `MockDataService` (JSON assets) is currently the single source of truth.
- `lib/screens`: screens, incl. `splash` (home) and `catalog` subtrees.
- `lib/widgets`: shared UI components.
- `test/`: unit suites for the currency helper, department repository, feature product, and shopping-bag selection, plus widget tests.

## Conventions

- Design tokens and the Figma mapping live in `docs/UI_SPEC_HANDOFF.md`; the in-app theme mirrors them via `AppColors` and `GoogleFonts.interTextTheme` (assembled in `lib/main.dart`).
- `DevicePreview` wraps the app only when `!kReleaseMode` — keep it debug-gated.
- Assets are registered in `pubspec.yaml` (`assets/json/`, `assets/images/`, `assets/icons/`, `assets/images/products/`, `assets/images/category/`, `assets/icons/category-horizental/`); add new media directories there.
- `analysis_options.yaml` applies stock `package:flutter_lints/flutter.yaml` — no custom rules; verification is `flutter analyze`.
- `supabase/` exists but is empty — no backend wiring yet; do not assume APIs.
- No CI is configured; use the commands above directly.
- `lib/screens/catalog/product_list_screen.dart` currently has uncommitted local edits — coordinate before overwriting.

## Skills

- Project-local skills live under `.agents/skills/` (`brand`, `design`, `banner-design`, ...). Consult `brand` and `design` before UI changes that touch logo, palette, or visual identity.

## Documentation

- `docs/project_overview.md`: app orientation (flows, list layout, page snippets).
- `docs/UI_SPEC_HANDOFF.md`: Figma "Midterm_Project" spec — 440x956, Terracotta (`0xFF864433`) primary UI accent, Onyx Black content, Feather White surface.
- `docs/TECHNICAL_OVERVIEW.md`: older 4-layer design intent; the current tree predates it — when it disagrees with the code, trust the code.
