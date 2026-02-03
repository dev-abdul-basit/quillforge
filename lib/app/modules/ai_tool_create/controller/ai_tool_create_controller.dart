import 'package:get/get.dart';

class AiToolCreateController extends GetxController {
  Map<String, dynamic>? arguments = Get.arguments;

  /// Arguments variables
  String? title;
  String? aiToolsResponse;

  @override
  void onInit() {
    if (arguments != null) {
      title = arguments!["title"];
      aiToolsResponse = arguments!["AiToolsResponse"];
    }

    // TODO: implement onInit
    super.onInit();
  }
}
