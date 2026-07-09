String bindingTemplate(String mod, String cls, String pkg) => '''
import 'package:get/get.dart';
import 'package:$pkg/apis/providers/api_provider.dart';
import 'package:$pkg/modules/$mod/controllers/${mod}_controller.dart';
import 'package:$pkg/modules/$mod/repos/${mod}_repo.dart';

class ${cls}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${cls}Repo>(
      () => ${cls}RepoImpl(apiProvider: ApiProvider.instance),
      fenix: true,
    );
    Get.lazyPut(() => ${cls}Controller(repo: Get.find()), fenix: true);
  }
}
''';
