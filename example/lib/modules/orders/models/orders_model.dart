/// Data model for Orders.
///
/// TODO: Add your fields, then update fromJson / toJson.
class OrdersModel {
  final int? id;
  final String? name;
  // TODO: add more fields

  OrdersModel({this.id, this.name});

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    // TODO: map remaining fields
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    // TODO: add remaining fields
  };

  @override
  String toString() => 'OrdersModel(id: $id, name: $name)';
}
