import 'package:example/apis/providers/api_provider.dart';
// TODO: import your response model
// import 'package:example/modules/auth/models/auth_login_model.dart';

/// Endpoints for the AuthLogin module.
abstract class AuthLoginEndpoints {
  static const String basePath = '/auth';
  static String byId(String id) => '$basePath/$id';
}

/// Module-level service interface for handling business logic specific to the AuthLogin module.
///
/// Flow: Repo -> Service -> ApiProvider
abstract class AuthLoginService {
  Future<dynamic> getAll({int page = 1, int limit = 10});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class AuthLoginServiceImpl implements AuthLoginService {
  final ApiProvider apiProvider;
  AuthLoginServiceImpl({required this.apiProvider});

  /// Fetches a paginated list of AuthLogin.
  @override
  Future<dynamic> getAll({int page = 1, int limit = 10}) async {
    final response = await apiProvider.get(AuthLoginEndpoints.basePath, queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }

  /// Fetches a single AuthLogin by ID.
  @override
  Future<dynamic> getById(String id) async {
    final response = await apiProvider.get(AuthLoginEndpoints.byId(id));
    return response.data;
  }

  /// Creates a new AuthLogin.
  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    final response = await apiProvider.post(AuthLoginEndpoints.basePath, data: data);
    return response.data;
  }

  /// Updates an existing AuthLogin.
  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    final response = await apiProvider.put(AuthLoginEndpoints.byId(id), data: data);
    return response.data;
  }

  /// Deletes a AuthLogin.
  @override
  Future<dynamic> delete(String id) async {
    final response = await apiProvider.delete(AuthLoginEndpoints.byId(id));
    return response.data;
  }
}
