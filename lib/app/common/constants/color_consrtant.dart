import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorCodes {
  static const Color teal = Color(0xff02c699);
  static const Color bg = Color(0xfff0f4f7);
  static const Color purple = Color(0xff8446f1);

  static const Color purpleDark = Color(0xff9a3bed);
  static const Color tealLight = Color(0xff02fec1);
  static const Color cyanLight = Color(0xff92EFFD);
  static const Color cyanDark = Color(0xff4E65FF);
  static const Color orange = Color(0xffFBB03B);
  static const Color pink = Color(0xffD4145A);
  static const Color blueGray = Color(0xff53787D);

  static const Color black = Color(0xff28282B);
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
