/// Data model for Profile.
///
/// TODO: Add your fields, then update fromJson / toJson.
class ProfileModel {
  final int? id;
  final String? name;
  // TODO: add more fields

  ProfileModel({this.id, this.name});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  String toString() => 'ProfileModel(id: $id, name: $name)';
}
