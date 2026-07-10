import 'package:get/get.dart';
import 'package:example/modules/orders/controllers/orders_controller.dart';
import 'package:example/modules/orders/repos/orders_repo.dart';
import 'package:example/modules/orders/services/orders_service.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersService>(() => OrdersServiceImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<OrdersRepo>(() => OrdersRepoImpl(service: Get.find()), fenix: true);
    Get.lazyPut(() => OrdersController(repo: Get.find()), fenix: true);
  }
}
