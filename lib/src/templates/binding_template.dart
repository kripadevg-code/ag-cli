import '../utils.dart';

String bindingTemplate(String mod, String fileNamePrefix, String cls, String pkg) {
  final snakeCls = toSnake(cls);
  return '''
import 'package:get/get.dart';
import 'package:$pkg/modules/$mod/controllers/${snakeCls}_controller.dart';
import 'package:$pkg/modules/$mod/repos/${snakeCls}_repo.dart';
import 'package:$pkg/modules/$mod/services/${snakeCls}_service.dart';

class ${cls}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${cls}Service>(() => ${cls}ServiceImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<${cls}Repo>(
      () => ${cls}RepoImpl(service: Get.find()),
      fenix: true,
    );
    Get.lazyPut(() => ${cls}Controller(repo: Get.find()), fenix: true);
  }
}
''';
}
