import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/routes/app_pages.dart';

/// Watch Ads to get reward Dialog
void watchAdsEarnRewardDialogBox({
  required BuildContext context,
  required VoidCallback watchAdsOnTap,
}) {
  Get.dialog(
    barrierDismissible: false,
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            decoration: BoxDecoration(
              color: ColorCodes.background,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: ColorCodes.background,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        CustomContainer(
                          height: 40,
                          width: 40,
                          backgroundColor: ColorCodes.surface.withOpacity(0.2),
                          borderColor: Colors.transparent,
                          radius: 60,
                          containerChild: IconButton(
                            color: ColorCodes.surface.withOpacity(0.2),
                            focusColor: ColorCodes.surface.withOpacity(0.2),
                            splashColor: Colors.teal,
                            iconSize: 19,
                            constraints: const BoxConstraints(
                                maxHeight: 40, maxWidth: 40),
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Get",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: montserratRegular,
                          ),
                        ),
                        Text(
                          " Free",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: roboto,
                            color: ColorCodes.grey.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Bonus",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: montserratRegular,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " Credit",
                          style: TextStyle(
                            fontSize: 18,
                            color: ColorCodes.grey.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              // ColorCodes.background,
                              ColorCodes.teal.withOpacity(0.1),
                              ColorCodes.teal.withOpacity(0.1),
                            ],

                            begin: FractionalOffset.topRight,
                            end: FractionalOffset.bottomLeft,
                            // tileMode: TileMode.repeated,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              const Column(
                                children: [
                                  Text(
                                    "5 Free",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: montserratRegular,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Chat Credits",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: roboto,
                                      color: ColorCodes.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: watchAdsOnTap,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorCodes.teal,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: ColorCodes.white,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.play_circle,
                                          color: ColorCodes.white,
                                          size: 15,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          AppConstants.watchAds,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: ColorCodes.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AnimateGradient(
                          primaryBegin: Alignment.topRight,
                          primaryEnd: Alignment.bottomRight,
                          secondaryBegin: Alignment.bottomRight,
                          secondaryEnd: Alignment.topLeft,
                          primaryColors: [
                            ColorCodes.purpleDark.withOpacity(0.1),
                            ColorCodes.teal.withOpacity(0.1),
                            ColorCodes.teal.withOpacity(0.1),
                          ],
                          secondaryColors: [
                            ColorCodes.purpleDark.withOpacity(0.1),
                            ColorCodes.teal.withOpacity(0.1),
                            ColorCodes.teal.withOpacity(0.1),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppConstants.poweredBy,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: montserratRegular,
                                          color: ColorCodes.primary
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      const Text(
                                        AppConstants.gpt4,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: montserratRegular,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        AppConstants.unlimit,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: montserratRegular,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        AppConstants.chatMessages,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: montserratRegular,
                                          color: ColorCodes.primary
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  const Text(
                                    AppConstants.adsFreeExperience,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: montserratRegular,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(Routes.premiumView);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              ColorCodes.purple,
                                              ColorCodes.purpleDark,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            color: ColorCodes.white,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                premiumIcon,
                                                color: ColorCodes.white,
                                                height: 20,
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              const Text(
                                                AppConstants.getPremium,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: ColorCodes.white,
                                                  fontFamily: montserratRegular,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// congratulation DialogBox
void congratulationDialogBox({
  required BuildContext context,
  required VoidCallback collected,
}) {
  Get.dialog(
    barrierDismissible: false,
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
              color: ColorCodes.background,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: ColorCodes.background,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        CustomContainer(
                          height: 40,
                          width: 40,
                          backgroundColor: ColorCodes.surface.withOpacity(0.2),
                          borderColor: Colors.transparent,
                          radius: 60,
                          containerChild: IconButton(
                            color: ColorCodes.surface.withOpacity(0.2),
                            splashColor: Colors.teal,
                            iconSize: 19,
                            constraints: const BoxConstraints(
                                maxHeight: 40, maxWidth: 40),
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      giftIcon,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      AppConstants.congratulation,
                      style: TextStyle(
                        fontSize: 20,
                        //  fontFamily: roboto,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      AppConstants.collectCredit,
                      style: TextStyle(
                        fontSize: 10,
                        color: ColorCodes.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: collected,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorCodes.teal,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorCodes.white,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45, vertical: 12),
                            child: Text(
                              AppConstants.collect,
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorCodes.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
