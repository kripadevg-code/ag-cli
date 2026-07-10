import 'package:get/get.dart';
import 'package:example/modules/products/controllers/products_details_controller.dart';
import 'package:example/modules/products/repos/products_details_repo.dart';
import 'package:example/modules/products/services/products_details_service.dart';

class ProductsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsDetailsService>(() => ProductsDetailsServiceImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<ProductsDetailsRepo>(() => ProductsDetailsRepoImpl(service: Get.find()), fenix: true);
    Get.lazyPut(() => ProductsDetailsController(repo: Get.find()), fenix: true);
  }
}
