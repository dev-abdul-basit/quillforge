import 'package:get/get.dart';

class PostCreateController extends GetxController {
  Map<String, dynamic>? arguments = Get.arguments;

  /// Arguments variables
  String? postType;
  String? postResponse;

  @override
  void onInit() {
    if (arguments != null) {
      postType = arguments!["PostType"];
      postResponse = arguments!["PostResponse"];
    }

    // TODO: implement onInit
    super.onInit();
  }
}
