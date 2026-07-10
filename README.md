<p align="center">
  <img src="https://raw.githubusercontent.com/kripadevg-code/ag-cli/main/assets/logo.png" alt="ag_cli logo" width="120"/>
</p>

<h1 align="center">ag_cli</h1>

<p align="center">
  <strong>The Flutter GetX CLI that developers actually love.</strong><br/>
  Scaffold production-ready modules in seconds — not hours.
</p>

<p align="center">
  <a href="https://pub.dev/packages/ag_cli"><img src="https://img.shields.io/pub/v/ag_cli.svg?label=pub.dev&color=blue" alt="Pub Version"/></a>
  <a href="https://pub.dev/packages/ag_cli/score"><img src="https://img.shields.io/pub/points/ag_cli?color=brightgreen&label=pub%20points" alt="Pub Points"/></a>
  <a href="https://github.com/kripadevg-code/ag-cli/actions"><img src="https://github.com/kripadevg-code/ag-cli/workflows/CI/badge.svg" alt="CI"/></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"/></a>
</p>

---

> **Angular CLI for Flutter.** `ag_cli` does for GetX what Angular CLI does for Angular — one command wires up every layer of your architecture, tested and ready to ship.

---

## Why ag_cli?

Every Flutter GetX developer knows the grind: copy-paste a controller, wire up the binding, register the route, create the service, write the repo… for every single feature. It's repetitive, error-prone, and eats hours.

`ag_cli` eliminates all of it.

One command generates a complete, production-grade module — controller with debounced search, paginated repo, Dio service, typed binding with `fenix: true`, animated app bar, filter chips, and auto-injected routes. Every file is wired together, every import correct, on the first try.

**What the best alternatives give you:**

| Feature | `get_cli` | `mason` (templates) | `ag_cli` |
|---|:---:|:---:|:---:|
| Interactive arrow-key prompts | ❌ | ❌ | ✅ |
| Auto-injects routes into existing files | ❌ | ❌ | ✅ |
| Debounced search + history baked in | ❌ | ❌ | ✅ |
| Smart Refresh (no redundant API calls) | ❌ | ❌ | ✅ |
| Background JSON parsing (Isolate) | ❌ | ❌ | ✅ |
| `flutter pub add` on `init` | ❌ | ❌ | ✅ |
| Rewrites `main.dart` to GetMaterialApp | ❌ | ❌ | ✅ |
| `ag doctor` environment checks | ❌ | ❌ | ✅ |
| `ag upgrade` self-update | ❌ | ❌ | ✅ |
| Spinner + color-coded output | ❌ | ✅ | ✅ |
| 160/160 pub.dev score | — | — | ✅ |

---

## Installation

```bash
dart pub global activate ag_cli
```

Make sure `~/.pub-cache/bin` is on your `PATH`. Then verify your setup:

```bash
ag doctor
```

---

## Quick Start

```bash
# 1. Create a fresh Flutter project
flutter create my_app && cd my_app

# 2. Scaffold the full GetX architecture
ag init

# 3. Generate your first feature module
ag g module orders --full
```

That's it. You now have a fully wired `orders` module with:
- paginated repo + Dio service
- controller with search, debounce, filter chips, and history
- animated app bar that switches between title and search field
- binding with `fenix: true` on every dependency
- page using `GetBuilder`, `CustomRefreshIndicator`, and `SearchHistoryPanel`
- **routes automatically injected** into `app_routes.dart`, `app_pages.dart`, and `route_management.dart`

---

## Commands

### `ag g` — Generate

The core command. Run it interactively with no arguments:

```bash
ag g
```

Arrow-key menus guide you through type → name → mode. Or skip the prompts entirely:

```bash
ag g module <name> [--full | --minimal | --search]
ag g component <name>
ag g model <name>
ag g repo <name>
ag g controller <name> [--minimal]
ag g binding <name>
ag g page <name> [--full | --minimal | --search]
```

**Shortcuts:**

```bash
ag g m orders --full        # module
ag g c OrderCard            # component
ag g r orders               # repo
ag g ctrl orders --minimal  # controller
ag g b orders               # binding
ag g p orders --full        # page
```

**Flags:**

| Flag | Description |
|---|---|
| `--full` / `-f` | Search + filter chips + history + smart refresh |
| `--minimal` / `-m` | Clean controller, no search |
| `--search` / `-s` | Search + history, no filter chips |
| `--dry-run` / `-d` | Preview files without writing them |
| `--force` | Overwrite existing files |
| `--module` | Target module for individual generators |
| `--package` | Override package name (auto-detected from pubspec.yaml) |
| `--output` | Override lib/ directory |

### `ag init` — Scaffold Project

Run once in a fresh Flutter project. Creates the full GetX folder structure, installs `get`, `dio`, `logger`, `shared_preferences`, and `flutter_screenutil`, then rewrites `main.dart` to use `GetMaterialApp` and `ScreenUtilInit`.

```bash
ag init
ag init --dry-run    # preview what would be created
ag init --force      # overwrite existing files
```

**What gets created:**

```
lib/
├── apis/providers/api_provider.dart        ← Dio + interceptors + error handling
├── bindings/initial_binding.dart           ← Global GetX dependencies
├── constants/enums.dart                    ← LoadingStatus enum
├── core/
│   ├── guards/
│   │   └── auth_guard.dart                 ← Token validation & redirect
│   ├── isolate_handler.dart                ← Background JSON parsing
│   └── services/
│       ├── theme_service.dart              ← Persistent dark/light mode
│       └── search_history_service.dart     ← Search history persistence
├── extensions/response_extension.dart
├── helpers/query_helper.dart
├── model/common/state_model.dart           ← Filter chip model
├── modules/                                ← Your feature modules go here
├── resources/app_string.dart
├── routes/
│   ├── app_pages.dart
│   ├── app_routes.dart
│   └── route_management.dart
├── utils/
│   ├── dimens.dart                         ← ScreenUtil-powered spacing
│   ├── utility.dart
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
└── widgets/
    ├── common/
    │   ├── app_error_widget.dart
    │   ├── empty_state_page_new.dart
    │   ├── item_card.dart
    │   ├── list_shimmer.dart
    │   └── search_history_panel.dart
    └── custom/
        ├── custom_refresh_indicator.dart
        └── custom_scrollview_with_sliverappbar.dart
```

### `ag doctor` — Check Your Environment

```bash
ag doctor
```

Checks Dart SDK version (≥ 3.0.0), Flutter installation, pubspec.yaml, required packages, and whether `ag init` has been run.

### `ag list` / `ag ls` — List Generators

```bash
ag list
```

### `ag upgrade` — Self-Update

```bash
ag upgrade
```

---

## Generated Module Structure

Running `ag g module orders --full` produces:

```
lib/modules/orders/
├── repos/
│   └── orders_repo.dart              ← Abstract interface + IsolateHandler impl
├── services/
│   └── orders_service.dart           ← Dio endpoints, typed, documented
├── controllers/
│   └── orders_controller.dart        ← Search, debounce, filters, pagination, history
├── bindings/
│   └── orders_binding.dart           ← lazyPut + fenix: true
├── pages/
│   └── orders_page.dart              ← Stack + SearchHistoryPanel + PopScope
├── components/
│   ├── orders_app_bar.dart           ← AnimatedSwitcher: normal ↔ live search bar
│   ├── orders_appbar_filter.dart     ← Horizontal filter chip row
│   └── orders_card.dart             ← Clean list item card
└── models/
    ├── orders_model.dart             ← fromJson / toJson stub
    └── orders_response_model.dart    ← Paginated wrapper
```

Plus, routes are **automatically injected** into your existing route files. No manual wiring.

---

## Nested Submodules

You can easily generate submodules (e.g. an item details page that belongs to the parent `orders` module). 

```bash
ag g m orders/details --full
```

`ag_cli` intelligently separates your UI and Logic:
- **Logic** (`orders_details_controller.dart`, `orders_details_repo.dart`, etc.) is cleanly merged into the parent `lib/modules/orders/` folder, maintaining a flat MVC architecture.
- **UI Components** (`orders_details_card.dart`, `orders_details_app_bar.dart`) are isolated into their own subfolder: `lib/modules/orders/components/details/`.

---

## The Smart Refresh Pattern

The generated controller implements a debounced search + smart refresh strategy that eliminates unnecessary API calls:

| User Action | API Call? | Why |
|---|:---:|---|
| Open search, type locally, press back | ❌ | Nothing was fetched |
| Submit a search query | ✅ | Fetches filtered results |
| Submit the same query again | ❌ | Duplicate guard |
| Clear search (✕) after submitting | ✅ | Restores full list |
| Press back after submitting | ✅ | Restores full list |
| Pull-to-refresh while search is open | ✅ | Closes search and refreshes |

The debouncer fires at 700ms — fast enough to feel responsive, slow enough to not hammer your API on every keystroke.

---

## Overwrite Protection

By default, ag_cli skips files that already exist:

```
⚠  lib/modules/orders/controllers/orders_controller.dart already exists (skipped, use --force to overwrite)
```

Use `--force` to overwrite, or `--dry-run` to preview without touching anything.

---

## Architecture Overview

```
ag_cli uses args + CommandRunner (same pattern as the Dart SDK CLI itself)
Logger: mason_logger (same library used internally by the Flutter team)
Templates: pure Dart string functions — zero external dependencies at runtime
```

The architecture maps directly to what Angular CLI, Flutter CLI, and Dart CLI use. Each command is an isolated `Command<int>` class. `run()` returns an exit code. Errors are caught and exit with code 1.

---

## Contributing

PRs are welcome. Run tests with:

```bash
dart test
dart analyze
dart format .
```

---

Made with ❤️ by [Kripadevg](https://github.com/kripadevg-code) — built for Flutter developers who ship fast.
