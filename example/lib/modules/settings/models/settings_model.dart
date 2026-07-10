/// Data model for Settings.
///
/// TODO: Add your fields, then update fromJson / toJson.
class SettingsModel {
  final int? id;
  final String? name;
  // TODO: add more fields

  SettingsModel({this.id, this.name});

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
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
  String toString() => 'SettingsModel(id: $id, name: $name)';
}
