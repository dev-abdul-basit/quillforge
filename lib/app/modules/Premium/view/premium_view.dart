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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
        gradient: ColorCodes.primaryGradientVertical,
      ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 16.h),
                _buildCompactHero(),
                SizedBox(height: 20.h),
                // _buildFeatureChips(),
                _buildFeaturesList(),
                SizedBox(height: 24.h),
                Expanded(child: _buildSubscriptionPlans()),
                _buildContinueButton(),
                SizedBox(height: 8.h),
                _buildFooterLinks(),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              CupertinoIcons.xmark,
              size: 18,
              color: Colors.white70,
            ),
          ),
        ),
        const Spacer(),
        // GestureDetector(
        //   onTap: () => controller.restorePurchases(),
        //   child: Text(
        //     'Restore',
        //     style: TextStyle(
        //       fontFamily: poppins,
        //       fontSize: 13,
        //       color: Colors.white60,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildCompactHero() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(
            premiumIcon,
            color: Colors.white,
            width: 32.w,
            height: 32.h,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.unlockPremium,
                style: TextStyle(
                  fontFamily: poppins,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Unlimited access to all features',
                style: TextStyle(
                  fontFamily: poppins,
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildChip(CupertinoIcons.sparkles, 'GPT-4o'),
        _buildChip(CupertinoIcons.infinite, 'Unlimited'),
        _buildChip(CupertinoIcons.nosign, 'No Ads'),
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
  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans() {
    return GetBuilder<PremiumController>(
      builder: (_) {
        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white70,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Loading plans...',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          );
        }

        final sortedProducts = controller.sortedProducts;

        return Column(
          children: List.generate(sortedProducts.length, (index) {
            final product = sortedProducts[index];
            final actualIndex = controller.getActualIndex(product);
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _buildPlanTile(product, actualIndex),
            );
          }),
        );
      },
    );
  }

  Widget _buildPlanTile(dynamic product, int actualIndex) {
    final isSelected = controller.selected == actualIndex;
    final isMonthly = controller.isMonthlyPlan(product.id);
    final title = controller.getCleanTitle(product.id);
    final savings = controller.getSavingsText(product.id);

    return GestureDetector(
      onTap: () => controller.onSelected(actualIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : isMonthly
                ? Colors.amber.withOpacity(0.5)
                : Colors.white24,
            width: isMonthly ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ]
              : null,
        ),
        child: Row(
          children: [
            _buildRadioIndicator(isSelected),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: poppins,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isSelected ? Colors.black87 : Colors.white,
                        ),
                      ),
                      if (isMonthly) ...[
                        SizedBox(width: 8.w),
                        _buildBestValueBadge(),
                      ],
                    ],
                  ),
                  if (savings != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      savings,
                      style: TextStyle(
                        fontFamily: poppins,
                        fontSize: 11,
                        color: isSelected
                            ? ColorCodes.purple
                            : Colors.greenAccent.shade200,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              product.price,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: isSelected ? ColorCodes.purple : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioIndicator(bool isSelected) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? ColorCodes.purple : Colors.white38,
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
    );
  }

  Widget _buildBestValueBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: () => controller.buy(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Continue',
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: ColorCodes.purple,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => controller.openTerms(),
          child: Text(
            'Terms & Conditions',
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 11,
              color: Colors.white38,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            '•',
            style: TextStyle(fontSize: 11, color: Colors.white24),
          ),
        ),
        GestureDetector(
          onTap: () => controller.openPrivacy(),
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 11,
              color: Colors.white38,
            ),
          ),
        ),
      ],
    );
  }
}