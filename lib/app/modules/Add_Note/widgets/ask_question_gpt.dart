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
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/lists/lists.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_field_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';

class AskQuestionGpt extends StatelessWidget {
  const AskQuestionGpt({super.key});

  @override
  Widget build(BuildContext context) {
    final AddNoteController controller = Get.put(AddNoteController());

    final width = MediaQuery.of(context).size.width;
    return GetBuilder<AddNoteController>(
      builder: (controller) {
        return CustomContainer(
          width: double.infinity,
          height: controller.chatGptController.text.isNotEmpty
              ? 90
              : controller.aiResponseText == null
                  ? 300
                  : 400,
          containerChild: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: controller.isChatGptResponse == true
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            CustomContainer(
                              height: 40,
                              width: 40,
                              backgroundColor:
                                  ColorCodes.surface.withOpacity(0.2),
                              borderColor: Colors.transparent,
                              radius: 60,
                              containerChild: IconButton(
                                color: ColorCodes.surface.withOpacity(0.2),
                                splashColor: Colors.teal,
                                iconSize: 19,
                                constraints: const BoxConstraints(
                                    maxHeight: 40, maxWidth: 40),
                                onPressed: () {
                                  controller.isChatGptResponse = false;
                                  controller.aiResponseText = null;
                                  controller.isChatGpt = false;
                                  controller.update();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: ColorCodes.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          height: 18.h,
                        ),
                        const CustomText(
                          text: AppConstants.waiting,
                          fontWeight: FontWeight.bold,
                          fontFamily: montserratRegular,
                          fontSize: 14,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        const CustomText(
                          text: AppConstants.preparedResponse,
                          fontFamily: montserratRegular,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  )
                : controller.aiResponseText == null
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                CustomTextField(
                                  controller: controller.chatGptController,
                                  onChanged: (value) =>
                                      controller.onChangeValueGpt(value),
                                  minLines: 1,
                                  maxLines: 2,
                                  maxWidth: width * 0.78,
                                  minHeight: 40,
                                  hintText: AppConstants.askingChatGpt,
                                  fillColor: ColorCodes.greyLight,
                                  hintStyle: const TextStyle(
                                    fontSize: 14,
                                    color: ColorCodes.grey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  suffixIcon:
                                      controller.chatGptController.text.isEmpty
                                          ? const SizedBox()
                                          : GestureDetector(
                                              onTap: () {
                                                controller.chatGptController
                                                    .clear();

                                                controller.update();
                                              },
                                              child: CustomIcon(
                                                icon: Icons.cancel,
                                                color: ColorCodes.grey
                                                    .withOpacity(0.5),
                                                size: 23,
                                              ),
                                            ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                controller.chatGptController.text.isEmpty
                                    ? IconButton(
                                        color: ColorCodes.teal.withOpacity(0.2),
                                        onPressed: () {
                                          controller.isChatGpt = false;
                                          controller.update();
                                        },
                                        icon: const CustomIcon(
                                          icon: Icons.clear,
                                          color: ColorCodes.grey,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          controller.sendMsg(
                                            text: controller
                                                .chatGptController.text,
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: ColorCodes.teal,
                                          radius: 22,
                                          child: Center(
                                            child: Image.asset(
                                              messageSendIcon,
                                              color: ColorCodes.white,
                                              height: 26,
                                              width: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          controller.chatGptController.text.isEmpty
                              ? Divider(
                                  color: ColorCodes.grey.withOpacity(0.4),
                                  thickness: 1.5,
                                )
                              : const SizedBox(),
                          controller.chatGptController.text.isEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: askToChatGptQuestion.length,
                                    // padding: EdgeInsets.symmetric(horizontal: 10),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.chatGptController =
                                                  TextEditingController(
                                                      text:
                                                          askToChatGptQuestion[
                                                              index]);

                                              controller.update();
                                            },
                                            child: CustomContainer(
                                              width: double.infinity,
                                              containerChild: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 7),
                                                child: Text(
                                                  askToChatGptQuestion[index],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            color: ColorCodes.grey
                                                .withOpacity(0.2),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                CustomContainer(
                                  height: 40,
                                  width: 40,
                                  backgroundColor:
                                      ColorCodes.surface.withOpacity(0.2),
                                  borderColor: Colors.transparent,
                                  radius: 60,
                                  containerChild: IconButton(
                                    color: ColorCodes.surface.withOpacity(0.2),
                                    splashColor: Colors.teal,
                                    iconSize: 19,
                                    constraints: const BoxConstraints(
                                        maxHeight: 40, maxWidth: 40),
                                    onPressed: () {
                                      controller.isChatGptResponse = false;
                                      controller.aiResponseText = null;
                                      controller.isChatGpt = false;
                                      controller.update();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: ColorCodes.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomContainer(
                                height: 300.h,
                                width: double.infinity,
                                borderColor: ColorCodes.teal,
                                containerChild: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Text(controller.aiResponseText),
                                  ),
                                )),
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
                                        text: controller.aiResponseText,
                                      ),
                                    ).then(
                                      (_) {
                                        Fluttertoast.showToast(
                                            msg: 'Copied to your clipboard !');
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
                                          controller.aiResponseText);
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
                        ),
                      ),
          ),
        );
      },
    );
  }
}
