import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/widgets/text_button_widget.dart';

import '../../../common/constants/app_strings.dart';

/// Delete dialog box
void deleteDialogBox({
  required final VoidCallback onConfirm,
  final String? titleText,
}) {
  Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
              color: ColorCodes.background,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 20,
                bottom: 10,
                left: 20,
              ),
              child: Material(
                color: ColorCodes.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      titleText!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColorCodes.purple,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: poppins,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Are you sure you want to delete?",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorCodes.primary.withOpacity(0.8),
                        fontFamily: poppins,
                      ),
                    ),
                    const SizedBox(height: 15),
                    //Buttons
                    Row(
                      children: [
                        const Spacer(),
                        CommonTextButton(
                          text: AppStrings.cancel,
                          onPressed: () => Get.back(),
                        ),
                        const SizedBox(width: 2),
                        CommonTextButton(
                          text: AppStrings.delete,
                          onPressed: onConfirm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
