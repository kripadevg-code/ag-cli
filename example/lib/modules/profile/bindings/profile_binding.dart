import 'package:get/get.dart';
import 'package:example/modules/profile/controllers/profile_controller.dart';
import 'package:example/modules/profile/repos/profile_repo.dart';
import 'package:example/modules/profile/services/profile_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileService>(() => ProfileServiceImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<ProfileRepo>(() => ProfileRepoImpl(service: Get.find()), fenix: true);
    Get.lazyPut(() => ProfileController(repo: Get.find()), fenix: true);
  }
}
