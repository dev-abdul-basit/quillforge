import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/modules/setting/controller/setting_controller.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:ainotes/app/theme/theme_controller/theme_controller.dart';

import '../../../common/constants/app_strings.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ThemeController themeController = Get.put(ThemeController());

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    if (!premiumController.isPremium) ...[
                      SizedBox(height: 8.h),
                      _buildPremiumBanner(context, isDark),
                    ],
                    SizedBox(height: 20.h),
                    _buildThemeSection(context, isDark, themeController),
                    SizedBox(height: 16.h),
                    _buildSettingsSection(context, isDark),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isDark
                    ? null
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.back,
                size: 20,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            AppStrings.settings,
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: ColorCodes.primaryGradientSubtle,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    CupertinoIcons.sparkles,
                    color: isDark ? Colors.white60 : ColorCodes.purple,
                    size: 26,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Free Credits Remaining",
                        style: TextStyle(
                          fontFamily: poppins,
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.black45,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            homeController.messageLimit.toString(),
                            style: TextStyle(
                              fontFamily: poppins,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : ColorCodes.purple,
                            ),
                          ),
                          Text(
                            " / 5",
                            style: TextStyle(
                              fontFamily: poppins,
                              fontSize: 16,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: ColorCodes.purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.gift,
                    size: 14,
                    color: isDark ? Colors.white60 : ColorCodes.purple,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    AppStrings.unlockVip,
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: 12,
                      color: isDark ? Colors.white60 : ColorCodes.purple,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.premiumView),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: ColorCodes.primaryGradientDiagonal,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: ColorCodes.purple.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.star_fill,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.upgrade,
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
      ),
    );
  }

  Widget _buildThemeSection(
      BuildContext context,
      bool isDark,
      ThemeController themeController,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorCodes.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
                size: 20,
                color: ColorCodes.purple,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Theme',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    isDark ? 'Dark Mode' : 'Light Mode',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Obx(
                  () => CupertinoSwitch(
                value: themeController.isDarkMode.value,
                activeColor: ColorCodes.purple,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, bool isDark) {
    // Icons for each setting item
    final List<IconData> settingIcons = [
      CupertinoIcons.star_fill, // Favourite
      CupertinoIcons.question_circle, // FAQ
      CupertinoIcons.hand_thumbsup, // Rating
      CupertinoIcons.share, // Share
      CupertinoIcons.shield, // Privacy
      CupertinoIcons.doc_text, // Terms
    ];

    final List<Color> iconColors = [
      Colors.orange,
      ColorCodes.purple,
      Colors.green,
      Colors.blue,
      Colors.teal,
      Colors.indigo,
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          controller.settings.length,
              (index) => _buildSettingItem(
            context: context,
            isDark: isDark,
            title: controller.settings[index],
            icon: settingIcons[index],
            iconColor: iconColors[index],
            onTap: () => controller.navigateToScreen(index),
            showDivider: index < controller.settings.length - 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required bool isDark,
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: poppins,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: 60.w),
            child: Container(
              height: 1,
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
      ],
    );
  }
}