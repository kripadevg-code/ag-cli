/// Templates for Angular-CLI-inspired schematics: enum, interface, guard,
/// interceptor, mixin, extension.
library;

// ─── Enum ──────────────────────────────────────────────────────────────────
String enumTemplate(String cls) => '''
/// $cls enum.
///
/// TODO: Rename values to match your domain.
enum $cls {
  unknown,
  // TODO: add values
}
''';

// ─── Interface (abstract class) ────────────────────────────────────────────
String interfaceTemplate(String cls, String pkg) => '''
/// Abstract interface for $cls.
///
/// Implement this to swap out the concrete implementation.
abstract class $cls {
  // TODO: declare interface methods
}
''';

// ─── Guard (GetX route middleware) ─────────────────────────────────────────
String guardTemplate(String cls, String pkg) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Route guard for $cls.
///
/// Register in GetPage:
///   GetPage(
///     name: AppRoutes.myRoute,
///     page: MyPage.new,
///     middlewares: [$cls()],
///   )
class $cls extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // TODO: return RouteSettings(name: AppRoutes.login) to redirect
    // return null to allow navigation
    return null;
  }
}
''';

// ─── Interceptor (Dio interceptor) ─────────────────────────────────────────
String interceptorTemplate(String cls, String pkg) => '''
import 'package:dio/dio.dart';

/// Dio interceptor for $cls.
///
/// Register in ApiProviderImpl.init():
///   _dio.interceptors.add(${cls}Interceptor());
class ${cls}Interceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: modify request (e.g. add headers, tokens)
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: process response
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: handle errors (e.g. token refresh, logging)
    super.onError(err, handler);
  }
}
''';

// ─── Mixin ──────────────────────────────────────────────────────────────────
String mixinTemplate(String cls) => '''
/// $cls mixin.
///
/// TODO: Add shared behaviour to mix into classes.
mixin $cls {
  // TODO: add mixin members
}
''';

// ─── Extension ──────────────────────────────────────────────────────────────
String extensionTemplate(String cls, String onType) => '''
/// Extension methods for $onType.
extension $cls on $onType {
  // TODO: add extension methods
}
''';
