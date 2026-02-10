import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/lists/language_list.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/controller/ai_tools_response_controller.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/widget/textfield_widget.dart';
import 'package:search_choices/search_choices.dart';

import '../../../common/constants/app_strings.dart';

class AiToolsResponseView extends GetView<AiToolsResponseController> {
  const AiToolsResponseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CommonAppBar(
        elevation: 1,
        shadowColor: ColorCodes.grey,
        color: Theme.of(context).colorScheme.secondaryContainer,
        surfaceTintColor: Theme.of(context).colorScheme.secondaryContainer,
        centerTitle: true,
        title: CommonText(
          text: controller.title.toString(),
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
                // audience: "5",
                length: controller.selectedLength.toString(),
              );

              if (kDebugMode) {
                print(" PROMPT===========>   $prompt");
              }

              controller.sendMsg(text: prompt);
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
                CommonText(
                  text: controller.info.toString(),
                  fontFamily: poppins,
                  fontSize: 14,
                  fontColor: ColorCodes.grey,
                ),
                SizedBox(
                  height: 20.h,
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
                  height: 15.h,
                ),
                controller.length!
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CommonText(
                            text: AppStrings.selectLength,
                            fontFamily: poppinsSemiBold,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          GetBuilder<AiToolsResponseController>(
                            builder: (controller) {
                              return CommonContainer(
                                backgroundColor: ColorCodes.background,
                                containerChild: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: DropdownButton<String>(
                                    value: controller.dropdownValue,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items:
                                        controller.items.keys.map((String key) {
                                      return DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(
                                            key), // Display only the key (e.g., "Small")
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      controller.dropdownValue = newValue!;

                                      controller.selectedLength =
                                          controller.items[newValue];

                                      controller.update();
                                    },
                                    underline: Container(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
                controller.subheadings!
                    ? TextFieldWidget(
                        title: AppStrings.subheadings,
                        maxLines: 4,
                        hintText: AppStrings.enterSubheadings,
                        controller: controller.subheadingsController,
                        validationMessage: AppStrings.kSubheadings,
                      )
                    : const SizedBox(),
                controller.keywords!
                    ? TextFieldWidget(
                        title: AppStrings.keywords,
                        maxLines: 4,
                        hintText: AppStrings.enterKeywords,
                        controller: controller.keywordsController,
                        validationMessage: AppStrings.kKeywords,
                      )
                    : const SizedBox(),
                controller.product!
                    ? TextFieldWidget(
                        title: AppStrings.product,
                        maxLines: 1,
                        hintText: AppStrings.enterProduct,
                        controller: controller.productController,
                        validationMessage: AppStrings.kProduct,
                      )
                    : const SizedBox(),
                controller.description!
                    ? TextFieldWidget(
                        title: AppStrings.description,
                        maxLines: 4,
                        hintText: AppStrings.enterDescription,
                        controller: controller.descriptionController,
                        validationMessage: AppStrings.kDescription,
                      )
                    : const SizedBox(),
                controller.name!
                    ? TextFieldWidget(
                        title: AppStrings.name,
                        maxLines: 1,
                        hintText: AppStrings.enterName,
                        controller: controller.nameController,
                        validationMessage: AppStrings.kName,
                      )
                    : const SizedBox(),
                controller.titled!
                    ? TextFieldWidget(
                        title: AppStrings.titled,
                        maxLines: 1,
                        hintText: AppStrings.enterTitled,
                        controller: controller.titledController,
                        validationMessage: AppStrings.kTitled,
                      )
                    : const SizedBox(),
                controller.company!
                    ? TextFieldWidget(
                        title: AppStrings.company,
                        maxLines: 1,
                        hintText: AppStrings.enterCompany,
                        controller: controller.companyController,
                        validationMessage: AppStrings.kCompany,
                      )
                    : const SizedBox(),
                controller.subject!
                    ? TextFieldWidget(
                        title: AppStrings.subject,
                        maxLines: 4,
                        hintText: AppStrings.enterSubject,
                        controller: controller.subjectController,
                        validationMessage: AppStrings.kSubject,
                      )
                    : const SizedBox(),
                controller.position!
                    ? TextFieldWidget(
                        title: AppStrings.position,
                        maxLines: 2,
                        hintText: AppStrings.enterPosition,
                        controller: controller.positionController,
                        validationMessage: AppStrings.kPosition,
                      )
                    : const SizedBox(),
                controller.domains!
                    ? TextFieldWidget(
                        title: AppStrings.domains,
                        maxLines: 4,
                        hintText: AppStrings.enterDomains,
                        controller: controller.domainsController,
                        validationMessage: AppStrings.kDomains,
                      )
                    : const SizedBox(),
                controller.content!
                    ? TextFieldWidget(
                        title: AppStrings.content,
                        maxLines: 4,
                        hintText: AppStrings.enterContent,
                        controller: controller.contentController,
                        validationMessage: AppStrings.kContented,
                      )
                    : const SizedBox(),
                controller.tone!
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
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
                          GetBuilder<AiToolsResponseController>(
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
                                        containerMargin:
                                            const EdgeInsets.all(6),
                                        radius: 20,
                                        borderWidth: 1.7,
                                        borderColor:
                                            controller.selectedVoiceTone ==
                                                    index
                                                ? ColorCodes.purple
                                                : ColorCodes.background,
                                        containerChild: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 7),
                                          child: CommonText(
                                            text:
                                                controller.voiceToneType[index],
                                            fontWeight:
                                                controller.selectedVoiceTone ==
                                                        index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            fontColor:
                                                controller.selectedVoiceTone ==
                                                        index
                                                    ? ColorCodes.purple
                                                    : ColorCodes.primary
                                                        .withOpacity(0.5),
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
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
