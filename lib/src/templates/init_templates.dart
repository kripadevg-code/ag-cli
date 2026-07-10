/// Templates for `ag init` — project structure scaffolding.
library;

String appRoutesStub() => '''
/// All route path constants live here.
abstract class AppRoutes {
  static const initial = _Routes.home;
  static const home = _Routes.home;

  // TODO: add routes here (ag module generates stubs in ROUTE_TODO.md)
}

abstract class _Routes {
  static const home = '/home';
}
''';

String appPagesStub(String pkg) => '''
// ignore_for_file: unused_import
import 'package:get/get.dart';
import 'package:$pkg/routes/app_routes.dart';

/// Route → Page + Binding mapping.
abstract class AppPages {
  static final defaultTransition = Transition.rightToLeftWithFade;

  static final pages = <GetPage>[
    // TODO: add GetPage entries here
    // GetPage(
    //   name: AppRoutes.home,
    //   page: HomePage.new,
    //   binding: HomeBinding(),
    //   transition: defaultTransition,
    // ),
  ];
}
''';

String routeManagementStub(String pkg) => '''
// ignore_for_file: unused_import
import 'package:get/get.dart';
import 'package:$pkg/routes/app_routes.dart';

/// Central navigation helper — every navigation action goes through here.
abstract class RouteManagement {
  // TODO: add navigation methods here
  // static void goToHomePage() {
  //   Get.toNamed(AppRoutes.home);
  // }
}
''';

String enumsStub() => '''
/// App-wide loading status enum.
enum LoadingStatus { loading, done, error, empty }
''';

String dimensStub() => '''
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized dimension constants for consistent spacing, powered by ScreenUtil.
abstract class Dimens {
  static double get two => 2.w;
  static double get four => 4.w;
  static double get six => 6.w;
  static double get eight => 8.w;
  static double get ten => 10.w;
  static double get twelve => 12.w;
  static double get fourteen => 14.w;
  static double get sixTeen => 16.w;
  static double get eighteen => 18.w;
  static double get twenty => 20.w;
  static double get twentyFour => 24.w;
  static double get twentyEight => 28.w;
  static double get thirtyTwo => 32.w;
  static double get fourty => 40.w;

  static EdgeInsets get defaultPadding => EdgeInsets.symmetric(horizontal: sixTeen);
  static EdgeInsets get onlyTop12 => EdgeInsets.only(top: twelve);
  static EdgeInsets get onlyTop16 => EdgeInsets.only(top: sixTeen);
}
''';

String appColorsStub() => '''
import 'package:flutter/material.dart';

/// Centralized color palette.
abstract class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
''';

String appThemeStub(String pkg) => '''
import 'package:flutter/material.dart';
import 'package:$pkg/utils/theme/app_colors.dart';

/// App-wide theme configuration.
abstract class AppTheme {
  static final light = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    useMaterial3: true,
  );

  static final dark = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.black,
    useMaterial3: true,
  );
}
''';

String utilityStub() => '''
/// App-wide utility/logging helper.
abstract class AppUtility {
  static void log(String message, {String tag = 'log'}) {
    // ignore: avoid_print
    print('[\$tag] \$message');
  }
}
''';

String apiProviderStub() => '''
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Custom Exception for standardizing API errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: \$message (Status: \$statusCode)';
}

/// Central API provider interface — all HTTP calls go through here.
abstract class ApiProvider {
  void init(String baseUrl);
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options});
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
  Future<Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options});
}

/// Implementation of ApiProvider using Dio.
class ApiProviderImpl implements ApiProvider {
  ApiProviderImpl._();
  static final instance = ApiProviderImpl._();

  late final Dio _dio;
  final Logger _logger = Logger();

  /// Initialize the API Provider. Call this in InitialBinding.
  @override
  void init(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer \$token';
          }
          _logger.d('REQUEST[\${options.method}] => PATH: \${options.path}\\nDATA: \${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('RESPONSE[\${response.statusCode}] => PATH: \${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e('ERROR[\${e.response?.statusCode}] => PATH: \${e.requestOptions.path}\\nMESSAGE: \${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  /// Generic GET request
  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PUT request
  @override
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PATCH request
  @override
  Future<Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.patch(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic DELETE request
  @override
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    String message = 'Something went wrong. Please try again.';
    int? statusCode = e.response?.statusCode;
    dynamic data = e.response?.data;

    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timed out.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection.';
    } else if (e.response != null) {
      if (e.response?.data is Map && e.response?.data['message'] != null) {
        message = e.response?.data['message'];
      } else {
        message = 'Server Error: \${e.response?.statusCode}';
      }
    }

    return ApiException(message, statusCode: statusCode, data: data);
  }
}
''';

String isolateHandlerStub() => '''
import 'dart:isolate';
import 'package:logger/logger.dart';

/// Advanced Isolate Handler for heavy background parsing.
class IsolateHandler {
  static final _logger = Logger();

  /// Runs a computationally heavy [parser] function on a background thread.
  static Future<O?> run<I, O>(I input, O Function(I) parser) async {
    try {
      return await Isolate.run(() => parser(input));
    } catch (e, stackTrace) {
      _logger.e('Isolate Error: \$e', error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
''';

String initialBindingStub(String pkg) => '''
import 'package:get/get.dart';
import 'package:$pkg/apis/providers/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global dependencies injected before the app starts.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ─── Core Services ───
    Get.putAsync<SharedPreferences>(() => SharedPreferences.getInstance(), permanent: true);

    // ─── Network ───
    ApiProviderImpl.instance.init('https://api.example.com');
    Get.put<ApiProvider>(ApiProviderImpl.instance, permanent: true);
  }
}
''';

String themeServiceStub() => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage and persist the app theme across sessions.
class ThemeService extends GetxService {
  static ThemeService get find => Get.find();

  final SharedPreferences _prefs;
  ThemeService(this._prefs);

  static const String _themeKey = 'isDarkMode';

  bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Toggles the current theme and persists it to SharedPreferences
  void toggleTheme() {
    final isDark = isDarkMode;
    _prefs.setBool(_themeKey, !isDark);
    Get.changeThemeMode(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
''';
