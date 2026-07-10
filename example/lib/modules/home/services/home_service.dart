import 'package:example/apis/providers/api_provider.dart';
// TODO: import your response model
// import 'package:example/modules/home/models/home_model.dart';

/// Endpoints for the Home module.
abstract class HomeEndpoints {
  static const String basePath = '/home';
  static String byId(String id) => '$basePath/$id';
}

/// Module-level service interface for handling business logic specific to the Home module.
///
/// Flow: Repo -> Service -> ApiProvider
abstract class HomeService {
  Future<dynamic> getAll({int page = 1, int limit = 10});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class HomeServiceImpl implements HomeService {
  final ApiProvider apiProvider;
  HomeServiceImpl({required this.apiProvider});

  /// Fetches a paginated list of Home.
  @override
  Future<dynamic> getAll({int page = 1, int limit = 10}) async {
    final response = await apiProvider.get(HomeEndpoints.basePath, queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }

  /// Fetches a single Home by ID.
  @override
  Future<dynamic> getById(String id) async {
    final response = await apiProvider.get(HomeEndpoints.byId(id));
    return response.data;
  }

  /// Creates a new Home.
  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    final response = await apiProvider.post(HomeEndpoints.basePath, data: data);
    return response.data;
  }

  /// Updates an existing Home.
  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    final response = await apiProvider.put(HomeEndpoints.byId(id), data: data);
    return response.data;
  }

  /// Deletes a Home.
  @override
  Future<dynamic> delete(String id) async {
    final response = await apiProvider.delete(HomeEndpoints.byId(id));
    return response.data;
  }
}
