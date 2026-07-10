String moduleServiceTemplate(String mod, String fileNamePrefix, String cls, String pkg) {
  return '''
import 'package:$pkg/apis/providers/api_provider.dart';
// TODO: import your response model
// import 'package:$pkg/modules/$mod/models/${fileNamePrefix}_model.dart';

/// Endpoints for the $cls module.
abstract class ${cls}Endpoints {
  static const String basePath = '/$mod';
  static String byId(String id) => '\$basePath/\$id';
}

/// Module-level service interface for handling business logic specific to the $cls module.
/// 
/// Flow: Repo -> Service -> ApiProvider
abstract class ${cls}Service {
  Future<dynamic> getAll({int page = 1, int limit = 10});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class ${cls}ServiceImpl implements ${cls}Service {
  final ApiProvider apiProvider;
  ${cls}ServiceImpl({required this.apiProvider});

  /// Fetches a paginated list of $cls.
  @override
  Future<dynamic> getAll({int page = 1, int limit = 10}) async {
    final response = await apiProvider.get(${cls}Endpoints.basePath, queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }

  /// Fetches a single $cls by ID.
  @override
  Future<dynamic> getById(String id) async {
    final response = await apiProvider.get(${cls}Endpoints.byId(id));
    return response.data;
  }

  /// Creates a new $cls.
  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    final response = await apiProvider.post(${cls}Endpoints.basePath, data: data);
    return response.data;
  }

  /// Updates an existing $cls.
  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    final response = await apiProvider.put(${cls}Endpoints.byId(id), data: data);
    return response.data;
  }

  /// Deletes a $cls.
  @override
  Future<dynamic> delete(String id) async {
    final response = await apiProvider.delete(${cls}Endpoints.byId(id));
    return response.data;
  }
}
''';
}
