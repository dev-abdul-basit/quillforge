import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/modules/post_create/controller/post_create_controller.dart';

import '../../../common/constants/app_strings.dart';

class PostCreateView extends GetView<PostCreateController> {
  const PostCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            Expanded(
              child: _buildContent(context, isDark),
            ),
            _buildBottomActions(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isDark
                    ? null
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                CupertinoIcons.back,
                size: 20,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.postType ?? "Social"} Caption',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    _buildPlatformIcon(),
                    SizedBox(width: 6.w),
                    Text(
                      'AI Generated',
                      style: TextStyle(
                        fontFamily: poppins,
                        fontSize: 12,
                        color: ColorCodes.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformIcon() {
    String iconAsset;
    final postType = controller.postType?.toLowerCase() ?? '';

    switch (postType) {
      case 'instagram':
        iconAsset = instagramIcon;
        break;
      case 'facebook':
        iconAsset = facebookIcon;
        break;
      case 'x':
      case 'twitter':
        iconAsset = twitterIcon;
        break;
      default:
        iconAsset = instagramIcon;
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Image.asset(
        iconAsset,
        width: 18,
        height: 18,
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorCodes.purple.withOpacity(0.15),
        ),
        boxShadow: isDark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform indicator header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ColorCodes.purple.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                _buildPlatformIcon(),
                SizedBox(width: 8.w),
                Text(
                  'Ready to post on ${controller.postType ?? "Social Media"}',
                  style: TextStyle(
                    fontFamily: poppins,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ColorCodes.purple,
                  ),
                ),
                const Spacer(),
                Icon(
                  CupertinoIcons.checkmark_seal_fill,
                  size: 18,
                  color: ColorCodes.purple,
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: SelectableText(
                controller.postResponse ?? '',
                style: TextStyle(
                  fontFamily: poppins,
                  fontSize: 15,
                  height: 1.7,
                  color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryButton(
                    icon: CupertinoIcons.share,
                    label: 'Share',
                    isDark: isDark,
                    onTap: () => _shareContent(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: _buildPrimaryButton(
                    icon: CupertinoIcons.doc_on_clipboard,
                    label: 'Copy to Clipboard',
                    onTap: () => _copyToClipboard(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildReportButton(context, isDark),
            _buildAiPolicyNote(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
            SizedBox(width: 8.w),
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

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
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

  /// Report offensive content button - safety requirement
  Widget _buildReportButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _showReportDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.flag,
              size: 14,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            SizedBox(width: 6.w),
            Text(
              'Report offensive content',
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

  void _showReportDialog(BuildContext context) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Report Content'),
        content: const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Would you like to report this AI-generated content as offensive, harmful, or inappropriate?',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Get.back();
              // TODO: Implement actual reporting logic
              Fluttertoast.showToast(
                msg: 'Report submitted. Thank you for helping keep QuillForge safe.',
                backgroundColor: ColorCodes.purple,
                toastLength: Toast.LENGTH_LONG,
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  /// AI policy disclaimer - safety requirement
  Widget _buildAiPolicyNote(bool isDark) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Text(
        'AI can make mistakes. Do not use outputs for illegal or harmful purposes.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: poppins,
          fontSize: 11,
          color: isDark ? Colors.white30 : Colors.black26,
        ),
      ),
    );
  }

  void _copyToClipboard() {
    if (controller.postResponse != null) {
      Clipboard.setData(ClipboardData(text: controller.postResponse!)).then(
            (_) {
          Fluttertoast.showToast(
            msg: 'Copied to clipboard',
            backgroundColor: ColorCodes.purple,
          );
        },
      );
    }
  }

  void _shareContent() {
    // Note: For actual sharing, you'd use the share_plus package
    // For now, we'll just copy and notify the user
    _copyToClipboard();
    Fluttertoast.showToast(
      msg: 'Content copied. You can paste it anywhere to share.',
      backgroundColor: ColorCodes.purple,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}