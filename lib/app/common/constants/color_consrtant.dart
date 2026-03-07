import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorCodes {
  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND PURPLE PALETTE (Single Source of Truth)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary brand purple - use for buttons, icons, accents
  static const Color purple = Color(0xFF7209B7);

  /// Lighter purple - use for gradient start points, highlights
  static const Color purpleLight = Color(0xFF9B59F7);

  /// Darker purple - use for gradient end points, depth
  static const Color purpleDark = Color(0xFF3D1E6D);

  // ═══════════════════════════════════════════════════════════════════════════
  // STANDARD GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary gradient (top to bottom) - use for Premium screen, splash, full-screen backgrounds
  static const LinearGradient primaryGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [purpleLight, purple, purpleDark],
  );

  /// Compact gradient (diagonal) - use for FAB, buttons, small elements
  static const LinearGradient primaryGradientDiagonal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purpleLight, purple],
  );

  /// Subtle gradient - use for cards, overlays with transparency
  static LinearGradient get primaryGradientSubtle => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purpleLight.withOpacity(0.2), purple.withOpacity(0.2)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LEGACY / OTHER COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color teal = Color(0xff02c699);
  static const Color bg = Color(0xfff0f4f7);
  static const Color tealLight = Color(0xff02fec1);
  static const Color cyanLight = Color(0xff92EFFD);
  static const Color cyanDark = Color(0xff4E65FF);
  static const Color orange = Color(0xffFBB03B);
  static const Color pink = Color(0xffD4145A);
  static const Color blueGray = Color(0xff53787D);

  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;

  static Color greyLight = Colors.grey.withOpacity(0.1);

  /// Theme Color
  static Color get primary => Get.theme.colorScheme.primary;
  static Color get onPrimary => Get.theme.colorScheme.onPrimary;
  static Color get background => Get.theme.colorScheme.background;
  static Color get surface => Get.theme.colorScheme.surface;
}