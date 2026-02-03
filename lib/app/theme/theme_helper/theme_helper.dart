import 'package:flutter/material.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';

class AppTheme {
  static ColorScheme darkTheme = const ColorScheme.dark(
    primary: ColorCodes.white,
    onPrimary: ColorCodes.white,
    // primaryContainer: Color(0xFFD0C000),
    // onPrimaryContainer: ColorCodes.tint,
    //secondary: Colors.white,
    // onSecondary: Color(0xFFF3F3F3),
    secondaryContainer: ColorCodes.black,
    // onSecondaryContainer: Color(0xFF333333),
    // error: Colors.redAccent,
    // onError: Colors.red,
    // errorContainer: Colors.redAccent,
    // onErrorContainer: Color(0xFFF9DEDC),
    // outline: Color(0xFF938F99),
    surface: ColorCodes.black,
    // onSurface: ColorCodes.black,
    // surface: Color(0xFF333333),
    // onSurface: Color(0xFFF3F3F3),
    // surfaceVariant: Color(0xFF49454F),
    // onSurfaceVariant: ColorCodes.black,
  );

  static ColorScheme lightTheme = const ColorScheme.light(
    primary: ColorCodes.black,
    onPrimary: ColorCodes.black,
    // primaryContainer: const Color(0xFFFDD943),
    //onPrimaryContainer: ColorCodes.white,
    //secondary: Colors.black,
    // onSecondary: const Color(0xFFF3F3F3),
    secondaryContainer: ColorCodes.bg,
    // onSecondaryContainer: ColorCodes.white,
    // error: Colors.redAccent,
    // onError: Colors.red,
    // errorContainer: Colors.redAccent,
    // onErrorContainer: const Color(0xFFF9DEDC),
    // outline: const Color(0xFF6F6D73),
    surface: ColorCodes.white,
    // onSurface: ColorCodes.bg,
    // surface: const Color(0xFF333333),
    // onSurface: const Color(0xFF333333),
    // surfaceVariant: const Color(0xFF57545B),
    // onSurfaceVariant: ColorCodes.bg,
  );

  static final light = ThemeData(
      useMaterial3: true,
      // fontFamily: poppins,
      colorScheme: lightTheme,
      brightness: Brightness.light);
  static final dark = ThemeData(
      useMaterial3: true,
      // fontFamily: poppins,
      colorScheme: darkTheme,
      brightness: Brightness.dark);
}
