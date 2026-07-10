import 'package:get/get.dart';
import 'package:example/modules/home/controllers/home_controller.dart';
import 'package:example/modules/home/repos/home_repo.dart';
import 'package:example/modules/home/services/home_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeService>(() => HomeServiceImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<HomeRepo>(() => HomeRepoImpl(service: Get.find()), fenix: true);
    Get.lazyPut(() => HomeController(repo: Get.find()), fenix: true);
  }
}
