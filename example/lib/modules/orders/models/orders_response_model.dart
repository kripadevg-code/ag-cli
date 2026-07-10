import 'package:example/modules/orders/models/orders_model.dart';

/// Response wrapper for Orders API.
class OrdersResponseModel {
  final int? count;
  final List<OrdersModel>? results;

  OrdersResponseModel({this.count, this.results});

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) => OrdersResponseModel(
    count: json['count'] as int?,
    results: (json['results'] as List<dynamic>?)?.map((e) => OrdersModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
