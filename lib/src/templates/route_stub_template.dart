String routeStubTemplate(String moduleDir, String fileNamePrefix, String cls) => '''
<!-- ROUTE_TODO.md -->
# 🚀 Final Step: Register the Route for $cls

Since the `app_pages.dart` or `app_routes.dart` files couldn't be automatically updated (they might be missing or heavily customized), you need to manually register the route for this module.

1. **Add Route Constant** in `lib/routes/app_routes.dart`:
   ```dart
   static const ${fileNamePrefix.toUpperCase()} = '/$fileNamePrefix';
   ```

2. **Add GetPage** in `lib/routes/app_pages.dart`:
   ```dart
   GetPage(
     name: AppRoutes.${fileNamePrefix.toUpperCase()},
     page: () => const ${cls}Page(),
     binding: ${cls}Binding(),
   ),
   ```
''';
