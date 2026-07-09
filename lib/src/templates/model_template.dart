String modelTemplate(String mod, String cls, String pkg) => '''
/// Data model for $cls.
///
/// TODO: Add your fields, then update fromJson / toJson.
class ${cls}Model {
  final int? id;
  final String? name;
  // TODO: add more fields

  ${cls}Model({this.id, this.name});

  factory ${cls}Model.fromJson(Map<String, dynamic> json) => ${cls}Model(
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
  String toString() => '${cls}Model(id: \$id, name: \$name)';
}
''';

String responseModelTemplate(String mod, String cls, String pkg) => '''
import 'package:$pkg/modules/$mod/models/${mod}_model.dart';

/// Response wrapper for $cls API.
class ${cls}ResponseModel {
  final int? count;
  final List<${cls}Model>? results;

  ${cls}ResponseModel({this.count, this.results});

  factory ${cls}ResponseModel.fromJson(Map<String, dynamic> json) =>
      ${cls}ResponseModel(
        count: json['count'] as int?,
        results: (json['results'] as List<dynamic>?)
            ?.map((e) => ${cls}Model.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
''';
