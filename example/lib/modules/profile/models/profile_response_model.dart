import 'package:example/modules/profile/models/profile_model.dart';

/// Response wrapper for Profile API.
class ProfileResponseModel {
  final int? count;
  final List<ProfileModel>? results;

  ProfileResponseModel({this.count, this.results});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
    count: json['count'] as int?,
    results: (json['results'] as List<dynamic>?)?.map((e) => ProfileModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
