import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/modules/Premium/controller/premium_controller.dart';

import '../../../common/constants/app_strings.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorCodes.purpleLight,
              ColorCodes.purple,
              const Color(0xFF4A148C),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      _buildPremiumIcon(),
                      SizedBox(height: 24.h),
                      _buildTitle(),
                      SizedBox(height: 24.h),
                      _buildFeaturesList(),
                      SizedBox(height: 32.h),
                      _buildSubscriptionOptions(context, isDark),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              _buildContinueButton(context),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.xmark,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          // Restore purchases button
          GestureDetector(
            onTap: () {
              // TODO: Implement restore purchases
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Restore',
                style: TextStyle(
                  fontFamily: poppins,
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        premiumIcon,
        color: Colors.white,
        width: 80.w,
        height: 80.h,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          AppStrings.unlockPremium,
          style: TextStyle(
            fontFamily: poppins,
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Get unlimited access to all features',
          style: TextStyle(
            fontFamily: poppins,
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(
          controller.type.length,
              (index) => _buildFeatureItem(controller.type[index], index),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature, int index) {
    final List<IconData> icons = [
      CupertinoIcons.sparkles, // GPT-4
      CupertinoIcons.person_2, // Social Assistant
      CupertinoIcons.infinite, // Unlimited
      CupertinoIcons.nosign, // Ads Free
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icons[index],
              size: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.checkmark_circle_fill,
            size: 22,
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOptions(BuildContext context, bool isDark) {
    return GetBuilder<PremiumController>(
      builder: (_) {
        if (controller.products.isEmpty) {
          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: ColorCodes.purple,
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Loading plans...',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: List.generate(
              controller.products.length,
                  (index) => Expanded(
                child: _buildPlanCard(index),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(int index) {
    final isSelected = controller.selected == index;
    final product = controller.products[index];

    // Clean up title
    String title = product.title
        .replaceAll("(com.aichatbot.aichatbot (unreviewed))", "")
        .trim();

    return GestureDetector(
      onTap: () => controller.onSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorCodes.purple.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? ColorCodes.purple : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Popular badge for middle option
            if (index == 1)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorCodes.purpleLight, ColorCodes.purple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'BEST VALUE',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            else
              SizedBox(height: 22.h),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: isSelected ? ColorCodes.purple : Colors.black54,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              product.price,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isSelected ? ColorCodes.purple : Colors.black87,
              ),
            ),
            // Selection indicator
            SizedBox(height: 8.h),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ColorCodes.purple : Colors.grey.withOpacity(0.3),
                  width: 2,
                ),
                color: isSelected ? ColorCodes.purple : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                CupertinoIcons.checkmark,
                size: 12,
                color: Colors.white,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => controller.buy(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    size: 22,
                    color: ColorCodes.purple,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: poppins,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: ColorCodes.purple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Terms and privacy links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Link to terms
                },
                child: Text(
                  'Terms of Use',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 11,
                    color: Colors.white54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                '  •  ',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white38,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Link to privacy
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 11,
                    color: Colors.white54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}