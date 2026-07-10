import 'package:get/get.dart';
import 'package:example/apis/providers/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global dependencies injected before the app starts.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ─── Core Services ───
    Get.putAsync<SharedPreferences>(() => SharedPreferences.getInstance(), permanent: true);

    // ─── Network ───
    ApiProviderImpl.instance.init('https://api.example.com');
    Get.put<ApiProvider>(ApiProviderImpl.instance, permanent: true);
  }
}
