import 'dart:io';

import 'package:flutter/cupertino.dart';
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

/// scanner to text
void showCommonBottomSheetScan() {
  final AddNoteController controller = Get.put(AddNoteController());

  Get.bottomSheet(
    isScrollControlled: true,
    GetBuilder<AddNoteController>(
      builder: (controller) {
        return Container(
          width: double.infinity,
          height: controller.imageFile == null ? 200 : 600,
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
                        controller.textScanning = false;
                        controller.imageFile = null;
                        controller.pickedImageValue = false;
                        controller.scannedText = "";
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
              SizedBox(
                height: 20.h,
              ),
              controller.imageFile == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => controller.selectImageToGallery(),
                          child: Container(
                            width: 130,
                            height: 70,
                            decoration: BoxDecoration(
                              color: ColorCodes.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border(
                                bottom: BorderSide(
                                  color: ColorCodes.teal.withOpacity(0.5),
                                  width: 3.0,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  CustomIcon(
                                    icon: Icons.image,
                                    color: ColorCodes.primary,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      AppConstants.gallery,
                                      style: TextStyle(
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
                        ),
                        GestureDetector(
                          onTap: () => controller.selectImageToCamera(),
                          child: Container(
                            width: 130,
                            height: 70,
                            decoration: BoxDecoration(
                              color: ColorCodes.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border(
                                bottom: BorderSide(
                                  color: ColorCodes.teal.withOpacity(0.5),
                                  width: 3.0,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  CustomIcon(
                                    icon: Icons.camera_alt,
                                    color: ColorCodes.primary,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      AppConstants.camera,
                                      style: TextStyle(
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
                        ),
                      ],
                    )
                  : controller.scannedText.isEmpty
                      ? Column(
                          children: [
                            CustomContainer(
                              height: 400,
                              width: 300,
                              borderColor: ColorCodes.teal,
                              backgroundColor: ColorCodes.teal.withOpacity(0.2),
                              containerChild: controller.imageFile == null
                                  ? const SizedBox()
                                  : controller.pickedImageValue == true
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Image.file(
                                          File(controller.imageFile!.path),
                                          fit: BoxFit.fill,
                                        ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            FloatingActionButton.extended(
                              backgroundColor: ColorCodes.teal,
                              onPressed: () {
                                controller.getImageToText(controller.imageFile);
                              },
                              label: Row(
                                children: [
                                  CustomIcon(
                                    icon: Icons.document_scanner,
                                    color: ColorCodes.surface,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    AppConstants.scan,
                                    style: TextStyle(
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
                        )
                      : Column(
                          children: [
                            CustomContainer(
                                height: 400,
                                width: 300,
                                borderColor: ColorCodes.teal,
                                containerChild: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Text(controller.scannedText),
                                  ),
                                )),
                            SizedBox(
                              height: 20.h,
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
                                        text: controller.scannedText,
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
                                  onTap: () => controller
                                      .insertBelow(controller.scannedText),
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
            ],
          ),
        );
      },
    ),
    isDismissible: false,
    barrierColor: ColorCodes.primary.withOpacity(0.3),
  );
}
