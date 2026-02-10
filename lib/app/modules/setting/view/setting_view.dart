import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/modules/setting/controller/setting_controller.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:ainotes/app/theme/theme_controller/theme_controller.dart';

import '../../../common/constants/app_strings.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CommonAppBar(
        color: Theme.of(context).colorScheme.secondaryContainer,
        centerTitle: true,
        title: const CommonText(
          text: AppStrings.settings,
          fontFamily: poppinsSemiBold,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            premiumController.isPremium == true
                ? SizedBox()
                : Stack(
                    children: [
                      CommonContainer(
                        height: 150,
                        width: double.infinity,
                        image: const DecorationImage(
                            image: AssetImage(vipBG), fit: BoxFit.cover),
                      ),
                      CommonContainer(
                        height: 150,
                        width: double.infinity,
                        backgroundColor: ColorCodes.black.withOpacity(0.7),
                        containerChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CommonText(
                                  text: "Today's Free Premium Access:",
                                  fontColor: ColorCodes.white,
                                  fontFamily: montserratRegular,
                                  fontWeight: FontWeight.bold,

                                  maxLines: 1,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  //fontWeight: FontWeight.bold,
                                ),
                                CommonText(
                                  text:
                                      " ${homeController.messageLimit.toString()}",
                                  fontColor: ColorCodes.orange,
                                  fontFamily: montserratRegular,
                                  fontWeight: FontWeight.bold,

                                  maxLines: 1,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            const CommonText(
                              text: AppStrings.unlockVip,
                              fontColor: ColorCodes.white,
                              fontFamily: montserratRegular,
                              maxLines: 1,
                              fontSize: 10,
                              overflow: TextOverflow.ellipsis,
                              //fontWeight: FontWeight.bold,
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.premiumView);
                              },
                              child: Container(
                                width: 200.w,
                                height: 47,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    colors: [
                                      ColorCodes.orange,
                                      ColorCodes.pink
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: CommonText(
                                    text: AppStrings.upgrade,
                                    fontSize: 14,
                                    fontFamily: poppins,
                                    fontColor: ColorCodes.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 15,
            ),
            CommonContainer(
              containerChild: Column(
                children: [
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: 0),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    title: const Padding(
                      padding: EdgeInsets.only(left: 7),
                      child: Text(
                        "App Theme",
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: poppinsSemiBold,
                        ),
                      ),
                    ),
                    trailing: Obx(
                      () => Theme(
                        data: ThemeData(
                          useMaterial3: true,
                        ).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(
                                outline: ColorCodes.purple,
                              ),
                        ),
                        child: Switch(
                          value: themeController.isDarkMode.value,
                          onChanged: (value) {
                            themeController.toggleTheme();
                            themeController.update();
                          },
                          activeTrackColor: ColorCodes.primary.withOpacity(0.1),
                          activeColor: ColorCodes.primary.withOpacity(0.1),
                          thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return ColorCodes.primary.withOpacity(
                                    0.1); // Thumb color when the switch is on
                              }
                              return ColorCodes
                                  .purple; // Thumb color when the switch is off
                            },
                          ),
                          thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.selected)) {
                                return const Icon(
                                  Icons.brightness_2,
                                  color: Colors.white,
                                );
                              } else {
                                return const Icon(
                                  Icons.sunny,
                                  color: Colors.white,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CommonContainer(
              containerChild: Column(
                  children: List.generate(
                controller.settings.length,
                (index) {
                  return GestureDetector(
                    // onTap: () => controller.navigateToScreen(index),
                    child: ListTile(
                      onTap: () => controller.navigateToScreen(index),
                      title: Text(
                        controller.settings[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          // fontFamily: montserratRegular,
                          fontFamily: poppinsSemiBold,
                        ),
                      ),
                      trailing: const CommonmIcon(
                        icon: Icons.arrow_forward_ios_sharp,
                        size: 16,
                      ),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
