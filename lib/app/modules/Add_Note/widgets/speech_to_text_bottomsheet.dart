
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

import '../../../common/constants/app_strings.dart';

void showVoiceToTextBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    barrierColor: ColorCodes.primary.withOpacity(0.3),
    GetBuilder<AddNoteController>(
      builder: (controller) => Container(
        width: double.infinity,
        height: _calculateHeight(controller),
        padding: const EdgeInsets.all(16),
        decoration:  BoxDecoration(
          color: ColorCodes.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCloseButton(controller),
            _buildContent(controller),
          ],
        ),
      ),
    ),
  );
}

double _calculateHeight(AddNoteController controller) {
  if (controller.transcribedText.isNotEmpty) return 550.h;
  if (controller.isProcessingAudio) return 350.h;
  return 250.h;
}

Widget _buildCloseButton(AddNoteController controller) {
  return Row(
    children: [
      const Spacer(),
      CommonContainer(
        height: 40,
        width: 40,
        backgroundColor: ColorCodes.surface.withOpacity(0.2),
        borderColor: Colors.transparent,
        radius: 60,
        containerChild: IconButton(
          onPressed: () {
            controller.clearAudioData();
            Get.back();
          },
          icon: Icon(Icons.clear, color: ColorCodes.primary),
        ),
      ),
    ],
  );
}

Widget _buildContent(AddNoteController controller) {
  if (controller.isProcessingAudio) {
    return _buildLoadingState();
  } else if (controller.transcribedText.isEmpty) {
    return _buildRecordingState(controller);
  } else {
    return _buildTranscriptionResult(controller);
  }
}

Widget _buildLoadingState() {
  return Column(
    children: [
      SizedBox(height: 50.h),
      const SpinKitPouringHourGlassRefined(color: ColorCodes.purple, size: 60),
      SizedBox(height: 20.h),
      const CommonText(
        text: AppStrings.waiting,
        fontWeight: FontWeight.bold,
        fontFamily: montserratRegular,
        fontSize: 14,
      ),
      SizedBox(height: 8.h),
      const CommonText(
        text: "Longer audio, longer recognition. Please be patient.",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        fontColor: ColorCodes.grey,
        fontSize: 12,
      ),
    ],
  );
}

Widget _buildRecordingState(AddNoteController controller) {
  return Column(
    children: [
      Center(
        child: GestureDetector(
          onTap: controller.isRecordingAudio
              ? controller.stopAudioRecording
              : controller.startAudioRecording,
          child: controller.isRecordingAudio
              ? _buildStopButton()
              : _buildRecordButton(controller),
        ),
      ),
      const SizedBox(height: 15),
      CommonText(
        text: controller.isRecordingAudio
            ? AppStrings.tapAndStop
            : AppStrings.tapAndSpeak,
        fontWeight: FontWeight.bold,
        fontFamily: montserratRegular,
        fontSize: 14,
      ),
    ],
  );
}

Widget _buildStopButton() {
  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    child: const CircleAvatar(
      backgroundColor: ColorCodes.red,
      radius: 36,
      child: CommonmIcon(icon: Icons.stop, color: ColorCodes.white, size: 30),
    ),
  );
}

Widget _buildRecordButton(AddNoteController controller) {
  return RippleAnimation(
    color: ColorCodes.purple,
    delay: const Duration(milliseconds: 300),
    repeat: true,
    minRadius: 30,
    ripplesCount: controller.isProcessingAudio ? 0 : 6,
    duration: const Duration(milliseconds: 1800),
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: const CircleAvatar(
        backgroundColor: ColorCodes.purple,
        radius: 36,
        child: CommonmIcon(icon: Icons.mic, color: ColorCodes.white),
      ),
    ),
  );
}

Widget _buildTranscriptionResult(AddNoteController controller) {
  return Column(
    children: [
      CommonContainer(
        height: 300,
        width: double.infinity,
        borderColor: ColorCodes.grey.withOpacity(0.3),
        containerPadding: const EdgeInsets.all(15),
        containerChild: SingleChildScrollView(
          child: Text(
            controller.transcribedText,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
      SizedBox(height: 8.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCopyButton(controller),
          SizedBox(width: 5.w),
          _buildInsertButton(controller),
        ],
      ),
    ],
  );
}

Widget _buildCopyButton(AddNoteController controller) {
  return GestureDetector(
    onTap: () {
      Clipboard.setData(ClipboardData(text: controller.transcribedText))
          .then((_) => Fluttertoast.showToast(msg: 'Copied to clipboard!'));
    },
    child: CommonContainer(
      width: 90,
      backgroundColor: ColorCodes.grey.withOpacity(0.2),
      containerChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
             CommonmIcon(icon: Icons.copy, color: ColorCodes.primary, size: 14),
            SizedBox(width: 10.w),
             Flexible(
              child: Text(
                AppStrings.copy,
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
      if (homeController.messageLimit != 0) {
        controller.insertTextIntoNote(controller.transcribedText);
      }
    },
    child: CommonContainer(
      width: 140,
      backgroundColor: ColorCodes.grey.withOpacity(0.2),
      containerChild: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
             CommonmIcon(
              icon: Icons.arrow_upward,
              color: ColorCodes.primary,
              size: 14,
            ),
            SizedBox(width: 10.w),
             Flexible(
              child: Text(
                AppStrings.insertBelow,
                style: TextStyle(color: ColorCodes.primary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
