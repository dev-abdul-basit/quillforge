import 'package:flutter/material.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';

class AppTheme {
  static ColorScheme darkTheme = const ColorScheme.dark(
    primary: ColorCodes.purpleLight,
    onPrimary: ColorCodes.black,
    secondary: ColorCodes.black,
    onSecondary: ColorCodes.white,
    surface: ColorCodes.black,
    error: ColorCodes.red,
    onError: ColorCodes.white,
    onSurface: ColorCodes.white,
  );

  static ColorScheme lightTheme = const ColorScheme.light(
    primary: ColorCodes.purple,
    onPrimary: ColorCodes.white,
    secondary: ColorCodes.bg,
    onSecondary: ColorCodes.white,
    surface: ColorCodes.white,
    error: ColorCodes.red,
    onError: ColorCodes.white,
    onSurface: ColorCodes.black,
  );

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: lightTheme,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: darkTheme,
    brightness: Brightness.dark,
  );
}
