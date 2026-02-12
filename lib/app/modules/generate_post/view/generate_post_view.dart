import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/lists/language_list.dart';
import 'package:ainotes/app/modules/generate_post/controller/generate_post_controller.dart';
import 'package:search_choices/search_choices.dart';

import '../../../common/constants/app_strings.dart';

class GeneratePostView extends GetView<GeneratePostController> {
  const GeneratePostView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: _buildForm(context, isDark),
            ),
            _buildGenerateButton(context, isDark),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.generatePost,
                  style: TextStyle(
                    fontFamily: poppins,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Create engaging social media captions',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, bool isDark) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Language selector
            _buildSectionTitle(AppStrings.selectLanguage, isDark),
            SizedBox(height: 8.h),
            _buildLanguageSelector(isDark),
            SizedBox(height: 24.h),

            // Platform selector
            _buildSectionTitle(AppStrings.postTo, isDark),
            SizedBox(height: 12.h),
            _buildPlatformSelector(isDark),
            SizedBox(height: 24.h),

            // Caption input
            GetBuilder<GeneratePostController>(
              builder: (_) => _buildSectionTitle(
                'What is your ${controller.selectedSocialMedia} caption about?',
                isDark,
              ),
            ),
            SizedBox(height: 12.h),
            _buildCaptionInput(isDark),
            SizedBox(height: 24.h),

            // Tone selector
            _buildSectionTitle(AppStrings.toneVoice, isDark),
            SizedBox(height: 12.h),
            _buildToneSelector(isDark),

            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildLanguageSelector(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
      child: SearchChoices.single(
        items: items,
        value: controller.fromSelectedLanguage,
        hint: "Select language",
        searchHint: "Search language",
        onChanged: (value) {
          controller.fromSelectedLanguage = value;
          controller.update();
        },
        isExpanded: true,
        displayClearIcon: false,
        autofocus: false,
        padding: EdgeInsets.zero,
        underline: Container(),
        style: TextStyle(
          fontFamily: poppins,
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildPlatformSelector(bool isDark) {
    return GetBuilder<GeneratePostController>(
      builder: (_) => Row(
        children: List.generate(
          3,
              (index) => Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: _buildPlatformCard(isDark, index),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformCard(bool isDark, int index) {
    final isSelected = controller.selectedSocialMediaType == index;

    return GestureDetector(
      onTap: () {
        controller.selectedSocialMediaType = index;
        controller.selectedSocialMedia = controller.socialMediaPlatFormType[index];
        controller.update();
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? ColorCodes.purple : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: ColorCodes.purple.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
                  : (isDark
                  ? null
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]),
            ),
            child: Center(
              child: Image.asset(
                controller.socialMediaPlatFormImage[index],
                width: index == 0 ? 40 : 35,
                height: index == 0 ? 40 : 35,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.socialMediaPlatFormType[index],
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? ColorCodes.purple
                  : (isDark ? Colors.white54 : Colors.black45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptionInput(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: TextFormField(
        controller: controller.controller,
        maxLines: 4,
        cursorColor: ColorCodes.purple,
        style: TextStyle(
          fontFamily: poppins,
          fontSize: 15,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: AppStrings.askingChatGpt,
          hintStyle: TextStyle(
            fontFamily: poppins,
            fontSize: 14,
            color: isDark ? Colors.white30 : Colors.black26,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Align(
              alignment: Alignment.topRight,
              widthFactor: 1,
              heightFactor: 5,
              child: GestureDetector(
                onTap: () => controller.controller.clear(),
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  size: 18,
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppStrings.askingChatGpt;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildToneSelector(bool isDark) {
    return GetBuilder<GeneratePostController>(
      builder: (_) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          controller.voiceToneType.length,
              (index) {
            final isSelected = controller.selectedVoiceTone == index;
            return GestureDetector(
              onTap: () {
                controller.selectedVoiceTone = index;
                controller.selectedVoiceToneType = controller.voiceToneType[index];
                controller.update();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                    colors: [ColorCodes.purpleLight, ColorCodes.purple],
                  )
                      : null,
                  color: isSelected
                      ? null
                      : (isDark ? const Color(0xFF2C2C2E) : Colors.white),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected
                      ? null
                      : Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.08),
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: ColorCodes.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  controller.voiceToneType[index],
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black54),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context, bool isDark) {
    // Hide button when keyboard is visible
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            if (controller.formKey.currentState!.validate()) {
              controller.formKey.currentState!.save();
              controller.sendMsg(text: controller.controller.text);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorCodes.purpleLight, ColorCodes.purple],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ColorCodes.purple.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.sparkles,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 10.w),
                Text(
                  AppStrings.generate,
                  style: TextStyle(
                    fontFamily: poppins,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}