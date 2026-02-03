import 'package:get/get.dart';
import 'package:ainotes/app/modules/post_create/controller/post_create_controller.dart';

class PostCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PostCreateController(),
    );
  }
}
