import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String? hintText;
  final String? validationMessage;
  final TextEditingController? controller;
  final int? maxLines;
  const TextFieldWidget({
    super.key,
    this.title,
    this.controller,
    this.maxLines,
    this.hintText,
    this.validationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.h,
        ),
        CustomText(
          text: title!,
          fontFamily: poppinsSemiBold,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        SizedBox(
          height: 10.h,
        ),
        Stack(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return validationMessage;
                }
                return null;
              },
              controller: controller,
              cursorColor: ColorCodes.teal,
              maxLines: maxLines,
              decoration: InputDecoration(
                fillColor: ColorCodes.background,
                filled: true,
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: poppins,
                  fontSize: 14,
                  color: ColorCodes.grey,
                ),
                contentPadding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 10, right: 25),
                constraints: const BoxConstraints(
                  minHeight: 30,
                  maxWidth: double.infinity,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => controller!.clear(),
                child: CustomIcon(
                  icon: Icons.clear,
                  size: 19,
                  color: ColorCodes.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
