/// Data model for Home.
///
/// TODO: Add your fields, then update fromJson / toJson.
class HomeModel {
  final int? id;
  final String? name;
  // TODO: add more fields

  HomeModel({this.id, this.name});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
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
  String toString() => 'HomeModel(id: $id, name: $name)';
}
