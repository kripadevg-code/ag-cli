/// Data model for AuthLogin.
///
/// TODO: Add your fields, then update fromJson / toJson.
class AuthLoginModel {
  final int? id;
  final String? name;
  // TODO: add more fields

  AuthLoginModel({this.id, this.name});

  factory AuthLoginModel.fromJson(Map<String, dynamic> json) => AuthLoginModel(
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
  String toString() => 'AuthLoginModel(id: $id, name: $name)';
}
