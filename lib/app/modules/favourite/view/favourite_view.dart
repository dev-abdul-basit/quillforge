import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/modules/favourite/controller/favourite_controller.dart';
import 'package:ainotes/app/modules/home/widget/delete_note_dialogbox.dart';
import 'package:ainotes/app/routes/app_pages.dart';

import '../../../common/constants/app_strings.dart';

class FavouriteView extends GetView<FavouriteController> {
  const FavouriteView({super.key});

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
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.star_fill,
                      size: 20,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.favourite,
                      style: TextStyle(
                        fontFamily: poppins,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: isDark ? Colors.white : Colors.black87,
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

  Widget _buildContent(BuildContext context, bool isDark) {
    return GetBuilder<FavouriteController>(
      builder: (_) => FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.getFavorite(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorCodes.purple,
                strokeWidth: 2,
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildErrorState(isDark, snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(isDark);
          }

          final data = snapshot.data!.reversed.toList();

          return _buildMasonryGrid(context, isDark, data);
        },
      ),
    );
  }

  Widget _buildMasonryGrid(
      BuildContext context,
      bool isDark,
      List<Map<String, dynamic>> data,
      ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _buildNoteCard(
            context: context,
            isDark: isDark,
            noteData: data[index],
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildNoteCard({
    required BuildContext context,
    required bool isDark,
    required Map<String, dynamic> noteData,
    required int index,
  }) {
    // Parse date
    String createdAt = noteData["createdAt"] ?? "";
    String formattedDate = "";
    try {
      DateTime dateTime = DateFormat("EEE, M/d/yyyy hh:mm:ss a").parse(createdAt);
      formattedDate = DateFormat("MMM d, yyyy").format(dateTime);
    } catch (e) {
      formattedDate = createdAt;
    }

    final bool isFavorite = noteData["favorite"] == 1;
    final String title = noteData["title"] ?? "Quick Note";
    final String description = noteData["description"] ?? "";

    // Calculate dynamic height based on content
    // Shorter content = smaller card, longer content = larger card
    final int descLength = description.length;
    int maxLines;
    if (descLength < 50) {
      maxLines = 2;
    } else if (descLength < 100) {
      maxLines = 4;
    } else if (descLength < 200) {
      maxLines = 6;
    } else {
      maxLines = 8;
    }

    // Alternate accent colors for visual interest
    final List<Color> accentColors = [
      ColorCodes.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.green,
    ];
    final Color accentColor = accentColors[index % accentColors.length];

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.addNoteView,
          arguments: {
            "id": noteData["id"],
            "title": noteData["title"],
            "description": noteData["description"],
            "isFavoriteScreen": true,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            // Top accent bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
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
                      _buildActionButtons(
                        noteData: noteData,
                        isFavorite: isFavorite,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Description
                  Text(
                    description,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Footer with date
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        size: 12,
                        color: isDark ? Colors.white30 : Colors.black26,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontFamily: poppins,
                            fontSize: 10,
                            color: isDark ? Colors.white30 : Colors.black26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons({
    required Map<String, dynamic> noteData,
    required bool isFavorite,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => controller.toggleFavorite(
            noteData["id"],
            noteData["favorite"],
          ),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Icon(
              isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
              size: 18,
              color: isFavorite
                  ? Colors.orange
                  : (isDark ? Colors.white30 : Colors.black26),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            showiOSDeleteDialog(
              context: Get.context!,
              isDark: isDark,
              title: AppStrings.deleteNote,
              onConfirm: () {
                controller.deleteNote(noteData["id"]);
                Get.back();
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Icon(
              CupertinoIcons.trash,
              size: 18,
              color: isDark ? Colors.white30 : Colors.black26,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.star,
                size: 56,
                color: Colors.orange.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.kNoFavourite,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Star your notes to see them here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 14,
                color: isDark ? Colors.white38 : Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 48,
                color: Colors.red.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 12,
                color: isDark ? Colors.white38 : Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}