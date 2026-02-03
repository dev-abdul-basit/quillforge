import 'package:get/get.dart';
import 'package:ainotes/app/modules/generate_post/controller/generate_post_controller.dart';

class GeneratePostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GeneratePostController(),
    );
  }
}
