import 'package:example/modules/products/models/products_details_model.dart';

/// Response wrapper for ProductsDetails API.
class ProductsDetailsResponseModel {
  final int? count;
  final List<ProductsDetailsModel>? results;

  ProductsDetailsResponseModel({this.count, this.results});

  factory ProductsDetailsResponseModel.fromJson(Map<String, dynamic> json) => ProductsDetailsResponseModel(
    count: json['count'] as int?,
    results: (json['results'] as List<dynamic>?)?.map((e) => ProductsDetailsModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
