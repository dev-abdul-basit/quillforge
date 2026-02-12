import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/lists/ai_tools_list.dart';
import 'package:ainotes/app/modules/ai_tools/controller/ai_tools_controller.dart';
import 'package:ainotes/app/routes/app_pages.dart';

import '../../../common/constants/app_strings.dart';

class AiToolsView extends GetView<AiToolsController> {
  const AiToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildFilterChips(isDark),
            Expanded(
              child: _buildToolsList(context, isDark),
            ),
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
          Text(
            AppStrings.aiTools,
            style: TextStyle(
              fontFamily: poppins,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return GetBuilder<AiToolsController>(
      builder: (_) => Container(
        height: 50,
        margin: EdgeInsets.only(bottom: 8.h),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.filter.length,
          itemBuilder: (context, index) {
            final isSelected = controller.selectedFilter == controller.filter[index];
            final int decrementIndex = index - 1;

            return GestureDetector(
              onTap: () => controller.setFilter(controller.filter[index]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                    colors: [ColorCodes.purpleLight, ColorCodes.purple],
                  )
                      : null,
                  color: isSelected
                      ? null
                      : (isDark ? Colors.white.withOpacity(0.08) : Colors.white),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: ColorCodes.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : (isDark
                      ? null
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.filter[index],
                        style: TextStyle(
                          fontFamily: poppins,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black54),
                        ),
                      ),
                      if (index > 0) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '[${aiTools[decrementIndex]["SubCategory"].length}]',
                          style: TextStyle(
                            fontFamily: poppins,
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white70
                                : (isDark ? Colors.white38 : Colors.black38),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildToolsList(BuildContext context, bool isDark) {
    return GetBuilder<AiToolsController>(
      builder: (_) => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.filteredAiTools.length,
        itemBuilder: (context, index) {
          return _buildCategorySection(context, isDark, index);
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, bool isDark, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          controller.selectedFilter != AppStrings.kAll
              ? controller.selectedFilter
              : controller.filteredAiTools[index]["Category"] ?? '',
          style: TextStyle(
            fontFamily: poppins,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.filteredAiTools[index]["SubCategory"].length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 110,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, subIndex) {
            return _buildToolCard(context, isDark, index, subIndex);
          },
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildToolCard(BuildContext context, bool isDark, int index, int subIndex) {
    final subCategory = controller.filteredAiTools[index]["SubCategory"][subIndex];

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.aiToolsResponseView,
          arguments: {
            "title": subCategory["Title"],
            "info": subCategory["Info"],
            "prompt": subCategory["prompt"],
            "category": controller.filteredAiTools[index]["Category"],
            "language": subCategory["language"],
            "subheadings": subCategory["subheadings"],
            "keywords": subCategory["keywords"],
            "length": subCategory["length"],
            "product": subCategory["product"],
            "description": subCategory["description"],
            "tone": subCategory["tone"],
            "name": subCategory["name"],
            "titled": subCategory["title"],
            "company": subCategory["company"],
            "subject": subCategory["subject"],
            "position": subCategory["position"],
            "domains": subCategory["domains"],
            "content": subCategory["content"],
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorCodes.purple.withOpacity(0.1),
            width: 1,
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    subCategory["Title"] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: poppins,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (subCategory["image"] != null) ...[
                  SizedBox(width: 8.w),
                  Image.asset(
                    subCategory["image"],
                    width: 24,
                    height: 24,
                  ),
                ],
              ],
            ),
            const Spacer(),
            Text(
              subCategory["Info"] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 12,
                height: 1.3,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}