## 2.2.0

- **Feature**: Nested submodule generation. Run `ag g m orders/details` to create a smart nested module. MVC files are automatically prefixed (`orders_details_controller.dart`) and stay flat in the parent folder, while UI widgets are cleanly isolated in `components/details/`.
- **Fix**: Moved `initial_binding.dart` to `lib/core/bindings/initial_binding.dart` to adhere to standard Core organization patterns.

## 2.1.0

- **Feature**: Auto-route injection. `ag g module` now automatically injects routes into `app_routes.dart`, `app_pages.dart`, and `route_management.dart`. No manual wiring needed.
- **Feature**: `ag upgrade` command — self-update ag_cli to the latest version from pub.dev with one command.
- **Feature**: `ag doctor` command — diagnose your Dart SDK, Flutter installation, project structure, and dependencies before generating code.
- **Improvement**: `ag init` now rewrites `main.dart` to use `GetMaterialApp` + `ScreenUtilInit` with dark/light theme support.
- **Improvement**: `ag init` updates `analysis_options.yaml` with `formatter: page_width: 140`.
- **Improvement**: Progress spinners on all long-running operations via `mason_logger`.
- **Fix**: Removed domain-specific `ROUTE_TODO.md` generation when auto-injection succeeds.
- **Improvement**: Added robust support for Angular CLI-style compound paths (e.g., `ag g ctrl orders/dashboard`) with correctly mapped internal imports.

## 2.0.0

- **Breaking**: Restructured as a full `CommandRunner`-based CLI (same architecture as the Dart SDK CLI).
- **Feature**: Angular CLI-style `generate` command with `g` shortcut.
- **Feature**: 7 sub-generators — `module`, `component`, `model`, `repo`, `controller`, `binding`, `page`.
- **Feature**: Short aliases — `m`, `c`, `r`, `ctrl`, `b`, `p`.
- **Feature**: `ag init` — scaffolds the full GetX project structure with all standard files.
- **Feature**: `ag list` / `ag ls` — shows all available generators with shortcuts.
- **Feature**: Interactive arrow-key prompts powered by `mason_logger` when arguments are omitted.
- **Feature**: `--version` / `-v` flag.
- **Feature**: `--dry-run` / `-d` — preview files without writing them.
- **Feature**: `--force` — overwrite existing files.
- **Feature**: `--module` flag for individual generators to target a specific module.
- **Feature**: Auto-detection of package name from `pubspec.yaml` and module name from CWD.
- **Feature**: Overwrite protection — existing files are skipped by default with a warning.
- **Feature**: Model generator creates both `_model.dart` and `_response_model.dart`.
- **Feature**: Color-coded terminal output — ✔ green, ⚠ yellow, ✖ red, ℹ cyan.

## 1.0.0

- Initial release.
- `ag module <name> --full` — full GetX module with search, history panel, smart refresh, and filter chips.
- `ag module <name> --minimal` — minimal module with no search.
- `ag module <name> --search` — search module without filter chips.
- Auto-detects Flutter package name from `pubspec.yaml`.
- `--package` flag to override package name.
- `--output` flag to override output directory.
