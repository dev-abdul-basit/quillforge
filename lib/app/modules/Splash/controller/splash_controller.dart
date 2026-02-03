import 'package:get/get.dart';
import 'package:ainotes/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    navigation();
    super.onInit();
  }

  navigation() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Get.offAndToNamed(Routes.homeView);
      },
    );
  }
}
