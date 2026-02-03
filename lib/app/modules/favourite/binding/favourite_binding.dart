import 'package:get/get.dart';
import 'package:ainotes/app/modules/favourite/controller/favourite_controller.dart';

class FavouriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FavouriteController(),
    );
  }
}
