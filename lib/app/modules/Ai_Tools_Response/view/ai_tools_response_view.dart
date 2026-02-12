import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/lists/language_list.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/controller/ai_tools_response_controller.dart';
import 'package:search_choices/search_choices.dart';

import '../../../common/constants/app_strings.dart';

class AiToolsResponseView extends GetView<AiToolsResponseController> {
  const AiToolsResponseView({super.key});

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
            child: Text(
              controller.title ?? '',
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
            SizedBox(height: 8.h),
            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorCodes.purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.info_circle,
                    size: 20,
                    color: ColorCodes.purple,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      controller.info ?? '',
                      style: TextStyle(
                        fontFamily: poppins,
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Language selector
            _buildSectionTitle('Select Language', isDark),
            SizedBox(height: 8.h),
            _buildLanguageSelector(isDark),

            // Length selector
            if (controller.length == true) ...[
              SizedBox(height: 20.h),
              _buildSectionTitle(AppStrings.selectLength, isDark),
              SizedBox(height: 8.h),
              _buildLengthSelector(isDark),
            ],

            // Dynamic text fields
            if (controller.subheadings == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.subheadings,
                hintText: AppStrings.enterSubheadings,
                controller: controller.subheadingsController,
                validationMessage: AppStrings.kSubheadings,
                maxLines: 3,
              ),
            if (controller.keywords == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.keywords,
                hintText: AppStrings.enterKeywords,
                controller: controller.keywordsController,
                validationMessage: AppStrings.kKeywords,
                maxLines: 3,
              ),
            if (controller.product == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.product,
                hintText: AppStrings.enterProduct,
                controller: controller.productController,
                validationMessage: AppStrings.kProduct,
              ),
            if (controller.description == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.description,
                hintText: AppStrings.enterDescription,
                controller: controller.descriptionController,
                validationMessage: AppStrings.kDescription,
                maxLines: 3,
              ),
            if (controller.name == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.name,
                hintText: AppStrings.enterName,
                controller: controller.nameController,
                validationMessage: AppStrings.kName,
              ),
            if (controller.titled == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.titled,
                hintText: AppStrings.enterTitled,
                controller: controller.titledController,
                validationMessage: AppStrings.kTitled,
              ),
            if (controller.company == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.company,
                hintText: AppStrings.enterCompany,
                controller: controller.companyController,
                validationMessage: AppStrings.kCompany,
              ),
            if (controller.subject == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.subject,
                hintText: AppStrings.enterSubject,
                controller: controller.subjectController,
                validationMessage: AppStrings.kSubject,
                maxLines: 3,
              ),
            if (controller.position == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.position,
                hintText: AppStrings.enterPosition,
                controller: controller.positionController,
                validationMessage: AppStrings.kPosition,
                maxLines: 2,
              ),
            if (controller.domains == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.domains,
                hintText: AppStrings.enterDomains,
                controller: controller.domainsController,
                validationMessage: AppStrings.kDomains,
                maxLines: 3,
              ),
            if (controller.content == true)
              _buildTextField(
                isDark: isDark,
                title: AppStrings.content,
                hintText: AppStrings.enterContent,
                controller: controller.contentController,
                validationMessage: AppStrings.kContented,
                maxLines: 4,
              ),

            // Tone selector
            if (controller.tone == true) ...[
              SizedBox(height: 20.h),
              _buildSectionTitle(AppStrings.toneVoice, isDark),
              SizedBox(height: 12.h),
              _buildToneSelector(isDark),
            ],

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

  Widget _buildLengthSelector(bool isDark) {
    return GetBuilder<AiToolsResponseController>(
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
        child: DropdownButton<String>(
          value: controller.dropdownValue,
          icon: Icon(
            CupertinoIcons.chevron_down,
            size: 16,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
          isExpanded: true,
          underline: const SizedBox(),
          dropdownColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          style: TextStyle(
            fontFamily: poppins,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
          items: controller.items.keys.map((String key) {
            return DropdownMenuItem<String>(
              value: key,
              child: Text(key),
            );
          }).toList(),
          onChanged: (String? newValue) {
            controller.dropdownValue = newValue!;
            controller.selectedLength = controller.items[newValue];
            controller.update();
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required bool isDark,
    required String title,
    required String hintText,
    required TextEditingController controller,
    required String validationMessage,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        _buildSectionTitle(title, isDark),
        SizedBox(height: 8.h),
        Container(
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
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            cursorColor: ColorCodes.purple,
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: poppins,
                fontSize: 14,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              suffixIcon: GestureDetector(
                onTap: () => controller.clear(),
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  size: 18,
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validationMessage;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToneSelector(bool isDark) {
    return GetBuilder<AiToolsResponseController>(
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E)
            : const Color(0xFFF2F2F7),
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            if (controller.formKey.currentState!.validate()) {
              controller.formKey.currentState!.save();

              var prompt = controller.generatePrompt(
                language: controller.fromSelectedLanguage.toString(),
                content: controller.contentController.text,
                product: controller.productController.text,
                tone: controller.selectedVoiceToneType.toString(),
                description: controller.descriptionController.text,
                keywords: controller.keywordsController.text,
                subject: controller.subjectController.text,
                name: controller.nameController.text,
                titled: controller.titledController.text,
                company: controller.companyController.text,
                position: controller.positionController.text,
                domains: controller.domainsController.text,
                subheadings: controller.subheadingsController.text,
                length: controller.selectedLength.toString(),
              );

              if (kDebugMode) {
                print("PROMPT: $prompt");
              }

              controller.sendMsg(text: prompt);
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