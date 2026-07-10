import 'package:example/apis/providers/api_provider.dart';
// TODO: import your response model
// import 'package:example/modules/products/models/products_details_model.dart';

/// Endpoints for the ProductsDetails module.
abstract class ProductsDetailsEndpoints {
  static const String basePath = '/products';
  static String byId(String id) => '$basePath/$id';
}

/// Module-level service interface for handling business logic specific to the ProductsDetails module.
///
/// Flow: Repo -> Service -> ApiProvider
abstract class ProductsDetailsService {
  Future<dynamic> getAll({int page = 1, int limit = 10});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class ProductsDetailsServiceImpl implements ProductsDetailsService {
  final ApiProvider apiProvider;
  ProductsDetailsServiceImpl({required this.apiProvider});

  /// Fetches a paginated list of ProductsDetails.
  @override
  Future<dynamic> getAll({int page = 1, int limit = 10}) async {
    final response = await apiProvider.get(ProductsDetailsEndpoints.basePath, queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }

  /// Fetches a single ProductsDetails by ID.
  @override
  Future<dynamic> getById(String id) async {
    final response = await apiProvider.get(ProductsDetailsEndpoints.byId(id));
    return response.data;
  }

  /// Creates a new ProductsDetails.
  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    final response = await apiProvider.post(ProductsDetailsEndpoints.basePath, data: data);
    return response.data;
  }

  /// Updates an existing ProductsDetails.
  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    final response = await apiProvider.put(ProductsDetailsEndpoints.byId(id), data: data);
    return response.data;
  }

  /// Deletes a ProductsDetails.
  @override
  Future<dynamic> delete(String id) async {
    final response = await apiProvider.delete(ProductsDetailsEndpoints.byId(id));
    return response.data;
  }
}
