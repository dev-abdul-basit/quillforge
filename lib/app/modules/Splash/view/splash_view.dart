import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Splash/controller/splash_controller.dart';

import '../../../common/constants/color_consrtant.dart';
import '../../../common/constants/font_family_constants.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: ColorCodes.purple, // Dark splash bg
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo
            // Image.asset(
            //   appIcon,
            //   height: 140,
            //   width: 140,
            // ),
            const SizedBox(height: 16),
            // App Name
            const CommonText(
              text: 'QuillForge',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              fontColor: Colors.white,
              fontFamily: poppins,
            ),
            const SizedBox(height: 20),
            // Small loader for async tasks
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
