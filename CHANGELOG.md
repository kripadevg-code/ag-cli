## 2.0.0

- **Angular CLI-style `generate` command** with `g` shortcut.
- **7 sub-generators**: `module`, `component`, `model`, `repo`, `controller`, `binding`, `page`.
- **Shortcut aliases**: `m`, `c`, `r`, `ctrl`, `b`, `p`.
- **`ag init`** — scaffolds the full GetX project folder structure.
- **`ag list`** — shows all available generators with shortcuts.
- **`--version` / `-v`** flag.
- **`--dry-run` / `-d`** — preview without writing files.
- **`--force`** — overwrite existing files.
- **Overwrite protection** — existing files are skipped by default with `⚠` warning.
- **`--module` flag** for individual generators to target a specific module.
- **Colored terminal output** — green ✔, yellow ⚠, red ❌, cyan ℹ.
- **Model generator** creates both `_model.dart` (with fromJson/toJson) and `_response_model.dart`.
- **Auto-detection** — package name from `pubspec.yaml`, module name from CWD.

## 1.0.0

- Initial release.
- `ag module <name> --full` — full GetX module with inline search, history panel, smart refresh.
- `ag module <name> --minimal` — minimal module (no search).
- `ag module <name> --search` — search module without filter chips.
- Auto-detects Flutter package name from project `pubspec.yaml`.
- `--package` flag to override package name.
- `--output` flag to override output directory.
