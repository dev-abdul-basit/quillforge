import 'package:get/get.dart';
import 'package:ainotes/app/modules/FAQ/controller/faq_controller.dart';

class FaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FaqController(),
    );
  }
}
