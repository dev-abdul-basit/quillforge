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

import 'dart:io';
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

import '../../../common/constants/app_strings.dart';

import 'dart:io';
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

void showScanToTextBottomSheet() {
  final isDark = Get.isDarkMode;

  Get.bottomSheet(
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    GetBuilder<AddNoteController>(
      builder: (controller) => _ScanToTextSheet(
        controller: controller,
        isDark: isDark,
      ),
    ),
  );
}

class _ScanToTextSheet extends StatelessWidget {
  final AddNoteController controller;
  final bool isDark;

  const _ScanToTextSheet({
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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDragHandle(),
                  SizedBox(height: 8.h),
                  _buildHeader(),
                  SizedBox(height: 16.h),
                  Flexible(child: _buildContent()),
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
                CupertinoIcons.doc_text_viewfinder,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Scan to Text',
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
            controller.clearImageData();
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
    // Use controller's actual property names
    if (controller.selectedImage == null) {
      return _buildSourceSelection();
    } else if (controller.scannedImageText.isEmpty) {
      return _buildImagePreview();
    } else {
      return _buildScannedResult();
    }
  }

  Widget _buildSourceSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose image source',
            style: TextStyle(
              fontFamily: poppins,
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildSourceButton(
                  icon: CupertinoIcons.photo,
                  label: 'Gallery',
                  subtitle: 'Choose from photos',
                  onTap: () => controller.pickImageFromGallery(),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildSourceButton(
                  icon: CupertinoIcons.camera_fill,
                  label: 'Camera',
                  subtitle: 'Take a photo',
                  onTap: () => controller.pickImageFromCamera(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSourceButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorCodes.purple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: ColorCodes.purple,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
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

  Widget _buildImagePreview() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 350.h,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorCodes.purple.withOpacity(0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: controller.isLoadingImage
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: SpinKitFadingCircle(
                    color: ColorCodes.purple,
                    size: 40,
                  ),
                ),
              )
                  : Image.file(
                File(controller.selectedImage!.path),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          controller.isScanningImage
              ? _buildScanningProgress()
              : _buildScanButton(),
        ],
      ),
    );
  }

  Widget _buildScanningProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          SpinKitThreeBounce(
            color: ColorCodes.purple,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            'Scanning text...',
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

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: () => controller.extractTextFromImage(controller.selectedImage),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
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
            const Icon(
              CupertinoIcons.doc_text_viewfinder,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              'Scan Text',
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedResult() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: 300.h,
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
                controller.scannedImageText,
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
      ),
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
              Clipboard.setData(ClipboardData(text: controller.scannedImageText))
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
                controller.insertTextIntoNote(controller.scannedImageText);
                controller.clearImageData();
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
// void showScanToTextBottomSheet() {
//   Get.bottomSheet(
//     isScrollControlled: true,
//     isDismissible: false,
//     barrierColor: ColorCodes.primary.withOpacity(0.3),
//     GetBuilder<AddNoteController>(
//       builder: (controller) => Container(
//         width: double.infinity,
//         height: controller.selectedImage == null ? 200 : 600,
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
//             SizedBox(height: 20.h),
//             _buildContent(controller),
//           ],
//         ),
//       ),
//     ),
//   );
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
//             controller.clearImageData();
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
//   if (controller.selectedImage == null) {
//     return _buildImageSourceSelection(controller);
//   } else if (controller.scannedImageText.isEmpty) {
//     return _buildImagePreview(controller);
//   } else {
//     return _buildScannedText(controller);
//   }
// }
//
// Widget _buildImageSourceSelection(AddNoteController controller) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       _buildSourceButton(
//         label: AppStrings.gallery,
//         icon: Icons.image,
//         onTap: controller.pickImageFromGallery,
//       ),
//       _buildSourceButton(
//         label: AppStrings.camera,
//         icon: Icons.camera_alt,
//         onTap: controller.pickImageFromCamera,
//       ),
//     ],
//   );
// }
//
// Widget _buildSourceButton({
//   required String label,
//   required IconData icon,
//   required VoidCallback onTap,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       width: 130,
//       height: 70,
//       decoration: BoxDecoration(
//         color: ColorCodes.grey.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//         border: Border(
//           bottom: BorderSide(color: ColorCodes.purple.withOpacity(0.5), width: 3.0),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: Row(
//           children: [
//             CommonmIcon(icon: icon, color: ColorCodes.primary, size: 25),
//             SizedBox(width: 10.w),
//             Flexible(
//               child: Text(
//                 label,
//                 style:  TextStyle(
//                   color: ColorCodes.primary,
//                   fontFamily: montserratRegular,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _buildImagePreview(AddNoteController controller) {
//   return Column(
//     children: [
//       CommonContainer(
//         height: 400,
//         width: 300,
//         borderColor: ColorCodes.purple,
//         backgroundColor: ColorCodes.purple.withOpacity(0.2),
//         containerChild: controller.isLoadingImage
//             ? const Center(child: CircularProgressIndicator())
//             : Image.file(
//           File(controller.selectedImage!.path),
//           fit: BoxFit.contain,
//         ),
//       ),
//       SizedBox(height: 20.h),
//       FloatingActionButton.extended(
//         backgroundColor: ColorCodes.purple,
//         onPressed: () => controller.extractTextFromImage(controller.selectedImage),
//         label: Row(
//           children: [
//              CommonmIcon(icon: Icons.document_scanner, color: ColorCodes.surface),
//             const SizedBox(width: 10),
//             Text(
//               AppStrings.scan,
//               style:  TextStyle(
//                 color: ColorCodes.surface,
//                 fontFamily: montserratRegular,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _buildScannedText(AddNoteController controller) {
//   return Column(
//     children: [
//       CommonContainer(
//         height: 400,
//         width: 300,
//         borderColor: ColorCodes.purple,
//         containerChild: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Text(controller.scannedImageText),
//           ),
//         ),
//       ),
//       SizedBox(height: 20.h),
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
//       Clipboard.setData(ClipboardData(text: controller.scannedImageText))
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
//     onTap: () => controller.insertTextIntoNote(controller.scannedImageText),
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
