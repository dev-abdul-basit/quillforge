import 'package:get/get.dart';
import 'package:ainotes/app/modules/Splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
