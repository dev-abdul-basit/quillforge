import 'package:flutter/material.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';

class CommonTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const CommonTextButton(
      {super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: ColorCodes.purple.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: ColorCodes.purple,
          fontFamily: poppins,
        ),
      ),
    );
  }
}
