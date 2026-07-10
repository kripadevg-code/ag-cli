import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/bindings/initial_binding.dart';
import 'utils/theme/app_theme.dart';
import 'core/services/theme_service.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Core Services
  final storage = await StorageService().init();
  Get.put(storage);
  Get.put(ThemeService());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter App',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeService.find.themeMode,
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.initial,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
