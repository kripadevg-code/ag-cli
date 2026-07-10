import 'package:example/modules/home/models/home_model.dart';

/// Response wrapper for Home API.
class HomeResponseModel {
  final int? count;
  final List<HomeModel>? results;

  HomeResponseModel({this.count, this.results});

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) => HomeResponseModel(
    count: json['count'] as int?,
    results: (json['results'] as List<dynamic>?)?.map((e) => HomeModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
