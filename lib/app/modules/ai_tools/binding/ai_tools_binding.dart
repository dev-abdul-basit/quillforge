import 'package:get/get.dart';
import 'package:ainotes/app/modules/ai_tools/controller/ai_tools_controller.dart';

class AiToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AiToolsController(),
    );
  }
}
