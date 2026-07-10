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
  String toString() => 'ApiException: $message (Status: $statusCode)';
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
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}\nDATA: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          _logger.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}\nMESSAGE: ${e.message}');
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
        message = 'Server Error: ${e.response?.statusCode}';
      }
    }

    return ApiException(message, statusCode: statusCode, data: data);
  }
}
