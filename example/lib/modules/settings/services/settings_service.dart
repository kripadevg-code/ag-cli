import 'package:example/apis/providers/api_provider.dart';
// TODO: import your response model
// import 'package:example/modules/settings/models/settings_model.dart';

/// Endpoints for the Settings module.
abstract class SettingsEndpoints {
  static const String basePath = '/settings';
  static String byId(String id) => '$basePath/$id';
}

/// Module-level service interface for handling business logic specific to the Settings module.
///
/// Flow: Repo -> Service -> ApiProvider
abstract class SettingsService {
  Future<dynamic> getAll({int page = 1, int limit = 10});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class SettingsServiceImpl implements SettingsService {
  final ApiProvider apiProvider;
  SettingsServiceImpl({required this.apiProvider});

  /// Fetches a paginated list of Settings.
  @override
  Future<dynamic> getAll({int page = 1, int limit = 10}) async {
    final response = await apiProvider.get(SettingsEndpoints.basePath, queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }

  /// Fetches a single Settings by ID.
  @override
  Future<dynamic> getById(String id) async {
    final response = await apiProvider.get(SettingsEndpoints.byId(id));
    return response.data;
  }

  /// Creates a new Settings.
  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    final response = await apiProvider.post(SettingsEndpoints.basePath, data: data);
    return response.data;
  }

  /// Updates an existing Settings.
  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    final response = await apiProvider.put(SettingsEndpoints.byId(id), data: data);
    return response.data;
  }

  /// Deletes a Settings.
  @override
  Future<dynamic> delete(String id) async {
    final response = await apiProvider.delete(SettingsEndpoints.byId(id));
    return response.data;
  }
}
