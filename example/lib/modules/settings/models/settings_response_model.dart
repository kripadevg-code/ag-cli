import 'package:example/modules/settings/models/settings_model.dart';

/// Response wrapper for Settings API.
class SettingsResponseModel {
  final int? count;
  final List<SettingsModel>? results;

  SettingsResponseModel({this.count, this.results});

  factory SettingsResponseModel.fromJson(Map<String, dynamic> json) => SettingsResponseModel(
    count: json['count'] as int?,
    results: (json['results'] as List<dynamic>?)?.map((e) => SettingsModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
