# ag_cli

A code generator CLI for Flutter apps using **GetX** state management.  
Inspired by Angular CLI — **install once, use in any Flutter project**.

## Install

```bash
dart pub global activate ag_cli
```

Make sure `~/.pub-cache/bin` is on your PATH:

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

## Quick Start

```bash
# 1. Scaffold project structure (routes, enums, dimens, etc.)
ag init

# 2. Generate a full module
ag g module problem --full

# 3. Generate individual files
ag g model user --module problem
ag g component filter_tag --module problem
```

## Commands

| Command | Short | Description |
|---------|-------|-------------|
| `ag generate <type> <name>` | `ag g <type> <name>` | Generate code files |
| `ag init` | — | Scaffold GetX project folder structure |
| `ag list` | `ag ls` | Show all available generators |
| `ag --version` | `-v` | Show CLI version |
| `ag --help` | `-h` | Show help |

## Generators

| Type | Shortcut | What it creates |
|------|----------|----------------|
| `module` | `m` | Full GetX module (repo + controller + binding + page + components) |
| `component` | `c` | Single StatelessWidget |
| `model` | — | Data model with `fromJson` / `toJson` + response model |
| `repo` | `r` | Repository (abstract interface + implementation) |
| `controller` | `ctrl` | GetxController with ScrollMixin |
| `binding` | `b` | GetX Binding class |
| `page` | `p` | StatelessWidget page with GetBuilder |

## Usage Examples

```bash
# Full module with search, filters, history, smart refresh
ag g module problem --full
ag g m problem --full          # same with shortcut

# Minimal module (no search)
ag g m profile --minimal

# Search module (no filter chips)
ag g m approvals --search

# Individual generators
ag g model user --module problem
ag g c filter_tag --module tickets
ag g r approval
ag g ctrl dashboard --search
ag g b settings
ag g p notifications --module inbox

# Preview without creating files
ag g m dashboard --dry-run

# Force overwrite existing files
ag g m problem --full --force
```

## Options

| Flag | Short | Description |
|------|-------|-------------|
| `--full` | `-f` | Full module: search + filters + history + smart refresh (default) |
| `--minimal` | `-m` | Minimal: no search, no filters |
| `--search` | `-s` | Search + history, no filter chips |
| `--module` | — | Target module name (auto-detected from CWD if omitted) |
| `--package` | `-p` | Flutter package name (auto-detected from pubspec.yaml) |
| `--output` | `-o` | Output lib/ directory (auto-detected if omitted) |
| `--dry-run` | `-d` | Preview what would be generated without writing files |
| `--force` | — | Overwrite existing files (default: skip with warning) |

## What `ag init` creates

```
lib/
├── apis/providers/api_provider.dart
├── constants/enums.dart
├── core/isolate_handler.dart
├── helpers/
├── model/
├── modules/
├── resources/
├── routes/
│   ├── app_routes.dart
│   ├── app_pages.dart
│   └── route_management.dart
├── services/
├── utils/
│   ├── dimens.dart
│   └── utility.dart
├── widgets/
└── extensions/
```

## What `ag g module problem --full` creates

```
lib/modules/problem/
├── repos/
│   └── problem_repo.dart              ← abstract + impl, IsolateHandler
├── controllers/
│   └── problem_controller.dart        ← search, history, smart refresh, debouncer
├── bindings/
│   └── problem_binding.dart           ← lazyPut + fenix: true
├── pages/
│   └── problem_page.dart              ← Stack + SearchHistoryPanel + PopScope
├── components/
│   ├── problem_app_bar.dart           ← AnimatedSwitcher (normal ↔ search)
│   ├── problem_appbar_filter.dart     ← horizontal filter chips
│   └── problem_card.dart              ← IncidentCard base
└── ROUTE_TODO.md                      ← route registration snippets
```

## Smart Refresh Pattern

The generated controller implements the smart refresh pattern — no unnecessary API calls:

| Scenario | API call? |
|---|---|
| Open search → back (no typing) | ❌ No — list unchanged |
| Type locally → back | ❌ No — local filter only |
| Submit → back | ✅ Yes — restore unfiltered list |
| Submit → clear (✕) | ✅ Yes — restore unfiltered list |
| Submit same query twice | ❌ No — duplicate guard |
| Pull-to-refresh while search open | ✅ Yes — closes search + refreshes |

## After Generation

1. Fill `// TODO` items — model import, API call, query filter
2. Follow `ROUTE_TODO.md` to register routes
3. Add API methods to `api_provider.dart`
4. Run `flutter analyze lib/modules/<name>/`

## Overwrite Protection

By default, existing files are **skipped** with a warning:

```
  ⚠ lib/modules/problem/repos/problem_repo.dart already exists (skipped, use --force to overwrite)
```

Use `--force` to overwrite.

## Requirements

- Dart SDK `>=3.0.0`
- Flutter project with GetX (`get: ^4.x`)
