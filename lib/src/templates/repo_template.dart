String repoTemplate(String mod, String cls, String pkg) => '''
import 'package:$pkg/apis/providers/api_provider.dart';
import 'package:$pkg/core/isolate_handler.dart';
import 'package:$pkg/extensions/response_extension.dart';
import 'package:$pkg/utils/utility.dart';
// TODO: import your response model
// import 'package:$pkg/modules/$mod/models/${mod}_model.dart';

abstract class ${cls}Repo {
  // TODO: add method signatures
  // Future<${cls}ResponseModel?> getAll({required String page, required String itemPerPage});
}

class ${cls}RepoImpl implements ${cls}Repo {
  final ApiProvider apiProvider;
  ${cls}RepoImpl({required this.apiProvider});

  // @override
  // Future<${cls}ResponseModel?> getAll({required String page, required String itemPerPage}) async {
  //   try {
  //     final response = await apiProvider.get${cls}s(page: page, itemPerPage: itemPerPage);
  //     if (response.hasData) {
  //       final handler = IsolateHandler<dynamic, ${cls}ResponseModel>();
  //       return await handler.run(response.data, (json) => ${cls}ResponseModel.fromJson(json));
  //     }
  //     return null;
  //   } catch (e, st) {
  //     AppUtility.log('get${cls}s: \$e st=\$st', tag: 'error');
  //     rethrow;
  //   }
  // }
}
''';
