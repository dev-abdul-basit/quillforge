import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/lists/lists.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/controller/ai_tools_response_controller.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/widget/textfield_widget.dart';
import 'package:search_choices/search_choices.dart';

class AiToolsResponseView extends GetView<AiToolsResponseController> {
  const AiToolsResponseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: CustomAppBar(
        elevation: 1,
        shadowColor: ColorCodes.grey,
        color: Theme.of(context).colorScheme.secondaryContainer,
        surfaceTintColor: Theme.of(context).colorScheme.secondaryContainer,
        centerTitle: true,
        title: CustomText(
          text: controller.title.toString(),
          fontFamily: poppinsSemiBold,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton.extended(
          backgroundColor: ColorCodes.teal,
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
            child: const CustomText(
              text: AppConstants.generate,
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
                CustomText(
                  text: controller.info.toString(),
                  fontFamily: poppins,
                  fontSize: 14,
                  fontColor: ColorCodes.grey,
                ),
                SizedBox(
                  height: 20.h,
                ),
                const CustomText(
                  text: AppConstants.selectLanguage,
                  fontFamily: poppinsSemiBold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                SizedBox(
                  height: 5.h,
                ),
                CustomContainer(
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
                          const CustomText(
                            text: AppConstants.selectLength,
                            fontFamily: poppinsSemiBold,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          GetBuilder<AiToolsResponseController>(
                            builder: (controller) {
                              return CustomContainer(
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
                        title: AppConstants.subheadings,
                        maxLines: 4,
                        hintText: AppConstants.enterSubheadings,
                        controller: controller.subheadingsController,
                        validationMessage: AppConstants.kSubheadings,
                      )
                    : const SizedBox(),
                controller.keywords!
                    ? TextFieldWidget(
                        title: AppConstants.keywords,
                        maxLines: 4,
                        hintText: AppConstants.enterKeywords,
                        controller: controller.keywordsController,
                        validationMessage: AppConstants.kKeywords,
                      )
                    : const SizedBox(),
                controller.product!
                    ? TextFieldWidget(
                        title: AppConstants.product,
                        maxLines: 1,
                        hintText: AppConstants.enterProduct,
                        controller: controller.productController,
                        validationMessage: AppConstants.kProduct,
                      )
                    : const SizedBox(),
                controller.description!
                    ? TextFieldWidget(
                        title: AppConstants.description,
                        maxLines: 4,
                        hintText: AppConstants.enterDescription,
                        controller: controller.descriptionController,
                        validationMessage: AppConstants.kDescription,
                      )
                    : const SizedBox(),
                controller.name!
                    ? TextFieldWidget(
                        title: AppConstants.name,
                        maxLines: 1,
                        hintText: AppConstants.enterName,
                        controller: controller.nameController,
                        validationMessage: AppConstants.kName,
                      )
                    : const SizedBox(),
                controller.titled!
                    ? TextFieldWidget(
                        title: AppConstants.titled,
                        maxLines: 1,
                        hintText: AppConstants.enterTitled,
                        controller: controller.titledController,
                        validationMessage: AppConstants.kTitled,
                      )
                    : const SizedBox(),
                controller.company!
                    ? TextFieldWidget(
                        title: AppConstants.company,
                        maxLines: 1,
                        hintText: AppConstants.enterCompany,
                        controller: controller.companyController,
                        validationMessage: AppConstants.kCompany,
                      )
                    : const SizedBox(),
                controller.subject!
                    ? TextFieldWidget(
                        title: AppConstants.subject,
                        maxLines: 4,
                        hintText: AppConstants.enterSubject,
                        controller: controller.subjectController,
                        validationMessage: AppConstants.kSubject,
                      )
                    : const SizedBox(),
                controller.position!
                    ? TextFieldWidget(
                        title: AppConstants.position,
                        maxLines: 2,
                        hintText: AppConstants.enterPosition,
                        controller: controller.positionController,
                        validationMessage: AppConstants.kPosition,
                      )
                    : const SizedBox(),
                controller.domains!
                    ? TextFieldWidget(
                        title: AppConstants.domains,
                        maxLines: 4,
                        hintText: AppConstants.enterDomains,
                        controller: controller.domainsController,
                        validationMessage: AppConstants.kDomains,
                      )
                    : const SizedBox(),
                controller.content!
                    ? TextFieldWidget(
                        title: AppConstants.content,
                        maxLines: 4,
                        hintText: AppConstants.enterContent,
                        controller: controller.contentController,
                        validationMessage: AppConstants.kContented,
                      )
                    : const SizedBox(),
                controller.tone!
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          const CustomText(
                            text: AppConstants.toneVoice,
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
                                      child: CustomContainer(
                                        containerMargin:
                                            const EdgeInsets.all(6),
                                        radius: 20,
                                        borderWidth: 1.7,
                                        borderColor:
                                            controller.selectedVoiceTone ==
                                                    index
                                                ? ColorCodes.teal
                                                : ColorCodes.background,
                                        containerChild: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 7),
                                          child: CustomText(
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
                                                    ? ColorCodes.teal
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
