import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/modules/Add_Note/controller/add_note_controller.dart';

import '../../../common/constants/app_strings.dart';

void showScanToTextBottomSheet() {
  Get.bottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    barrierColor: ColorCodes.primary.withOpacity(0.3),
    GetBuilder<AddNoteController>(
      builder: (controller) => Container(
        width: double.infinity,
        height: controller.selectedImage == null ? 200 : 600,
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
            SizedBox(height: 20.h),
            _buildContent(controller),
          ],
        ),
      ),
    ),
  );
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
            controller.clearImageData();
            Get.back();
          },
          icon: Icon(Icons.clear, color: ColorCodes.primary),
        ),
      ),
    ],
  );
}

Widget _buildContent(AddNoteController controller) {
  if (controller.selectedImage == null) {
    return _buildImageSourceSelection(controller);
  } else if (controller.scannedImageText.isEmpty) {
    return _buildImagePreview(controller);
  } else {
    return _buildScannedText(controller);
  }
}

Widget _buildImageSourceSelection(AddNoteController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _buildSourceButton(
        label: AppStrings.gallery,
        icon: Icons.image,
        onTap: controller.pickImageFromGallery,
      ),
      _buildSourceButton(
        label: AppStrings.camera,
        icon: Icons.camera_alt,
        onTap: controller.pickImageFromCamera,
      ),
    ],
  );
}

Widget _buildSourceButton({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 130,
      height: 70,
      decoration: BoxDecoration(
        color: ColorCodes.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border(
          bottom: BorderSide(color: ColorCodes.purple.withOpacity(0.5), width: 3.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            CommonmIcon(icon: icon, color: ColorCodes.primary, size: 25),
            SizedBox(width: 10.w),
            Flexible(
              child: Text(
                label,
                style:  TextStyle(
                  color: ColorCodes.primary,
                  fontFamily: montserratRegular,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildImagePreview(AddNoteController controller) {
  return Column(
    children: [
      CommonContainer(
        height: 400,
        width: 300,
        borderColor: ColorCodes.purple,
        backgroundColor: ColorCodes.purple.withOpacity(0.2),
        containerChild: controller.isLoadingImage
            ? const Center(child: CircularProgressIndicator())
            : Image.file(
          File(controller.selectedImage!.path),
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(height: 20.h),
      FloatingActionButton.extended(
        backgroundColor: ColorCodes.purple,
        onPressed: () => controller.extractTextFromImage(controller.selectedImage),
        label: Row(
          children: [
             CommonmIcon(icon: Icons.document_scanner, color: ColorCodes.surface),
            const SizedBox(width: 10),
            Text(
              AppStrings.scan,
              style:  TextStyle(
                color: ColorCodes.surface,
                fontFamily: montserratRegular,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildScannedText(AddNoteController controller) {
  return Column(
    children: [
      CommonContainer(
        height: 400,
        width: 300,
        borderColor: ColorCodes.purple,
        containerChild: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Text(controller.scannedImageText),
          ),
        ),
      ),
      SizedBox(height: 20.h),
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
      Clipboard.setData(ClipboardData(text: controller.scannedImageText))
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
    onTap: () => controller.insertTextIntoNote(controller.scannedImageText),
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
