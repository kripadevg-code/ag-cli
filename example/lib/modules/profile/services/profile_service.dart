import 'package:example/apis/providers/api_provider.dart';
// TODO: import your response model
// import 'package:example/modules/profile/models/profile_model.dart';

/// Endpoints for the Profile module.
abstract class ProfileEndpoints {
  static const String basePath = '/profile';
  static String byId(String id) => '$basePath/$id';
}

/// Module-level service interface for handling business logic specific to the Profile module.
///
/// Flow: Repo -> Service -> ApiProvider
abstract class ProfileService {
  Future<dynamic> getAll({int page = 1, int limit = 10});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class ProfileServiceImpl implements ProfileService {
  final ApiProvider apiProvider;
  ProfileServiceImpl({required this.apiProvider});

  /// Fetches a paginated list of Profile.
  @override
  Future<dynamic> getAll({int page = 1, int limit = 10}) async {
    final response = await apiProvider.get(ProfileEndpoints.basePath, queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }

  /// Fetches a single Profile by ID.
  @override
  Future<dynamic> getById(String id) async {
    final response = await apiProvider.get(ProfileEndpoints.byId(id));
    return response.data;
  }

  /// Creates a new Profile.
  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    final response = await apiProvider.post(ProfileEndpoints.basePath, data: data);
    return response.data;
  }

  /// Updates an existing Profile.
  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    final response = await apiProvider.put(ProfileEndpoints.byId(id), data: data);
    return response.data;
  }

  /// Deletes a Profile.
  @override
  Future<dynamic> delete(String id) async {
    final response = await apiProvider.delete(ProfileEndpoints.byId(id));
    return response.data;
  }
}
