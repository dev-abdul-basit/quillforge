import 'package:flutter/material.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Color? fillColor;
  final double? minHeight;
  final double? maxWidth;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? borderRadius;
  final double? focusedBorderRadius;
  final double? enabledBorderRadius;
  final bool? readOnly;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextStyle? style;

  const CustomTextField({
    super.key,
    this.controller,
    this.fillColor,
    this.minHeight,
    this.maxWidth,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.focusedBorderRadius,
    this.enabledBorderRadius,
    this.readOnly,
    this.focusNode,
    this.maxLines,
    this.minLines,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly ?? false,
      cursorColor: ColorCodes.teal,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onTap: onTap,
      style: style,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 15,
        ),
        constraints: BoxConstraints(
            minHeight: minHeight ?? 30, maxWidth: maxWidth ?? double.infinity),
        hintStyle: hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(focusedBorderRadius ?? 10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(enabledBorderRadius ?? 10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
    ;
  }
}
