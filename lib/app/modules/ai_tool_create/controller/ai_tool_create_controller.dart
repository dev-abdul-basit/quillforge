import 'package:get/get.dart';

class AiToolCreateController extends GetxController {
  final Map<String, dynamic>? _routeArguments = Get.arguments;

  /// Screen title passed via navigation
  String? screenTitle;

  /// Generated AI content to display
  String? generatedContent;

  @override
  void onInit() {
    super.onInit();
    _extractRouteArguments();
  }

  void _extractRouteArguments() {
    if (_routeArguments == null) return;

    screenTitle = _routeArguments!['title'];
    generatedContent = _routeArguments!['AiToolsResponse'];
  }
}