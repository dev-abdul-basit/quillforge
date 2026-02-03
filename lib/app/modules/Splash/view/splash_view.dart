import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/modules/Splash/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFe4e4e4),
        body: Center(
          child: Image.asset(
            appIcon,
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
