import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/loding_utils.dart';
import 'package:ainotes/app/modules/Premium/controller/premium_controller.dart';
import 'package:ainotes/app/modules/home/controller/home_controller.dart';
import 'package:ainotes/app/modules/home/widget/delete_note_dialogbox.dart';
import 'package:ainotes/app/modules/home/widget/earn_reward_dialog_box.dart';
import 'package:ainotes/app/routes/app_pages.dart';

import '../../../common/constants/app_strings.dart';

final HomeController homeController = Get.put(HomeController());
final PremiumController premiumController = Get.put(PremiumController());

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (_) => Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: RefreshIndicator(
                  color: ColorCodes.purple,
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    controller.refreshData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!controller.isSearch) ...[
                          SizedBox(height: 16.h),
                          _buildAiToolsSection(context, isDark),
                        ],
                        SizedBox(height: 20.h),
                        _buildNotesSection(context, isDark),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAdBanner(isDark),
      floatingActionButton: _buildFloatingActionButton(isDark),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return GetBuilder<HomeController>(
      builder: (_) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(child: _buildSearchField(context, isDark)),
            SizedBox(width: 12.w),
            if (!controller.isSearch) ...[
              if (!premiumController.isPremium) _buildCreditsButton(context, isDark),
              if (!premiumController.isPremium) SizedBox(width: 8.w),
              _buildSettingsButton(context, isDark),
            ] else
              _buildCancelButton(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: controller.isSearch ? null : () => controller.onTapToSearch(),
      child: Container(
        height: 44,
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
        child: controller.isSearch
            ? TextField(
          controller: controller.searchController,
          autofocus: true,
          style: TextStyle(
            fontFamily: poppins,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.searched,
            hintStyle: TextStyle(
              fontFamily: poppins,
              fontSize: 15,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 20,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            suffixIcon: controller.searchController.text.isNotEmpty
                ? GestureDetector(
              onTap: () => controller.searchController.clear(),
              child: Icon(
                CupertinoIcons.xmark_circle_fill,
                size: 18,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        )
            : Row(
          children: [
            SizedBox(width: 14.w),
            Icon(
              CupertinoIcons.search,
              size: 20,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
            SizedBox(width: 10.w),
            Text(
              AppStrings.searched,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 15,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditsButton(BuildContext context, bool isDark) {
    return GetBuilder<HomeController>(
      builder: (_) => GestureDetector(
        onTap: () {
          if (controller.messageLimit == 0) {
            showWatchAdsDialog(
              context: context,
              isDark: isDark,
              watchAdsOnTap: () {
                if (!controller.isAdLoadedRewarded) {
                  controller.loadRewardedAd(context);
                } else {
                  Fluttertoast.showToast(msg: "Ad is not loaded yet");
                }
              },
            );
          }
        },
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.orange.shade600],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.sparkles,
                size: 16,
                color: Colors.white,
              ),
              SizedBox(width: 6.w),
              Text(
                controller.messageLimit.toString(),
                style: TextStyle(
                  fontFamily: poppins,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.settingView),
      child: Container(
        width: 44,
        height: 44,
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
          CupertinoIcons.gear,
          size: 22,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => controller.onTapToSearchBack(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          AppStrings.cancel,
          style: TextStyle(
            fontFamily: poppins,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: ColorCodes.purple,
          ),
        ),
      ),
    );
  }

  Widget _buildAiToolsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.aiTools,
          style: TextStyle(
            fontFamily: poppins,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildAiToolCard(
                context: context,
                isDark: isDark,
                title: AppStrings.generatePost,
                icon: _buildSocialIcons(),
                onTap: () => Get.toNamed(Routes.generatePostView),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildAiToolCard(
                context: context,
                isDark: isDark,
                title: AppStrings.more,
                icon: Icon(
                  CupertinoIcons.square_grid_2x2,
                  size: 24,
                  color: ColorCodes.purple,
                ),
                onTap: () => Get.toNamed(Routes.aiToolsView),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSocialIcon(instagramIcon),
        Transform.translate(
          offset: const Offset(-8, 0),
          child: _buildSocialIcon(facebookIcon),
        ),
        Transform.translate(
          offset: const Offset(-16, 0),
          child: _buildSocialIcon(twitterIcon),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(String asset) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          asset,
          width: 28,
          height: 28,
        ),
      ),
    );
  }

  Widget _buildAiToolCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Text(
              title,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.quickNote,
              style: TextStyle(
                fontFamily: poppins,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            GetBuilder<HomeController>(
              builder: (_) {
                if (controller.historyList.isEmpty) {
                  return const SizedBox();
                }
                return GestureDetector(
                  onTap: () {
                    showiOSDeleteDialog(
                      context: context,
                      isDark: isDark,
                      title: AppStrings.clearAllNotes,
                      onConfirm: () {
                        controller.deleteNoteTable();
                        Get.back();
                      },
                    );
                  },
                  child: Text(
                    AppStrings.clearAll,
                    style: TextStyle(
                      fontFamily: poppins,
                      fontSize: 13,
                      color: ColorCodes.purple,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildNotesList(context, isDark),
      ],
    );
  }

  Widget _buildNotesList(BuildContext context, bool isDark) {
    return GetBuilder<HomeController>(
      builder: (_) {
        if (controller.filteredList.isEmpty) {
          return _buildEmptyState(isDark);
        }

        final reversedData = controller.filteredList.reversed.toList();

        // Use MasonryGridView for staggered layout
        return MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: reversedData.length,
          itemBuilder: (context, index) {
            return _buildNoteCard(
              context: context,
              isDark: isDark,
              noteData: reversedData[index],
              index: index,
            );
          },
        );
      },
    );
  }

  Widget _buildNoteCard({
    required BuildContext context,
    required bool isDark,
    required Map<String, dynamic> noteData,
    required int index,
  }) {
    String createdAt = noteData["createdAt"] ?? "";
    String formattedDate = "";

    try {
      DateTime dateTime = DateFormat("EEE, M/d/yyyy hh:mm:ss a").parse(createdAt);
      formattedDate = DateFormat("MMM d, yyyy").format(dateTime);
    } catch (e) {
      formattedDate = createdAt;
    }

    final bool isFavorite = noteData["favorite"] == 1;
    final String description = noteData["description"] ?? "";

    // Calculate dynamic max lines based on content length
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

    // Accent colors for visual variety
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
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          noteData["title"] ?? "Quick Note",
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
                      _buildNoteActionButtons(noteData, isFavorite, isDark),
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
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontFamily: poppins,
                          fontSize: 10,
                          color: isDark ? Colors.white30 : Colors.black26,
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

  Widget _buildNoteActionButtons(
      Map<String, dynamic> noteData,
      bool isFavorite,
      bool isDark,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => controller.toggleFavorite(
            noteData["id"],
            noteData["favorite"],
          ),
          child: Icon(
            isFavorite ? CupertinoIcons.star_fill : CupertinoIcons.star,
            size: 18,
            color: isFavorite
                ? Colors.orange
                : (isDark ? Colors.white30 : Colors.black26),
          ),
        ),
        SizedBox(width: 12.w),
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
          child: Icon(
            CupertinoIcons.trash,
            size: 18,
            color: isDark ? Colors.white30 : Colors.black26,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorCodes.purple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.isSearch
                    ? CupertinoIcons.search
                    : CupertinoIcons.doc_text,
                size: 40,
                color: ColorCodes.purple.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              controller.isSearch ? AppStrings.kNoSearch : AppStrings.kNoHistory,
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              controller.isSearch
                  ? 'Try a different search term'
                  : 'Tap + to create your first note',
              style: TextStyle(
                fontFamily: poppins,
                fontSize: 13,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAdBanner(bool isDark) {
    return GetBuilder<HomeController>(
      builder: (_) {
        if (premiumController.isPremium || controller.isSearch) {
          return const SizedBox.shrink();
        }
        if (!controller.isAdLoadedBanner) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.only(bottom: 16.h),
          child: SizedBox(
            height: controller.bannerAd.size.height.toDouble(),
            width: controller.bannerAd.size.width.toDouble(),
            child: AdWidget(ad: controller.bannerAd),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(bool isDark) {
    return GetBuilder<HomeController>(
      builder: (_) {
        if (controller.isSearch) return const SizedBox.shrink();

        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: GestureDetector(
            onTap: () async {
              if (premiumController.isPremium) {
                Get.toNamed(Routes.addNoteView);
              } else {
                if (!controller.isAdLoaded) {
                  controller.loadInterstitialAd();
                  controller.isAdLoaded = false;
                  controller.update();
                } else {
                  Fluttertoast.showToast(msg: "Ad is not loaded");
                  if (kDebugMode) {
                    print("Interstitial ad is not loaded yet.");
                  }
                }

                await Future.delayed(
                  const Duration(seconds: 2),
                      () {
                    CommonLoderUtils().stopLoading();
                    Get.toNamed(Routes.addNoteView);
                    controller.isAdLoaded = false;
                    controller.update();
                  },
                );
              }
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: ColorCodes.primaryGradientDiagonal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorCodes.purple.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.add,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}