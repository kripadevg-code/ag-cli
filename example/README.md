# Example

Since `ag_cli` is a Command Line Interface (CLI) tool, it is not meant to be imported into your Dart code as a library.

Instead, install it globally via terminal:

```bash
dart pub global activate ag_cli
```

And then run it in any Flutter project:

```bash
# Initialize a GetX architecture
ag init

# Generate a full module (repo, controller, bindings, pages, components)
ag g module dashboard --full

# Generate a single component
ag g component primary_button

# Preview generation without creating files
ag g module settings --dry-run
```
