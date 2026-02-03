import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

/// Voice to text
void showCommonBottomSheetVoiceTranslation() {
  final AddNoteController controller = Get.put(AddNoteController());

  Get.bottomSheet(
    isScrollControlled: true,
    GetBuilder<AddNoteController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          height: controller.correctionAiResponse.isNotEmpty
              ? 550.h
              : controller.isLoading == true
                  ? 350.h
                  : 250.h,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorCodes.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  const Spacer(),
                  CustomContainer(
                    height: 40,
                    width: 40,
                    backgroundColor: ColorCodes.surface.withOpacity(0.2),
                    borderColor: Colors.transparent,
                    radius: 60,
                    containerChild: IconButton(
                      color: ColorCodes.surface.withOpacity(0.2),
                      splashColor: Colors.teal,
                      iconSize: 19,
                      constraints:
                          const BoxConstraints(maxHeight: 40, maxWidth: 40),
                      onPressed: () {
                        /// Clear All Variables
                        controller.correctionAiResponse = '';
                        controller.isRecording = false;
                       // controller.audioRecord.dispose();
                        controller.correctionAiResponse = '';
                        controller.fromSelectedLanguage = "English";
                        controller.toSelectedLanguage = "Hindi";
                        controller.isLoading = false;
                        controller.isRecording = false;
                        controller.isAiResponse = false;
                        controller.audioPath = '';

                        Get.back();
                      },
                      icon: Icon(
                        Icons.clear,
                        color: ColorCodes.primary,
                      ),
                    ),
                  ),
                ],
              ),
              GetBuilder<AddNoteController>(
                builder: (controller) {
                  return controller.isLoading == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: 50.h,
                            ),
                            const SizedBox(
                              child: SpinKitPouringHourGlassRefined(
                                color: ColorCodes.teal,
                                size: 60,
                                //  trackColor: ,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            const CustomText(
                              text: AppConstants.waiting,
                              fontWeight: FontWeight.bold,
                              fontFamily: montserratRegular,
                              fontSize: 14,
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            const CustomText(
                              text:
                                  "Longer audio, longer recognition. Please be patient.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              fontColor: ColorCodes.grey,
                              fontSize: 12,
                            ),
                          ],
                        )
                      : controller.correctionAiResponse.isEmpty
                          ? GetBuilder<AddNoteController>(
                              builder: (controller) {
                                return Column(
                                  children: [
                                    Center(
                                      child: GestureDetector(
                                        onTap: controller.isRecording
                                            ? controller.stopRecording
                                            : controller.startRecording,
                                        child: controller.isRecording
                                            ? Card(
                                                elevation: 5,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      ColorCodes.red,
                                                  radius: 36,
                                                  child: CustomIcon(
                                                    icon: Icons.stop,
                                                    color: ColorCodes.white,
                                                    size: 30,
                                                  ),
                                                ),
                                              )
                                            : RippleAnimation(
                                                color: ColorCodes.teal,
                                                delay: const Duration(
                                                    milliseconds: 300),
                                                repeat: true,
                                                minRadius: 30,
                                                ripplesCount:
                                                    controller.isLoading == true
                                                        ? 0
                                                        : 6,
                                                duration: const Duration(
                                                    milliseconds: 6 * 300),
                                                child: Card(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: const CircleAvatar(
                                                    backgroundColor:
                                                        ColorCodes.teal,
                                                    radius: 36,
                                                    child: CustomIcon(
                                                      icon: Icons.mic,
                                                      color: ColorCodes.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CustomText(
                                      text: controller.isRecording
                                          ? AppConstants.tapAndStop
                                          : AppConstants.tapAndSpeak,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: montserratRegular,
                                      fontSize: 14,
                                    ),
                                  ],
                                );
                              },
                            )
                          : Column(
                              children: [
                                CustomContainer(
                                  height: 300,
                                  width: double.infinity,
                                  borderColor: ColorCodes.grey.withOpacity(0.3),
                                  containerPadding: const EdgeInsets.only(
                                      top: 15, right: 15, bottom: 15, left: 15),
                                  containerChild: SingleChildScrollView(
                                    child: Text(
                                      controller.correctionAiResponse,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        /// copy to clip board message
                                        Clipboard.setData(
                                          ClipboardData(
                                            text:
                                                controller.correctionAiResponse,
                                          ),
                                        ).then(
                                          (_) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Copied to your clipboard !');
                                          },
                                        );
                                      },
                                      child: CustomContainer(
                                        width: 90,
                                        backgroundColor:
                                            ColorCodes.grey.withOpacity(0.2),
                                        containerChild: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Row(
                                            children: [
                                              CustomIcon(
                                                icon: Icons.copy,
                                                color: ColorCodes.primary,
                                                size: 14,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  AppConstants.copy,
                                                  style: TextStyle(
                                                    color: ColorCodes.primary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (homeController.messageLimit != 0) {
                                          controller.insertBelow(
                                              controller.correctionAiResponse);
                                        }
                                      },
                                      child: CustomContainer(
                                        width: 140,
                                        backgroundColor:
                                            ColorCodes.grey.withOpacity(0.2),
                                        containerChild: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Row(
                                            children: [
                                              CustomIcon(
                                                icon: CupertinoIcons
                                                    .arrow_up_left_square,
                                                color: ColorCodes.primary,
                                                size: 14,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  AppConstants.insertBelow,
                                                  style: TextStyle(
                                                    color: ColorCodes.primary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                },
              ),
            ],
          ),
        );
      },
    ),
    isDismissible: false,
    barrierColor: ColorCodes.primary.withOpacity(0.3),
  );
}
