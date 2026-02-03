
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
    return GetBuilder<AddNoteController>(
      builder: (controller) {
        return CustomContainer(
          width: double.infinity,
          height: _calculateHeight(controller),
          containerChild: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: _buildContent(context, controller),
          ),
        );
      },
    );
  }

  double _calculateHeight(AddNoteController controller) {
    if (controller.aiPromptController.text.isNotEmpty) return 100;
    if (controller.aiGeneratedText != null) return 500;
    return 400;
  }

  Widget _buildContent(BuildContext context, AddNoteController controller) {
    if (controller.isAiGenerating) {
      return _buildLoadingState();
    } else if (controller.aiGeneratedText == null) {
      return _buildPromptInputState(context, controller);
    } else {
      return _buildResponseState(controller);
    }
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          _buildCloseButton(),
          SizedBox(height: 50.h),
          const SpinKitPouringHourGlassRefined(
            color: ColorCodes.teal,
            size: 60,
          ),
          SizedBox(height: 18.h),
          const CustomText(
            text: AppConstants.waiting,
            fontWeight: FontWeight.bold,
            fontFamily: montserratRegular,
            fontSize: 14,
          ),
          SizedBox(height: 3.h),
          const CustomText(
            text: AppConstants.preparedResponse,
            fontFamily: montserratRegular,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildPromptInputState(BuildContext context, AddNoteController controller) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              _buildPromptTextField(controller, width),
              const SizedBox(width: 10),
              _buildSendOrCloseButton(controller),
            ],
          ),
        ),
        if (controller.aiPromptController.text.isEmpty) ...[
          Divider(color: ColorCodes.grey.withOpacity(0.4), thickness: 1.5),
          _buildSuggestedPrompts(controller),
        ],
      ],
    );
  }

  Widget _buildPromptTextField(AddNoteController controller, double width) {
    return CustomTextField(
      controller: controller.aiPromptController,
      onChanged: (_) => controller.update(),
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
      suffixIcon: controller.aiPromptController.text.isEmpty
          ? const SizedBox.shrink()
          : GestureDetector(
        onTap: () {
          controller.aiPromptController.clear();
          controller.update();
        },
        child: CustomIcon(
          icon: Icons.cancel,
          color: ColorCodes.grey.withOpacity(0.5),
          size: 23,
        ),
      ),
    );
  }

  Widget _buildSendOrCloseButton(AddNoteController controller) {
    return controller.aiPromptController.text.isEmpty
        ? IconButton(
      color: ColorCodes.teal.withOpacity(0.2),
      onPressed: () {
        controller.hideAiChat();
      },
      icon: const CustomIcon(icon: Icons.clear, color: ColorCodes.grey),
    )
        : GestureDetector(
      onTap: () => controller.generateAiResponse(
        prompt: controller.aiPromptController.text,
      ),
      child: CircleAvatar(
        backgroundColor: ColorCodes.teal,
        radius: 22,
        child: Image.asset(
          messageSendIcon,
          color: ColorCodes.white,
          height: 26,
          width: 26,
        ),
      ),
    );
  }

  Widget _buildSuggestedPrompts(AddNoteController controller) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: askToChatGptQuestion.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  controller.aiPromptController.text = askToChatGptQuestion[index];
                  controller.update();
                },
                child: CustomContainer(
                  width: double.infinity,
                  containerChild: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Text(
                      askToChatGptQuestion[index],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              Divider(color: ColorCodes.grey.withOpacity(0.2)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResponseState(AddNoteController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          _buildCloseButton(),
          SizedBox(height: 10.h),
          CustomContainer(
            height: 300.h,
            width: double.infinity,
            borderColor: ColorCodes.teal,
            containerChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Text(controller.aiGeneratedText ?? ''),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _buildActionButtons(controller),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return GetBuilder<AddNoteController>(
      builder: (controller) => Row(
        children: [
          const Spacer(),
          CustomContainer(
            height: 40,
            width: 40,
            backgroundColor: ColorCodes.surface.withOpacity(0.2),
            borderColor: Colors.transparent,
            radius: 60,
            containerChild: IconButton(
              onPressed: () {
                controller.isAiGenerating = false;
                controller.aiGeneratedText = null;
                controller.hideAiChat();
              },
              icon: Icon(Icons.clear, color: ColorCodes.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AddNoteController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildCopyButton(controller),
        SizedBox(width: 5.w),
        _buildInsertButton(controller),
      ],
    );
  }

  Widget _buildCopyButton(AddNoteController controller) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: controller.aiGeneratedText ?? ''))
            .then((_) => Fluttertoast.showToast(msg: 'Copied to clipboard!'));
      },
      child: CustomContainer(
        width: 90,
        backgroundColor: ColorCodes.grey.withOpacity(0.2),
        containerChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              CustomIcon(icon: Icons.copy, color: ColorCodes.primary, size: 14),
              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  AppConstants.copy,
                  style: TextStyle(color: ColorCodes.primary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsertButton(AddNoteController controller) {
    return GestureDetector(
      onTap: () {
        if (homeController.messageLimit != 0 && controller.aiGeneratedText != null) {
          controller.insertTextIntoNote(controller.aiGeneratedText!);
        }
      },
      child: CustomContainer(
        width: 140,
        backgroundColor: ColorCodes.grey.withOpacity(0.2),
        containerChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              CustomIcon(
                icon: Icons.arrow_upward,
                color: ColorCodes.primary,
                size: 14,
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Text(
                  AppConstants.insertBelow,
                  style: TextStyle(color: ColorCodes.primary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
