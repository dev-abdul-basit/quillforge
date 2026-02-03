import 'package:get/get.dart';
import 'package:ainotes/app/modules/ai_tool_create/controller/ai_tool_create_controller.dart';

class AiToolCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AiToolCreateController(),
    );
  }
}
