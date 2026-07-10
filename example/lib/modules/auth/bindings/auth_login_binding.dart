import 'package:get/get.dart';
import 'package:example/modules/auth/controllers/auth_login_controller.dart';
import 'package:example/modules/auth/repos/auth_login_repo.dart';
import 'package:example/modules/auth/services/auth_login_service.dart';

class AuthLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLoginService>(() => AuthLoginServiceImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<AuthLoginRepo>(() => AuthLoginRepoImpl(service: Get.find()), fenix: true);
    Get.lazyPut(() => AuthLoginController(repo: Get.find()), fenix: true);
  }
}
