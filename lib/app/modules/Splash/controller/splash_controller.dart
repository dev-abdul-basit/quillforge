import 'package:get/get.dart';
import 'package:ainotes/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  /// Simulate app initialization tasks (theme, storage, ads, etc.)
  void initializeApp() async {
    // Add any async initialization here
    await Future.delayed(const Duration(milliseconds: 1000));

    // Navigate to HomeView
    Get.offAndToNamed(Routes.homeView);
  }
}