import 'package:get/get.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/controller/ai_tools_response_controller.dart';

class AiToolsResponseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AiToolsResponseController(),
    );
  }
}
