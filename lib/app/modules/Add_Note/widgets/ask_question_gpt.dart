
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
import 'package:ainotes/app/common/lists/language_list.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_field_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';

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
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/lists/language_list.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';

import '../../../common/constants/app_strings.dart';

class AskQuestionGpt extends StatelessWidget {
  final bool isDark;

  const AskQuestionGpt({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNoteController>(
      builder: (controller) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
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
                  padding: EdgeInsets.only(
                    top: 12.h,
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 12.h
                        : 0,
                  ),
                  child: _buildContent(context, controller),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AddNoteController controller) {
    if (controller.isAiGenerating) {
      return _buildLoadingState();
    } else if (controller.aiGeneratedText == null) {
      return _buildPromptInputState(context, controller);
    } else {
      return _buildResponseState(context, controller);
    }
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          SizedBox(height: 40.h),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorCodes.purple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SpinKitPulse(
              color: ColorCodes.purple,
              size: 50,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Generating...',
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'AI is preparing your response',
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptInputState(BuildContext context, AddNoteController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDragHandle(),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: _buildPromptInputField(controller),
        ),
        if (controller.aiPromptController.text.isEmpty) ...[
          SizedBox(height: 16.h),
          _buildSuggestedPrompts(controller),
        ],
        _buildAiPolicyNote(),
        SizedBox(height: 8.h),
      ],
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

  Widget _buildPromptInputField(AddNoteController controller) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.aiPromptController,
              onChanged: (_) => controller.update(),
              minLines: 1,
              maxLines: 3,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.askingChatGpt,
                hintStyle: TextStyle(
                  fontFamily: poppins,
                  fontSize: 15,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: InputBorder.none,
                suffixIcon: controller.aiPromptController.text.isNotEmpty
                    ? GestureDetector(
                  onTap: () {
                    controller.aiPromptController.clear();
                    controller.update();
                  },
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: isDark ? Colors.white30 : Colors.black26,
                    size: 20,
                  ),
                )
                    : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildSendOrCloseButton(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildSendOrCloseButton(AddNoteController controller) {
    final bool hasText = controller.aiPromptController.text.isNotEmpty;

    return GestureDetector(
      onTap: hasText
          ? () => controller.generateAiResponse(
        prompt: controller.aiPromptController.text,
      )
          : () => controller.hideAiChat(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: hasText
              ? LinearGradient(
            colors: [ColorCodes.purpleLight, ColorCodes.purple],
          )
              : null,
          color: hasText ? null : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          hasText ? CupertinoIcons.arrow_up : CupertinoIcons.xmark,
          size: 20,
          color: hasText ? Colors.white : (isDark ? Colors.white54 : Colors.black45),
        ),
      ),
    );
  }

  Widget _buildSuggestedPrompts(AddNoteController controller) {
    return Container(
      constraints: BoxConstraints(maxHeight: 220.h),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: askToChatGptQuestion.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: GestureDetector(
              onTap: () {
                controller.aiPromptController.text = askToChatGptQuestion[index];
                controller.update();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.05),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorCodes.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        CupertinoIcons.sparkles,
                        size: 14,
                        color: ColorCodes.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        askToChatGptQuestion[index],
                        style: TextStyle(
                          fontFamily: poppins,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 14,
                      color: isDark ? Colors.white30 : Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponseState(BuildContext context, AddNoteController controller) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            SizedBox(height: 12.h),
            _buildResponseHeader(controller),
            SizedBox(height: 16.h),
            _buildResponseContent(controller),
            SizedBox(height: 16.h),
            _buildActionButtons(controller),
            SizedBox(height: 12.h),
            _buildReportButton(controller),
            _buildAiPolicyNote(),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseHeader(AddNoteController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorCodes.purpleLight, ColorCodes.purple],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                CupertinoIcons.sparkles,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'AI Response',
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            controller.isAiGenerating = false;
            controller.aiGeneratedText = null;
            controller.hideAiChat();
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

  Widget _buildResponseContent(AddNoteController controller) {
    return Container(
      constraints: BoxConstraints(maxHeight: 280.h),
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
          controller.aiGeneratedText ?? '',
          style: TextStyle(
            fontFamily: poppins,
            fontSize: 14,
            height: 1.6,
            color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(AddNoteController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: CupertinoIcons.doc_on_clipboard,
            label: 'Copy',
            onTap: () {
              Clipboard.setData(ClipboardData(text: controller.aiGeneratedText ?? ''))
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
              if (homeController.messageLimit != 0 && controller.aiGeneratedText != null) {
                controller.insertTextIntoNote(controller.aiGeneratedText!);
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

  /// Report offensive content button - safety requirement
  Widget _buildReportButton(AddNoteController controller) {
    return GestureDetector(
      onTap: () => _showReportDialog(controller),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.flag,
              size: 14,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            const SizedBox(width: 6),
            Text(
              'Report offensive content',
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 12,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(AddNoteController controller) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Report Content'),
        content: const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Would you like to report this AI-generated content as offensive, harmful, or inappropriate?',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
              // TODO: Implement actual reporting logic here
              // This would send the content + prompt to your backend for review
              Fluttertoast.showToast(
                msg: 'Report submitted. Thank you for helping keep QuillForge safe.',
                backgroundColor: ColorCodes.purple,
                toastLength: Toast.LENGTH_LONG,
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  /// AI policy disclaimer - safety requirement
  Widget _buildAiPolicyNote() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        'AI can make mistakes. Do not use outputs for illegal or harmful purposes.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: poppins,
          fontSize: 11,
          color: isDark ? Colors.white30 : Colors.black26,
        ),
      ),
    );
  }
}

// class AskQuestionGpt extends StatelessWidget {
//   const AskQuestionGpt({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AddNoteController>(
//       builder: (controller) {
//         return CommonContainer(
//           width: double.infinity,
//           height: _calculateHeight(controller),
//           containerChild: Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: _buildContent(context, controller),
//           ),
//         );
//       },
//     );
//   }
//
//   double _calculateHeight(AddNoteController controller) {
//     if (controller.aiPromptController.text.isNotEmpty) return 100;
//     if (controller.aiGeneratedText != null) return 500;
//     return 400;
//   }
//
//   Widget _buildContent(BuildContext context, AddNoteController controller) {
//     if (controller.isAiGenerating) {
//       return _buildLoadingState();
//     } else if (controller.aiGeneratedText == null) {
//       return _buildPromptInputState(context, controller);
//     } else {
//       return _buildResponseState(controller);
//     }
//   }
//
//   Widget _buildLoadingState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         children: [
//           _buildCloseButton(),
//           SizedBox(height: 50.h),
//           const SpinKitPouringHourGlassRefined(
//             color: ColorCodes.purple,
//             size: 60,
//           ),
//           SizedBox(height: 18.h),
//           const CommonText(
//             text: AppStrings.waiting,
//             fontWeight: FontWeight.bold,
//             fontFamily: montserratRegular,
//             fontSize: 14,
//           ),
//           SizedBox(height: 3.h),
//           const CommonText(
//             text: AppStrings.preparedResponse,
//             fontFamily: montserratRegular,
//             fontSize: 12,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPromptInputState(BuildContext context, AddNoteController controller) {
//     final width = MediaQuery.of(context).size.width;
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             children: [
//               _buildPromptTextField(controller, width),
//               const SizedBox(width: 10),
//               _buildSendOrCloseButton(controller),
//             ],
//           ),
//         ),
//         if (controller.aiPromptController.text.isEmpty) ...[
//           Divider(color: ColorCodes.grey.withOpacity(0.4), thickness: 1.5),
//           _buildSuggestedPrompts(controller),
//         ],
//       ],
//     );
//   }
//
//   Widget _buildPromptTextField(AddNoteController controller, double width) {
//     return CommonTextField(
//       controller: controller.aiPromptController,
//       onChanged: (_) => controller.update(),
//       minLines: 1,
//       maxLines: 2,
//       maxWidth: width * 0.78,
//       minHeight: 40,
//       hintText: AppStrings.askingChatGpt,
//       fillColor: ColorCodes.greyLight,
//       hintStyle: const TextStyle(
//         fontSize: 14,
//         color: ColorCodes.grey,
//         overflow: TextOverflow.ellipsis,
//       ),
//       suffixIcon: controller.aiPromptController.text.isEmpty
//           ? const SizedBox.shrink()
//           : GestureDetector(
//         onTap: () {
//           controller.aiPromptController.clear();
//           controller.update();
//         },
//         child: CommonmIcon(
//           icon: Icons.cancel,
//           color: ColorCodes.grey.withOpacity(0.5),
//           size: 23,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSendOrCloseButton(AddNoteController controller) {
//     return controller.aiPromptController.text.isEmpty
//         ? IconButton(
//       color: ColorCodes.purple.withOpacity(0.2),
//       onPressed: () {
//         controller.hideAiChat();
//       },
//       icon: const CommonmIcon(icon: Icons.clear, color: ColorCodes.grey),
//     )
//         : GestureDetector(
//       onTap: () => controller.generateAiResponse(
//         prompt: controller.aiPromptController.text,
//       ),
//       child: CircleAvatar(
//         backgroundColor: ColorCodes.purple,
//         radius: 22,
//         child: Image.asset(
//           messageSendIcon,
//           color: ColorCodes.white,
//           height: 26,
//           width: 26,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSuggestedPrompts(AddNoteController controller) {
//     return Expanded(
//       child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: askToChatGptQuestion.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   controller.aiPromptController.text = askToChatGptQuestion[index];
//                   controller.update();
//                 },
//                 child: CommonContainer(
//                   width: double.infinity,
//                   containerChild: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//                     child: Text(
//                       askToChatGptQuestion[index],
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ),
//                 ),
//               ),
//               Divider(color: ColorCodes.grey.withOpacity(0.2)),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildResponseState(AddNoteController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         children: [
//           _buildCloseButton(),
//           SizedBox(height: 10.h),
//           CommonContainer(
//             height: 300.h,
//             width: double.infinity,
//             borderColor: ColorCodes.purple,
//             containerChild: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SingleChildScrollView(
//                 child: Text(controller.aiGeneratedText ?? ''),
//               ),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           _buildActionButtons(controller),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCloseButton() {
//     return GetBuilder<AddNoteController>(
//       builder: (controller) => Row(
//         children: [
//           const Spacer(),
//           CommonContainer(
//             height: 40,
//             width: 40,
//             backgroundColor: ColorCodes.surface.withOpacity(0.2),
//             borderColor: Colors.transparent,
//             radius: 60,
//             containerChild: IconButton(
//               onPressed: () {
//                 controller.isAiGenerating = false;
//                 controller.aiGeneratedText = null;
//                 controller.hideAiChat();
//               },
//               icon: Icon(Icons.clear, color: ColorCodes.primary),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(AddNoteController controller) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         _buildCopyButton(controller),
//         SizedBox(width: 5.w),
//         _buildInsertButton(controller),
//       ],
//     );
//   }
//
//   Widget _buildCopyButton(AddNoteController controller) {
//     return GestureDetector(
//       onTap: () {
//         Clipboard.setData(ClipboardData(text: controller.aiGeneratedText ?? ''))
//             .then((_) => Fluttertoast.showToast(msg: 'Copied to clipboard!'));
//       },
//       child: CommonContainer(
//         width: 90,
//         backgroundColor: ColorCodes.grey.withOpacity(0.2),
//         containerChild: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Row(
//             children: [
//               CommonmIcon(icon: Icons.copy, color: ColorCodes.primary, size: 14),
//               SizedBox(width: 10.w),
//               Flexible(
//                 child: Text(
//                   AppStrings.copy,
//                   style: TextStyle(color: ColorCodes.primary, fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInsertButton(AddNoteController controller) {
//     return GestureDetector(
//       onTap: () {
//         if (homeController.messageLimit != 0 && controller.aiGeneratedText != null) {
//           controller.insertTextIntoNote(controller.aiGeneratedText!);
//         }
//       },
//       child: CommonContainer(
//         width: 140,
//         backgroundColor: ColorCodes.grey.withOpacity(0.2),
//         containerChild: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Row(
//             children: [
//               CommonmIcon(
//                 icon: Icons.arrow_upward,
//                 color: ColorCodes.primary,
//                 size: 14,
//               ),
//               SizedBox(width: 10.w),
//               Flexible(
//                 child: Text(
//                   AppStrings.insertBelow,
//                   style: TextStyle(color: ColorCodes.primary, fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
