import 'package:get/get.dart';
import 'package:example/apis/providers/api_provider.dart';

/// Global dependencies injected before the app starts.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ─── Network ───
    ApiProviderImpl.instance.init('https://api.example.com');
    Get.put<ApiProvider>(ApiProviderImpl.instance, permanent: true);
  }
}
