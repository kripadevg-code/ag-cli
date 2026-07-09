String routeStubTemplate(String mod, String cls) => '''
# Route Registration — TODO

## 1. app_routes.dart

```dart
// In AppRoutes:
static const ${mod}Page = _Routes.${mod}Page;
// In _Routes:
static const ${mod}Page = '/${mod}_page';
```

## 2. app_pages.dart

```dart
import 'package:infinity/modules/$mod/bindings/${mod}_binding.dart';
import 'package:infinity/modules/$mod/pages/${mod}_page.dart';

// In pages list:
GetPage(
  name: AppRoutes.${mod}Page,
  page: ${cls}Page.new,
  binding: ${cls}Binding(),
  transition: defaultTransition,
),
```

## 3. route_management.dart

```dart
import 'package:infinity/modules/$mod/controllers/${mod}_controller.dart';

static void goTo${cls}Page() {
  Get.delete<${cls}Controller>();
  Get.toNamed(AppRoutes.${mod}Page);
}
```
''';
