import 'package:get/get.dart';
import 'package:ainotes/app/modules/Premium/controller/premium_controller.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PremiumController(),
    );
  }
}
