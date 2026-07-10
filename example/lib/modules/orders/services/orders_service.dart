import 'package:example/apis/providers/api_provider.dart';
// TODO: import your response model
// import 'package:example/modules/orders/models/orders_model.dart';

/// Endpoints for the Orders module.
abstract class OrdersEndpoints {
  static const String basePath = '/orders';
  static String byId(String id) => '$basePath/$id';
}

/// Module-level service interface for handling business logic specific to the Orders module.
///
/// Flow: Repo -> Service -> ApiProvider
abstract class OrdersService {
  Future<dynamic> getAll({int page = 1, int limit = 10});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class OrdersServiceImpl implements OrdersService {
  final ApiProvider apiProvider;
  OrdersServiceImpl({required this.apiProvider});

  /// Fetches a paginated list of Orders.
  @override
  Future<dynamic> getAll({int page = 1, int limit = 10}) async {
    final response = await apiProvider.get(OrdersEndpoints.basePath, queryParameters: {'page': page, 'limit': limit});
    return response.data;
  }

  /// Fetches a single Orders by ID.
  @override
  Future<dynamic> getById(String id) async {
    final response = await apiProvider.get(OrdersEndpoints.byId(id));
    return response.data;
  }

  /// Creates a new Orders.
  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    final response = await apiProvider.post(OrdersEndpoints.basePath, data: data);
    return response.data;
  }

  /// Updates an existing Orders.
  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    final response = await apiProvider.put(OrdersEndpoints.byId(id), data: data);
    return response.data;
  }

  /// Deletes a Orders.
  @override
  Future<dynamic> delete(String id) async {
    final response = await apiProvider.delete(OrdersEndpoints.byId(id));
    return response.data;
  }
}
