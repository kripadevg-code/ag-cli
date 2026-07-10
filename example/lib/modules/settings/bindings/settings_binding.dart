import 'package:get/get.dart';
import 'package:example/modules/settings/controllers/settings_controller.dart';
import 'package:example/modules/settings/repos/settings_repo.dart';
import 'package:example/modules/settings/services/settings_service.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsService>(() => SettingsServiceImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<SettingsRepo>(() => SettingsRepoImpl(service: Get.find()), fenix: true);
    Get.lazyPut(() => SettingsController(repo: Get.find()), fenix: true);
  }
}
