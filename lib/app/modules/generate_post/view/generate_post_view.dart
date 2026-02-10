import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/lists/language_list.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/generate_post/controller/generate_post_controller.dart';
import 'package:search_choices/search_choices.dart';

import '../../../common/constants/app_strings.dart';

class GeneratePostView extends GetView<GeneratePostController> {
  const GeneratePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CommonAppBar(
        elevation: 1,
        shadowColor: ColorCodes.grey,
        color: ColorCodes.background,
        surfaceTintColor: ColorCodes.background,
        centerTitle: true,
        title: const CommonText(
          text: AppStrings.generatePost,
          fontFamily: poppinsSemiBold,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton.extended(
          backgroundColor: ColorCodes.purple,
          onPressed: () {
            if (controller.formKey.currentState!.validate()) {
              controller.formKey.currentState!.save();
              controller.sendMsg(text: controller.controller.text);
            }
          },
          label: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: const CommonText(
              text: AppStrings.generate,
              fontColor: ColorCodes.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                const CommonText(
                  text: AppStrings.selectLanguage,
                  fontFamily: poppinsSemiBold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                SizedBox(
                  height: 5.h,
                ),
                CommonContainer(
                  width: 180,
                  backgroundColor: ColorCodes.background,
                  containerChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchChoices.single(
                      items: items,
                      value: controller.fromSelectedLanguage,
                      hint: "Select one",
                      searchHint: "Select one",
                      onChanged: (value) {
                        controller.fromSelectedLanguage = value;
                        controller.update();
                      },
                      isExpanded: true,
                      displayClearIcon: false,
                      autofocus: false,
                      padding: EdgeInsets.zero,
                      underline: Container(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 19.h,
                ),
                const CommonText(
                  text: AppStrings.postTo,
                  fontFamily: poppinsSemiBold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                SizedBox(
                  height: 10.h,
                ),
                GetBuilder<GeneratePostController>(
                  builder: (controller) {
                    return Row(
                      children: List.generate(
                        3,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 18),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.selectedSocialMediaType = index;

                                    controller.selectedSocialMedia = controller
                                        .socialMediaPlatFormType[index];
                                    controller.update();
                                  },
                                  child: Card(
                                    child: CommonContainer(
                                      height: 60,
                                      width: 60,
                                      borderWidth: 1.5,
                                      borderColor:
                                          controller.selectedSocialMediaType ==
                                                  index
                                              ? ColorCodes.purple
                                              : ColorCodes.background,
                                      containerChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            controller.socialMediaPlatFormImage[
                                                index],
                                            width: index == 0 ? 42 : 37,
                                            height: index == 0 ? 42 : 37,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                CommonText(
                                  text:
                                      controller.socialMediaPlatFormType[index],
                                  fontColor:
                                      ColorCodes.primary.withOpacity(0.8),
                                  fontSize: 10,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 25.h,
                ),
                GetBuilder<GeneratePostController>(
                  builder: (controller) {
                    return CommonText(
                      text:
                          "What is your ${controller.selectedSocialMedia} Caption about?",
                      fontFamily: poppinsSemiBold,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Stack(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.askingChatGpt;
                        }
                        return null;
                      },
                      controller: controller.controller,
                      cursorColor: ColorCodes.purple,
                      maxLines: 4,
                      decoration: InputDecoration(
                        fillColor: ColorCodes.background,
                        filled: true,
                        hintText: AppStrings.askingChatGpt,
                        hintStyle: const TextStyle(
                          fontFamily: poppins,
                          fontSize: 14,
                          color: ColorCodes.grey,
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 25),
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          maxWidth: double.infinity,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          controller.controller.clear();
                        },
                        child: const CommonmIcon(
                          icon: Icons.clear,
                          size: 19,
                          color: ColorCodes.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.h,
                ),
                const CommonText(
                  text: AppStrings.toneVoice,
                  fontFamily: poppinsSemiBold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                SizedBox(
                  height: 10.h,
                ),
                GetBuilder<GeneratePostController>(
                  builder: (controller) {
                    return Wrap(
                      children: List.generate(
                        controller.voiceToneType.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              controller.selectedVoiceTone = index;
                              controller.selectedVoiceToneType =
                                  controller.voiceToneType[index];
                              controller.update();
                            },
                            child: CommonContainer(
                              containerMargin: const EdgeInsets.all(6),
                              radius: 20,
                              borderWidth: 1.7,
                              borderColor: controller.selectedVoiceTone == index
                                  ? ColorCodes.purple
                                  : ColorCodes.background,
                              containerChild: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 7),
                                child: CommonText(
                                  text: controller.voiceToneType[index],
                                  fontWeight:
                                      controller.selectedVoiceTone == index
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontColor:
                                      controller.selectedVoiceTone == index
                                          ? ColorCodes.purple
                                          : ColorCodes.primary.withOpacity(0.5),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
