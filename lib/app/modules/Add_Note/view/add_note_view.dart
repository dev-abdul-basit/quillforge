import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_field_widget.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';
import 'package:ainotes/app/modules/Add_Note/widgets/ask_question_gpt.dart';
import 'package:ainotes/app/modules/Add_Note/widgets/scan_to_text_bottomsheet.dart';
import 'package:ainotes/app/modules/Add_Note/widgets/speech_to_text_bottomsheet.dart';

class AddNoteView extends GetView<AddNoteController> {
  const AddNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      autoAlign: true,
      floatingWidget: FloatingActionButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: ColorCodes.teal,
        onPressed: () {
          //todo:1
          //controller.chatGpt();
        },
        child: Image.asset(
          openAiLogo,
          height: 25,
          width: 25,
          color: ColorCodes.white,
        ),
      ),
      floatingWidgetHeight: 40,
      floatingWidgetWidth: 40,
      dx: 0,
      dy: 300,
      mainScreenWidget: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          appBar: CustomAppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () {},
                  //todo:2

                //   if (controller.focusNode.hasFocus ||
                //       controller.focusNodeTitle.hasFocus) {
                //     FocusManager.instance.primaryFocus?.unfocus();
                //     Future.delayed(
                //       const Duration(milliseconds: 200),
                //       () {
                //         Get.back();
                //       },
                //     );
                //   } else {
                //     Get.back();
                //   }
                // },
                child: CustomContainer(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  borderWidth: 0,
                  containerChild: const CustomIcon(icon: Icons.clear),
                ),
              ),
            ),
            leadingWidth: 50,
            titleSpacing: 5,
            title: GetBuilder<AddNoteController>(
              builder: (controller) {
                return CustomTextField(
                  onTap: () {
                    //todo:3
                    // controller.isChatGpt = false;
                    // controller.update();
                  },
                  // onChanged: (value) => controller.onChangeValueTitle(value),
                  // controller: controller.titleController,
                  fillColor: Theme.of(context).colorScheme.background,
                  maxLines: 1,
                  maxWidth: double.infinity,
                  hintText: AppConstants.title,
                  //focusNode: controller.focusNodeTitle,
                  hintStyle: const TextStyle(
                    fontFamily: poppins,
                    fontWeight: FontWeight.bold,
                    color: ColorCodes.grey,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorCodes.teal,
                  ),
                  minHeight: 30,
                  borderRadius: 15,
                  enabledBorderRadius: 15,
                  focusedBorderRadius: 15,
                );
              },
            ),
            actions: [
              GetBuilder<AddNoteController>(
                builder: (controller) {
                  return controller.titleController.text.isNotEmpty ||
                          controller.textController.text.isNotEmpty
                      ? IconButton(
                          highlightColor: Colors.teal.withOpacity(0.2),
                          onPressed: () {
                            controller.creteAndUpdateNote();
                            Get.back();
                          },
                          icon: Image.asset(
                            saveIcon,
                            height: 20,
                            width: 20,
                          ),
                        )
                      : const SizedBox();
                },
              ),
              SizedBox(
                width: 15.w,
              ),
            ],
          ),
          body: GetBuilder<AddNoteController>(
            builder: (controller) {
              return Stack(
                children: [
                  Column(
                    children: [
                      GetBuilder<AddNoteController>(
                        builder: (controller) {
                          return Expanded(
                            child: TextField(
                              onTap: () {
                                controller.isChatGpt = false;
                                controller.update();
                              },
                              controller: controller.textController,
                              focusNode: controller.focusNode,
                              cursorColor: ColorCodes.teal,
                              maxLines: null,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                filled: true,
                                hintText: AppConstants.hint,
                                hintStyle: const TextStyle(
                                  fontFamily: poppins,
                                  color: ColorCodes.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 15,
                                ),
                                constraints: const BoxConstraints(
                                  minHeight: 30,
                                  maxWidth: double.infinity,
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      GetBuilder<AddNoteController>(
                        builder: (controller) {
                          return CustomContainer(
                            height: 50,
                            containerChild: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  highlightColor: Colors.teal.withOpacity(0.2),
                                  onPressed: () =>
                                      controller.focusToTextField(),
                                  icon: const CustomIcon(
                                    icon: Icons.keyboard_alt_outlined,
                                    size: 22,
                                    color: ColorCodes.teal,
                                  ),
                                ),

                                IconButton(
                                  highlightColor: Colors.teal.withOpacity(0.2),
                                  onPressed: () {
                                    if (controller.focusNode.hasFocus ||
                                        controller.focusNodeTitle.hasFocus) {
                                      controller.unfocusToTextField();
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {
                                          showCommonBottomSheetVoiceTranslation();
                                        },
                                      );
                                    } else {
                                      showCommonBottomSheetVoiceTranslation();
                                    }
                                  },
                                  icon: const CustomIcon(
                                    icon: Icons.mic,
                                    size: 22,
                                    color: ColorCodes.teal,
                                  ),
                                ),

                                IconButton(
                                  highlightColor: Colors.teal.withOpacity(0.2),
                                  onPressed: () {
                                    if (controller.focusNode.hasFocus ||
                                        controller.focusNodeTitle.hasFocus) {
                                      controller.unfocusToTextField();
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {
                                          showCommonBottomSheetScan();
                                        },
                                      );
                                    } else {
                                      showCommonBottomSheetScan();
                                    }
                                  },
                                  icon: const CustomIcon(
                                    icon: Icons.document_scanner,
                                    size: 22,
                                    color: ColorCodes.teal,
                                  ),
                                ),

                                /// condition to text field focus to show other wise not show
                                if (controller.focusNode.hasFocus ||
                                    controller.focusNodeTitle.hasFocus)
                                  IconButton(
                                    highlightColor:
                                        Colors.teal.withOpacity(0.2),
                                    onPressed: () =>
                                        controller.unfocusToTextField(),
                                    icon: const RotatedBox(
                                      quarterTurns: 3,
                                      child: CustomIcon(
                                        icon: Icons.arrow_back_ios_sharp,
                                        size: 19,
                                        color: ColorCodes.teal,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  if (controller.isChatGpt == true)
                    const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AskQuestionGpt(),
                    ),
                ],
              );
            },
          )),
    );
  }
}
