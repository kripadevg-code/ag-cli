import '../utils.dart';

String repoTemplate(String mod, String fileNamePrefix, String cls, String pkg) {
  final snakeCls = toSnake(cls);
  return '''
// ignore_for_file: unused_import
import 'package:$pkg/core/isolate_handler.dart';
import 'package:$pkg/extensions/response_extension.dart';
import 'package:$pkg/utils/utility.dart';
import 'package:$pkg/modules/$mod/services/${snakeCls}_service.dart';
import 'package:$pkg/modules/$mod/models/${snakeCls}_response_model.dart';

abstract class ${cls}Repo {
  Future<${cls}ResponseModel?> getAll({required String page, required String itemPerPage});
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
  Future<dynamic> update(String id, Map<String, dynamic> data);
  Future<dynamic> delete(String id);
}

class ${cls}RepoImpl implements ${cls}Repo {
  final ${cls}Service service;
  ${cls}RepoImpl({required this.service});

  @override
  Future<${cls}ResponseModel?> getAll({required String page, required String itemPerPage}) async {
    try {
      final response = await service.getAll(page: int.parse(page), limit: int.parse(itemPerPage));
      if (response != null) {
        return await IsolateHandler.run<dynamic, ${cls}ResponseModel>(
            response,
            (json) => ${cls}ResponseModel.fromJson(json),
        );
      }
      return null;
    } catch (e, st) {
      AppUtility.log('getAll: \$e st=\$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> getById(String id) async {
    try {
      return await service.getById(id);
    } catch (e, st) {
      AppUtility.log('getById: \$e st=\$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> create(Map<String, dynamic> data) async {
    try {
      return await service.create(data);
    } catch (e, st) {
      AppUtility.log('create: \$e st=\$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> update(String id, Map<String, dynamic> data) async {
    try {
      return await service.update(id, data);
    } catch (e, st) {
      AppUtility.log('update: \$e st=\$st', tag: 'error');
      rethrow;
    }
  }

  @override
  Future<dynamic> delete(String id) async {
    try {
      return await service.delete(id);
    } catch (e, st) {
      AppUtility.log('delete: \$e st=\$st', tag: 'error');
      rethrow;
    }
  }
}
''';
}
