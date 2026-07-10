import 'package:example/modules/auth/models/auth_login_model.dart';

/// Response wrapper for AuthLogin API.
class AuthLoginResponseModel {
  final int? count;
  final List<AuthLoginModel>? results;

  AuthLoginResponseModel({this.count, this.results});

  factory AuthLoginResponseModel.fromJson(Map<String, dynamic> json) => AuthLoginResponseModel(
    count: json['count'] as int?,
    results: (json['results'] as List<dynamic>?)?.map((e) => AuthLoginModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
