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

import '../../../common/constants/app_strings.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/routes/app_pages.dart';

import '../../../common/constants/app_strings.dart';

/// iOS-style Watch Ads Dialog
void showWatchAdsDialog({
  required BuildContext context,
  required bool isDark,
  required VoidCallback watchAdsOnTap,
}) {
  Get.dialog(
    barrierDismissible: false,
    Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2E).withOpacity(0.95)
                    : Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCloseButton(isDark),
                      SizedBox(height: 8.h),
                      _buildHeader(isDark),
                      SizedBox(height: 20.h),
                      _buildFreeCreditsCard(isDark, watchAdsOnTap),
                      SizedBox(height: 16.h),
                      _buildPremiumCard(isDark),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildCloseButton(bool isDark) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.xmark,
            size: 16,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ),
    ],
  );
}

Widget _buildHeader(bool isDark) {
  return Column(
    children: [
      Text(
        'Get Free',
        style: TextStyle(
          fontFamily: poppins,
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
      Text(
        'Bonus Credit',
        style: TextStyle(
          fontFamily: poppins,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    ],
  );
}

Widget _buildFreeCreditsCard(bool isDark, VoidCallback watchAdsOnTap) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ColorCodes.purple.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5 Free',
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              'Chat Credits',
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 12,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: watchAdsOnTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.play_circle_fill,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 6.w),
                Text(
                  AppStrings.watchAds,
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPremiumCard(bool isDark) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          ColorCodes.purple.withOpacity(0.15),
          ColorCodes.purpleDark.withOpacity(0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.poweredBy,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            Text(
              AppStrings.gpt4,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.unlimit,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              AppStrings.chatMessages,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          AppStrings.adsFreeExperience,
          style: TextStyle(
            fontFamily: poppins,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 24.h),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.premiumView),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorCodes.purpleLight, ColorCodes.purple],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: ColorCodes.purple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  premiumIcon,
                  color: Colors.white,
                  height: 18,
                  width: 18,
                ),
                SizedBox(width: 8.w),
                Text(
                  AppStrings.getPremium,
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// iOS-style Congratulation Dialog
void showCongratulationDialog({
  required BuildContext context,
  required bool isDark,
  required VoidCallback onCollect,
}) {
  Get.dialog(
    barrierDismissible: false,
    Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2E).withOpacity(0.95)
                    : Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCloseButton(isDark),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          giftIcon,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        AppStrings.congratulation,
                        style: TextStyle(
                          fontFamily: poppins,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppStrings.collectCredit,
                        style: TextStyle(
                          fontFamily: poppins,
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      GestureDetector(
                        onTap: onCollect,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [ColorCodes.purpleLight, ColorCodes.purple],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: ColorCodes.purple.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            AppStrings.collect,
                            style: TextStyle(
                              fontFamily: poppins,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Legacy functions for backward compatibility
void watchAdsEarnRewardDialogBox({
  required BuildContext context,
  required VoidCallback watchAdsOnTap,
}) {
  showWatchAdsDialog(
    context: context,
    isDark: Theme.of(context).brightness == Brightness.dark,
    watchAdsOnTap: watchAdsOnTap,
  );
}

void congratulationDialogBox({
  required BuildContext context,
  required VoidCallback collected,
}) {
  showCongratulationDialog(
    context: context,
    isDark: Theme.of(context).brightness == Brightness.dark,
    onCollect: collected,
  );
}
// /// Watch Ads to get reward Dialog
// void watchAdsEarnRewardDialogBox({
//   required BuildContext context,
//   required VoidCallback watchAdsOnTap,
// }) {
//   Get.dialog(
//     barrierDismissible: false,
//     Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Container(
//             decoration: BoxDecoration(
//               color: ColorCodes.background,
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(20),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Material(
//                 color: ColorCodes.background,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Spacer(),
//                         CommonContainer(
//                           height: 40,
//                           width: 40,
//                           backgroundColor: ColorCodes.surface.withOpacity(0.2),
//                           borderColor: Colors.transparent,
//                           radius: 60,
//                           containerChild: IconButton(
//                             color: ColorCodes.surface.withOpacity(0.2),
//                             focusColor: ColorCodes.surface.withOpacity(0.2),
//                             splashColor: Colors.purple,
//                             iconSize: 19,
//                             constraints: const BoxConstraints(
//                                 maxHeight: 40, maxWidth: 40),
//                             onPressed: () {
//                               Get.back();
//                             },
//                             icon: Icon(
//                               Icons.clear,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Get",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontFamily: montserratRegular,
//                           ),
//                         ),
//                         Text(
//                           " Free",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontFamily: roboto,
//                             color: ColorCodes.grey.withOpacity(0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Bonus",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontFamily: montserratRegular,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           " Credit",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: ColorCodes.grey.withOpacity(0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 15),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               // ColorCodes.background,
//                               ColorCodes.purple.withOpacity(0.1),
//                               ColorCodes.purple.withOpacity(0.1),
//                             ],
//
//                             begin: FractionalOffset.topRight,
//                             end: FractionalOffset.bottomLeft,
//                             // tileMode: TileMode.repeated,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 12),
//                           child: Row(
//                             children: [
//                               const Column(
//                                 children: [
//                                   Text(
//                                     "5 Free",
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontFamily: montserratRegular,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     "Chat Credits",
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontFamily: roboto,
//                                       color: ColorCodes.grey,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const Spacer(),
//                               GestureDetector(
//                                 onTap: watchAdsOnTap,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: ColorCodes.purple,
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                       color: ColorCodes.white,
//                                     ),
//                                   ),
//                                   child: const Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 12),
//                                     child: Row(
//                                       children: [
//                                         Icon(
//                                           Icons.play_circle,
//                                           color: ColorCodes.white,
//                                           size: 15,
//                                         ),
//                                         SizedBox(
//                                           width: 6,
//                                         ),
//                                         Text(
//                                           AppStrings.watchAds,
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             color: ColorCodes.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: AnimateGradient(
//                           primaryBegin: Alignment.topRight,
//                           primaryEnd: Alignment.bottomRight,
//                           secondaryBegin: Alignment.bottomRight,
//                           secondaryEnd: Alignment.topLeft,
//                           primaryColors: [
//                             ColorCodes.purpleDark.withOpacity(0.1),
//                             ColorCodes.purple.withOpacity(0.1),
//                             ColorCodes.purple.withOpacity(0.1),
//                           ],
//                           secondaryColors: [
//                             ColorCodes.purpleDark.withOpacity(0.1),
//                             ColorCodes.purple.withOpacity(0.1),
//                             ColorCodes.purple.withOpacity(0.1),
//                           ],
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 12),
//                               child: Column(
//                                 children: [
//                                   const SizedBox(height: 10),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         AppStrings.poweredBy,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontFamily: montserratRegular,
//                                           color: ColorCodes.primary
//                                               .withOpacity(0.5),
//                                         ),
//                                       ),
//                                       const Text(
//                                         AppStrings.gpt4,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontFamily: montserratRegular,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 5.h,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Text(
//                                         AppStrings.unlimit,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontFamily: montserratRegular,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         AppStrings.chatMessages,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontFamily: montserratRegular,
//                                           color: ColorCodes.primary
//                                               .withOpacity(0.5),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 5.h,
//                                   ),
//                                   const Text(
//                                     AppStrings.adsFreeExperience,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontFamily: montserratRegular,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 40.h,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 20),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Get.toNamed(Routes.premiumView);
//                                       },
//                                       child: Container(
//                                         width: double.infinity,
//                                         decoration: BoxDecoration(
//                                           gradient: const LinearGradient(
//                                             colors: [
//                                               ColorCodes.purple,
//                                               ColorCodes.purpleDark,
//                                             ],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           ),
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           border: Border.all(
//                                             color: ColorCodes.white,
//                                           ),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 12, vertical: 12),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Image.asset(
//                                                 premiumIcon,
//                                                 color: ColorCodes.white,
//                                                 height: 20,
//                                                 width: 20,
//                                               ),
//                                               SizedBox(
//                                                 width: 10.w,
//                                               ),
//                                               const Text(
//                                                 AppStrings.getPremium,
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: ColorCodes.white,
//                                                   fontFamily: montserratRegular,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 7.h,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// /// congratulation DialogBox
// void congratulationDialogBox({
//   required BuildContext context,
//   required VoidCallback collected,
// }) {
//   Get.dialog(
//     barrierDismissible: false,
//     Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Container(
//             decoration: BoxDecoration(
//               color: ColorCodes.background,
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(20),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Material(
//                 color: ColorCodes.background,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Spacer(),
//                         CommonContainer(
//                           height: 40,
//                           width: 40,
//                           backgroundColor: ColorCodes.surface.withOpacity(0.2),
//                           borderColor: Colors.transparent,
//                           radius: 60,
//                           containerChild: IconButton(
//                             color: ColorCodes.surface.withOpacity(0.2),
//                             splashColor: Colors.purple,
//                             iconSize: 19,
//                             constraints: const BoxConstraints(
//                                 maxHeight: 40, maxWidth: 40),
//                             onPressed: () {
//                               Get.back();
//                             },
//                             icon: Icon(
//                               Icons.clear,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Image.asset(
//                       giftIcon,
//                       width: 80,
//                       height: 80,
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       AppStrings.congratulation,
//                       style: TextStyle(
//                         fontSize: 20,
//                         //  fontFamily: roboto,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     const Text(
//                       AppStrings.collectCredit,
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: ColorCodes.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: GestureDetector(
//                         onTap: collected,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: ColorCodes.purple,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: ColorCodes.white,
//                             ),
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 45, vertical: 12),
//                             child: Text(
//                               AppStrings.collect,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: ColorCodes.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
