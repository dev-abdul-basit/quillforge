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

import '../../../common/constants/app_strings.dart';

class AddNoteView extends GetView<AddNoteController> {
  const AddNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingDraggableWidget(
      autoAlign: true,
      floatingWidget: _buildAiFloatingButton(),
      floatingWidgetHeight: 40,
      floatingWidgetWidth: 40,
      dx: 0,
      dy: 300,
      mainScreenWidget: _buildMainScaffold(context),
    );
  }

  Widget _buildAiFloatingButton() {
    return FloatingActionButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: ColorCodes.purple,
      onPressed: controller.showAiChat,
      child: Image.asset(
        openAiLogo,
        height: 25,
        width: 25,
        color: ColorCodes.white,
      ),
    );
  }

  Widget _buildMainScaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: _buildAppBar(context),
      body: GetBuilder<AddNoteController>(
        builder: (_) => Stack(
          children: [
            Column(
              children: [
                _buildNoteContentField(context),
                _buildBottomActionBar(),
              ],
            ),
            if (controller.isAiChatVisible) _buildAiChatOverlay(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CommonAppBar(
      leading: _buildBackButton(context),
      leadingWidth: 50,
      titleSpacing: 5,
      title: _buildTitleField(context),
      actions: [
        _buildSaveButton(),
        SizedBox(width: 15.w),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: GestureDetector(
        onTap: () => _handleBackPress(),
        child: CommonContainer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          borderWidth: 0,
          containerChild: const CommonmIcon(icon: Icons.clear),
        ),
      ),
    );
  }

  void _handleBackPress() {
    if (controller.contentFocusNode.hasFocus || controller.titleFocusNode.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(const Duration(milliseconds: 200), () => Get.back());
    } else {
      Get.back();
    }
  }

  Widget _buildTitleField(BuildContext context) {
    return GetBuilder<AddNoteController>(
      builder: (_) => CommonTextField(
        onTap: () {
          controller.hideAiChat();
        },
        onChanged: (_) => controller.update(),
        controller: controller.titleTextController,
        fillColor: Theme.of(context).colorScheme.background,
        maxLines: 1,
        maxWidth: double.infinity,
        hintText: AppStrings.title,
        hintStyle: const TextStyle(
          fontFamily: poppins,
          fontWeight: FontWeight.bold,
          color: ColorCodes.grey,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorCodes.purple,
        ),
        minHeight: 30,
        borderRadius: 15,
        enabledBorderRadius: 15,
        focusedBorderRadius: 15,
      ),
    );
  }

  Widget _buildSaveButton() {
    return GetBuilder<AddNoteController>(
      builder: (_) {
        final bool hasContent = controller.titleTextController.text.isNotEmpty ||
            controller.contentTextController.text.isNotEmpty;

        return hasContent
            ? IconButton(
          highlightColor: Colors.teal.withOpacity(0.2),
          onPressed: () {
            controller.saveOrUpdateNote();
            Get.back();
          },
          icon: Image.asset(saveIcon, height: 20, width: 20),
        )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _buildNoteContentField(BuildContext context) {
    return GetBuilder<AddNoteController>(
      builder: (_) => Expanded(
        child: TextField(
          onTap: controller.hideAiChat,
          controller: controller.contentTextController,
          focusNode: controller.contentFocusNode,
          cursorColor: ColorCodes.purple,
          maxLines: null,
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
            filled: true,
            hintText: AppStrings.hintEnterOrPasteTextHere,
            hintStyle: const TextStyle(
              fontFamily: poppins,
              color: ColorCodes.grey,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            constraints: const BoxConstraints(
              minHeight: 30,
              maxWidth: double.infinity,
            ),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return GetBuilder<AddNoteController>(
      builder: (_) {
        final bool isAnyFieldFocused = controller.contentFocusNode.hasFocus ||
            controller.titleFocusNode.hasFocus;

        return CommonContainer(
          height: 50,
          containerChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                icon: Icons.keyboard_alt_outlined,
                onPressed: controller.focusContentField,
              ),
              _buildActionButton(
                icon: Icons.mic,
                onPressed: () => _openVoiceBottomSheet(),
              ),
              _buildActionButton(
                icon: Icons.document_scanner,
                onPressed: () => _openScanBottomSheet(),
              ),
              if (isAnyFieldFocused)
                _buildActionButton(
                  icon: Icons.arrow_back_ios_sharp,
                  onPressed: controller.unfocusAllFields,
                  rotated: true,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool rotated = false,
  }) {
    final Widget iconWidget = CommonmIcon(
      icon: icon,
      size: 22,
      color: ColorCodes.purple,
    );

    return IconButton(
      highlightColor: Colors.teal.withOpacity(0.2),
      onPressed: onPressed,
      icon: rotated ? RotatedBox(quarterTurns: 3, child: iconWidget) : iconWidget,
    );
  }

  void _openVoiceBottomSheet() {
    if (controller.contentFocusNode.hasFocus || controller.titleFocusNode.hasFocus) {
      controller.unfocusAllFields();
      Future.delayed(
        const Duration(milliseconds: 500),
        showVoiceToTextBottomSheet,
      );
    } else {
      showVoiceToTextBottomSheet();
    }
  }

  void _openScanBottomSheet() {
    if (controller.contentFocusNode.hasFocus || controller.titleFocusNode.hasFocus) {
      controller.unfocusAllFields();
      Future.delayed(
        const Duration(milliseconds: 500),
        showScanToTextBottomSheet,
      );
    } else {
      showScanToTextBottomSheet();
    }
  }

  Widget _buildAiChatOverlay() {
    return const Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AskQuestionGpt(),
    );
  }
}


