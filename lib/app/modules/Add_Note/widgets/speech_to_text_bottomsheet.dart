
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

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../../common/constants/app_strings.dart';

void showVoiceToTextBottomSheet() {
  final isDark = Get.isDarkMode;

  Get.bottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    GetBuilder<AddNoteController>(
      builder: (controller) => _VoiceToTextSheet(
        controller: controller,
        isDark: isDark,
      ),
    ),
  );
}

class _VoiceToTextSheet extends StatelessWidget {
  final AddNoteController controller;
  final bool isDark;

  const _VoiceToTextSheet({
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF2C2C2E).withOpacity(0.95)
                : Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDragHandle(),
                  SizedBox(height: 8.h),
                  _buildHeader(),
                  SizedBox(height: 16.h),
                  _buildContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? Colors.white24 : Colors.black12,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorCodes.purpleLight, ColorCodes.purple],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.mic_fill,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Voice to Text',
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            controller.clearAudioData();
            Get.back();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.xmark,
              size: 16,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (controller.isProcessingAudio) {
      return _buildLoadingState();
    } else if (controller.transcribedText.isEmpty) {
      return _buildRecordingState();
    } else {
      return _buildTranscriptionResult();
    }
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorCodes.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SpinKitWave(
              color: ColorCodes.purple,
              size: 40,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Processing audio...',
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'Longer audio requires more time. Please be patient.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: controller.isRecordingAudio
                ? controller.stopAudioRecording
                : controller.startAudioRecording,
            child: controller.isRecordingAudio
                ? _buildStopButton()
                : _buildRecordButton(),
          ),
          SizedBox(height: 20.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              controller.isRecordingAudio
                  ? 'Tap to stop recording'
                  : 'Tap to start recording',
              key: ValueKey(controller.isRecordingAudio),
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.isRecordingAudio
                ? 'Recording in progress...'
                : 'Speak clearly for best results',
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 13,
              color: isDark ? Colors.white38 : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopButton() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordButton() {
    return RippleAnimation(
      color: ColorCodes.purple,
      delay: const Duration(milliseconds: 300),
      repeat: true,
      minRadius: 40,
      ripplesCount: 3,
      duration: const Duration(milliseconds: 2000),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorCodes.purpleLight, ColorCodes.purple],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ColorCodes.purple.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          CupertinoIcons.mic_fill,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTranscriptionResult() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: 280.h,
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorCodes.purple.withOpacity(0.2),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Text(
              controller.transcribedText,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 14,
                height: 1.6,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: CupertinoIcons.doc_on_clipboard,
            label: 'Copy',
            onTap: () {
              Clipboard.setData(ClipboardData(text: controller.transcribedText))
                  .then((_) => Fluttertoast.showToast(
                msg: 'Copied to clipboard',
                backgroundColor: ColorCodes.purple,
              ));
            },
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 2,
          child: _buildPrimaryActionButton(
            icon: CupertinoIcons.arrow_down_doc,
            label: 'Insert into Note',
            onTap: () {
              if (homeController.messageLimit != 0) {
                controller.insertTextIntoNote(controller.transcribedText);
                Get.back();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorCodes.purpleLight, ColorCodes.purple],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: ColorCodes.purple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// void showVoiceToTextBottomSheet() {
//   Get.bottomSheet(
//     isScrollControlled: true,
//     isDismissible: false,
//     barrierColor: ColorCodes.primary.withOpacity(0.3),
//     GetBuilder<AddNoteController>(
//       builder: (controller) => Container(
//         width: double.infinity,
//         height: _calculateHeight(controller),
//         padding: const EdgeInsets.all(16),
//         decoration:  BoxDecoration(
//           color: ColorCodes.surface,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildCloseButton(controller),
//             _buildContent(controller),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// double _calculateHeight(AddNoteController controller) {
//   if (controller.transcribedText.isNotEmpty) return 550.h;
//   if (controller.isProcessingAudio) return 350.h;
//   return 250.h;
// }
//
// Widget _buildCloseButton(AddNoteController controller) {
//   return Row(
//     children: [
//       const Spacer(),
//       CommonContainer(
//         height: 40,
//         width: 40,
//         backgroundColor: ColorCodes.surface.withOpacity(0.2),
//         borderColor: Colors.transparent,
//         radius: 60,
//         containerChild: IconButton(
//           onPressed: () {
//             controller.clearAudioData();
//             Get.back();
//           },
//           icon: Icon(Icons.clear, color: ColorCodes.primary),
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _buildContent(AddNoteController controller) {
//   if (controller.isProcessingAudio) {
//     return _buildLoadingState();
//   } else if (controller.transcribedText.isEmpty) {
//     return _buildRecordingState(controller);
//   } else {
//     return _buildTranscriptionResult(controller);
//   }
// }
//
// Widget _buildLoadingState() {
//   return Column(
//     children: [
//       SizedBox(height: 50.h),
//       const SpinKitPouringHourGlassRefined(color: ColorCodes.purple, size: 60),
//       SizedBox(height: 20.h),
//       const CommonText(
//         text: AppStrings.waiting,
//         fontWeight: FontWeight.bold,
//         fontFamily: montserratRegular,
//         fontSize: 14,
//       ),
//       SizedBox(height: 8.h),
//       const CommonText(
//         text: "Longer audio, longer recognition. Please be patient.",
//         maxLines: 2,
//         overflow: TextOverflow.ellipsis,
//         fontColor: ColorCodes.grey,
//         fontSize: 12,
//       ),
//     ],
//   );
// }
//
// Widget _buildRecordingState(AddNoteController controller) {
//   return Column(
//     children: [
//       Center(
//         child: GestureDetector(
//           onTap: controller.isRecordingAudio
//               ? controller.stopAudioRecording
//               : controller.startAudioRecording,
//           child: controller.isRecordingAudio
//               ? _buildStopButton()
//               : _buildRecordButton(controller),
//         ),
//       ),
//       const SizedBox(height: 15),
//       CommonText(
//         text: controller.isRecordingAudio
//             ? AppStrings.tapAndStop
//             : AppStrings.tapAndSpeak,
//         fontWeight: FontWeight.bold,
//         fontFamily: montserratRegular,
//         fontSize: 14,
//       ),
//     ],
//   );
// }
//
// Widget _buildStopButton() {
//   return Card(
//     elevation: 5,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//     child: const CircleAvatar(
//       backgroundColor: ColorCodes.red,
//       radius: 36,
//       child: CommonmIcon(icon: Icons.stop, color: ColorCodes.white, size: 30),
//     ),
//   );
// }
//
// Widget _buildRecordButton(AddNoteController controller) {
//   return RippleAnimation(
//     color: ColorCodes.purple,
//     delay: const Duration(milliseconds: 300),
//     repeat: true,
//     minRadius: 30,
//     ripplesCount: controller.isProcessingAudio ? 0 : 6,
//     duration: const Duration(milliseconds: 1800),
//     child: Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//       child: const CircleAvatar(
//         backgroundColor: ColorCodes.purple,
//         radius: 36,
//         child: CommonmIcon(icon: Icons.mic, color: ColorCodes.white),
//       ),
//     ),
//   );
// }
//
// Widget _buildTranscriptionResult(AddNoteController controller) {
//   return Column(
//     children: [
//       CommonContainer(
//         height: 300,
//         width: double.infinity,
//         borderColor: ColorCodes.grey.withOpacity(0.3),
//         containerPadding: const EdgeInsets.all(15),
//         containerChild: SingleChildScrollView(
//           child: Text(
//             controller.transcribedText,
//             style: const TextStyle(fontSize: 14),
//           ),
//         ),
//       ),
//       SizedBox(height: 8.h),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           _buildCopyButton(controller),
//           SizedBox(width: 5.w),
//           _buildInsertButton(controller),
//         ],
//       ),
//     ],
//   );
// }
//
// Widget _buildCopyButton(AddNoteController controller) {
//   return GestureDetector(
//     onTap: () {
//       Clipboard.setData(ClipboardData(text: controller.transcribedText))
//           .then((_) => Fluttertoast.showToast(msg: 'Copied to clipboard!'));
//     },
//     child: CommonContainer(
//       width: 90,
//       backgroundColor: ColorCodes.grey.withOpacity(0.2),
//       containerChild: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: Row(
//           children: [
//              CommonmIcon(icon: Icons.copy, color: ColorCodes.primary, size: 14),
//             SizedBox(width: 10.w),
//              Flexible(
//               child: Text(
//                 AppStrings.copy,
//                 style: TextStyle(color: ColorCodes.primary, fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _buildInsertButton(AddNoteController controller) {
//   return GestureDetector(
//     onTap: () {
//       if (homeController.messageLimit != 0) {
//         controller.insertTextIntoNote(controller.transcribedText);
//       }
//     },
//     child: CommonContainer(
//       width: 140,
//       backgroundColor: ColorCodes.grey.withOpacity(0.2),
//       containerChild: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: Row(
//           children: [
//              CommonmIcon(
//               icon: Icons.arrow_upward,
//               color: ColorCodes.primary,
//               size: 14,
//             ),
//             SizedBox(width: 10.w),
//              Flexible(
//               child: Text(
//                 AppStrings.insertBelow,
//                 style: TextStyle(color: ColorCodes.primary, fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
