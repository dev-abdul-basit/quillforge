import 'package:get/get.dart';
import 'package:ainotes/app/modules/setting/controller/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingController(),
    );
  }
}
