import 'dart:ui';

import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';
import 'package:ainotes/app/modules/Add_Note/widgets/ask_question_gpt.dart';
import 'package:ainotes/app/modules/Add_Note/widgets/scan_to_text_bottomsheet.dart';
import 'package:ainotes/app/modules/Add_Note/widgets/speech_to_text_bottomsheet.dart';

class AddNoteView extends GetView<AddNoteController> {
  const AddNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FloatingDraggableWidget(
      autoAlign: true,
      floatingWidget: _buildAiFloatingButton(isDark),
      floatingWidgetHeight: 52,
      floatingWidgetWidth: 52,
      dx: 0,
      dy: 300,
      mainScreenWidget: _buildMainScaffold(context, isDark),
    );
  }

  Widget _buildAiFloatingButton(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorCodes.purpleLight,
            ColorCodes.purple,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ColorCodes.purple.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        elevation: 0,
        shape: const CircleBorder(),
        backgroundColor: Colors.transparent,
        onPressed: controller.showAiChat,
        child: Image.asset(
          openAiLogo,
          height: 24,
          width: 24,
          color: ColorCodes.white,
        ),
      ),
    );
  }

  Widget _buildMainScaffold(BuildContext context, bool isDark) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
      isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      body: GetBuilder<AddNoteController>(
        builder: (_) => Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildiOSNavigationBar(context, isDark),
                  _buildNoteContentField(context, isDark),
                  _buildBottomActionBar(context, isDark),
                ],
              ),
            ),
            if (controller.isAiChatVisible) _buildAiChatOverlay(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildiOSNavigationBar(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      ),
      child: Row(
        children: [
          _buildCloseButton(context, isDark),
          SizedBox(width: 12.w),
          Expanded(child: _buildTitleField(context, isDark)),
          SizedBox(width: 12.w),
          _buildSaveButton(isDark),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _handleBackPress(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          CupertinoIcons.xmark,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  void _handleBackPress() {
    if (controller.contentFocusNode.hasFocus ||
        controller.titleFocusNode.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(const Duration(milliseconds: 200), () => Get.back());
    } else {
      Get.back();
    }
  }

  Widget _buildTitleField(BuildContext context, bool isDark) {
    return GetBuilder<AddNoteController>(
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          onTap: () => controller.hideAiChat(),
          onChanged: (_) => controller.update(),
          controller: controller.titleTextController,
          focusNode: controller.titleFocusNode,
          maxLines: 1,
          style: TextStyle(
            fontFamily: poppins,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Title...',
            hintStyle: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    return GetBuilder<AddNoteController>(
      builder: (_) {
        final bool hasContent =
            controller.titleTextController.text.isNotEmpty ||
                controller.contentTextController.text.isNotEmpty;

        return AnimatedOpacity(
          opacity: hasContent ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: hasContent
                ? () {
              controller.saveOrUpdateNote();
              Get.back();
            }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorCodes.purpleLight, ColorCodes.purple],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: poppins,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteContentField(BuildContext context, bool isDark) {
    return GetBuilder<AddNoteController>(
      builder: (_) => Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDark
                ? null
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TextField(
              onTap: controller.hideAiChat,
              controller: controller.contentTextController,
              focusNode: controller.contentFocusNode,
              cursorColor: ColorCodes.purple,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 15,
                height: 1.6,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Enter or paste text here...',
                hintStyle: TextStyle(
                  fontFamily: poppins,
                  fontSize: 15,
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
                contentPadding: const EdgeInsets.all(20),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, bool isDark) {
    return GetBuilder<AddNoteController>(
      builder: (_) {
        final bool isTyping = controller.contentFocusNode.hasFocus ||
            controller.titleFocusNode.hasFocus;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? null
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: CupertinoIcons.keyboard,
                  label: 'Type',
                  onPressed: controller.focusContentField,
                  isDark: isDark,
                  isAccent: isTyping, // Highlight when typing
                ),
                _buildVerticalDivider(isDark),
                _buildActionButton(
                  icon: CupertinoIcons.mic_fill,
                  label: 'Voice',
                  onPressed: () => _openVoiceBottomSheet(),
                  isDark: isDark,
                  isAccent: false, // No persistent highlight
                ),
                _buildVerticalDivider(isDark),
                _buildActionButton(
                  icon: CupertinoIcons.doc_text_viewfinder,
                  label: 'Scan',
                  onPressed: () => _openScanBottomSheet(),
                  isDark: isDark,
                  isAccent: false, // No persistent highlight
                ),
                if (isTyping) ...[
                  _buildVerticalDivider(isDark),
                  _buildActionButton(
                    icon: CupertinoIcons.chevron_down,
                    label: 'Done',
                    onPressed: controller.unfocusAllFields,
                    isDark: isDark,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      height: 32,
      width: 1,
      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.08),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isDark,
    bool isAccent = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isAccent
                    ? ColorCodes.purple.withOpacity(0.15)
                    : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey.withOpacity(0.08)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isAccent
                    ? ColorCodes.purple
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isAccent
                    ? ColorCodes.purple
                    : (isDark ? Colors.white54 : Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openVoiceBottomSheet() {
    if (controller.contentFocusNode.hasFocus ||
        controller.titleFocusNode.hasFocus) {
      controller.unfocusAllFields();
      Future.delayed(
        const Duration(milliseconds: 300),
        showVoiceToTextBottomSheet,
      );
    } else {
      showVoiceToTextBottomSheet();
    }
  }

  void _openScanBottomSheet() {
    if (controller.contentFocusNode.hasFocus ||
        controller.titleFocusNode.hasFocus) {
      controller.unfocusAllFields();
      Future.delayed(
        const Duration(milliseconds: 300),
        showScanToTextBottomSheet,
      );
    } else {
      showScanToTextBottomSheet();
    }
  }

  Widget _buildAiChatOverlay(bool isDark) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AskQuestionGpt(isDark: isDark),
    );
  }
}