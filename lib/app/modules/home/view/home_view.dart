import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/common/constants/font_family_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/app_bar.dart';
import 'package:ainotes/app/common/widgets/container_widget.dart';
import 'package:ainotes/app/common/widgets/empty_data_widget.dart';
import 'package:ainotes/app/common/widgets/icon_widget.dart';
import 'package:ainotes/app/common/widgets/loding_utils.dart';
import 'package:ainotes/app/common/widgets/no_search_result_widget.dart';
import 'package:ainotes/app/common/widgets/text_field_widget.dart';
import 'package:ainotes/app/common/widgets/text_widget.dart';
import 'package:ainotes/app/modules/Premium/controller/premium_controller.dart';
import 'package:ainotes/app/modules/home/controller/home_controller.dart';
import 'package:ainotes/app/modules/home/widget/delete_note_dialogbox.dart';
import 'package:ainotes/app/modules/home/widget/earn_reward_dialog_box.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/constants/app_strings.dart';

final HomeController homeController = Get.put(HomeController());
final PremiumController premiumController = Get.put(PremiumController());

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GetBuilder<HomeController>(
          builder: (controller) {
            return CommonAppBar(
              color: Theme.of(context).colorScheme.secondaryContainer,
              titleSpacing: 0.0,
              title: controller.isSearch == false
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: SizedBox(
                        height: 45,
                        child: CommonTextField(
                          onTap: () => controller.onTapToSearch(),
                          fillColor: Theme.of(context).colorScheme.background,
                          maxWidth: double.infinity,
                          hintText: AppStrings.searched,
                          hintStyle: const TextStyle(
                            fontFamily: roboto,
                            color: ColorCodes.grey,
                            fontSize: 15,
                          ),
                          minHeight: 30,
                          borderRadius: 12,
                          enabledBorderRadius: 15,
                          focusedBorderRadius: 15,
                          readOnly: true,
                          prefixIcon: const CommonmIcon(
                            icon: Icons.search,
                            size: 20,
                            color: ColorCodes.grey,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 15, right: 5),
                      child: SizedBox(
                        height: 45,
                        child: CommonTextField(
                          controller: controller.searchController,
                          fillColor: Theme.of(context).colorScheme.background,
                          maxWidth: double.infinity,
                          hintText: AppStrings.searched,
                          maxLines: 1,
                          hintStyle: const TextStyle(
                            fontFamily: roboto,
                            color: ColorCodes.grey,
                            fontSize: 15,
                          ),
                          minHeight: 30,
                          borderRadius: 14,
                          enabledBorderRadius: 10,
                          focusedBorderRadius: 10,
                          prefixIcon: const CommonmIcon(
                            icon: Icons.search,
                            size: 20,
                            color: ColorCodes.grey,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              controller.searchController.clear();
                            },
                            child: const CommonmIcon(
                              icon: Icons.clear,
                              color: ColorCodes.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
              actions: [
                controller.isSearch == false
                    ? Row(
                        children: [
                          premiumController.isPremium == true
                              ? SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    if (controller.messageLimit == 0) {
                                      watchAdsEarnRewardDialogBox(
                                        context: context,
                                        watchAdsOnTap: () async {
                                          if (controller.isAdLoadedRewarded ==
                                              false) {
                                            ///   initInterstitialAd  load
                                            controller.loadRewardedAd(context);

                                            controller.isAdLoadedRewarded ==
                                                false;
                                            controller.update();
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "ads is not loaded",
                                            );
                                            print(
                                              "Interstitial ad is not loaded yet.",
                                            );
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: GetBuilder<HomeController>(
                                    builder: (controller) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Stack(
                                          children: [
                                            CommonContainer(
                                              width: 40,
                                              height: 45,
                                              backgroundColor:
                                                  ColorCodes.orange,
                                              radius: 12,
                                              containerChild: Center(
                                                child: CommonText(
                                                  text: controller.messageLimit
                                                      .toString(),
                                                  fontSize: 15,
                                                  fontFamily: montserratRegular,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              shinesIcon,
                                              color: ColorCodes.white,
                                              height: 18,
                                              width: 18,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.settingView);
                            },
                            child: CommonContainer(
                              width: 40,
                              height: 45,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.background,
                              radius: 12,
                              containerChild: Center(
                                child: CommonmIcon(
                                  icon: Icons.settings,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () => controller.onTapToSearchBack(),
                        child: CommonContainer(
                          radius: 12,
                          containerChild:  Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.5,
                              horizontal: 15,
                            ),
                            child: Text(
                              AppStrings.cancel,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(width: 10.w),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
        builder: (controller) {
          return premiumController.isPremium == true
              ? SizedBox()
              : controller.isSearch == false
              ? Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: controller.isAdLoadedBanner
                      ? SizedBox(
                          height: controller.bannerAd.size.height.toDouble(),
                          width: controller.bannerAd.size.width.toDouble(),
                          child: AdWidget(ad: controller.bannerAd),
                        )
                      : const SizedBox(),
                )
              : const SizedBox();
        },
      ),
      floatingActionButton: GetBuilder<HomeController>(
        builder: (controller) {
          return controller.isSearch == false
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () async {
                          if (premiumController.isPremium) {
                            Get.toNamed(Routes.addNoteView);
                          } else {
                            if (controller.isAdLoaded == false) {
                              ///   initInterstitialAd  load
                              controller.loadInterstitialAd();

                              controller.isAdLoaded = false;
                              controller.update();
                            } else {
                              Fluttertoast.showToast(msg: "ads is not loaded");
                              if (kDebugMode) {
                                print("Interstitial ad is not loaded yet.");
                              }
                            }

                            await Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                CommonLoderUtils().stopLoading();

                                /// Navigate Screen
                                Get.toNamed(Routes.addNoteView);

                                controller.isAdLoaded = false;
                                controller.update();
                              },
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: ColorCodes.purple,
                        foregroundColor: ColorCodes.purple,
                        child: const CommonmIcon(
                          icon: Icons.add,
                          size: 30,
                          color: ColorCodes.white,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
      body: RefreshIndicator(
        color: ColorCodes.purple,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            controller.refreshData();
            controller.getNotes();
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<HomeController>(
                  builder: (controller) {
                    return controller.isSearch
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              CommonText(
                                text: AppStrings.aiTools,
                                fontWeight: FontWeight.bold,
                                fontFamily: poppins,
                                fontColor: Theme.of(context).colorScheme.onSurface,
                                fontSize: 17,
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                height: 85,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.aiTools.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          controller.aiToolsScreens[index],
                                        );
                                      },
                                      child: Card(
                                        elevation: 0.5,
                                        child: Container(
                                          height: 85,
                                          width: index == 0
                                              ? width * 0.40
                                              : width * 0.168,
                                          decoration: BoxDecoration(
                                            color: ColorCodes.background,
                                            borderRadius: BorderRadius.circular(
                                              radius,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 17,
                                              vertical: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Spacer(),
                                                index == 0
                                                    ? Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 16,
                                                            backgroundColor:
                                                                ColorCodes
                                                                    .background,
                                                            backgroundImage:
                                                                const AssetImage(
                                                                  instagramIcon,
                                                                ),
                                                          ),
                                                          Positioned(
                                                            right: -23,
                                                            child: CircleAvatar(
                                                              radius: 16,
                                                              backgroundColor:
                                                                  ColorCodes
                                                                      .background,
                                                              child: const CircleAvatar(
                                                                radius: 14,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                      facebookIcon,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: -45,
                                                            child: CircleAvatar(
                                                              radius: 16,
                                                              backgroundColor:
                                                                  ColorCodes
                                                                      .background,
                                                              child: const CircleAvatar(
                                                                radius: 14,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                      twitterIcon,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Image.asset(
                                                        moreIcon,
                                                        height: 22,
                                                        color:
                                                        Theme.of(context).colorScheme.onSurface,
                                                      ),
                                                const Spacer(),
                                                CommonText(
                                                  text:
                                                      controller.aiTools[index],
                                                  fontColor: Theme.of(context).colorScheme.onSurface
                                                      .withOpacity(0.7),
                                                  fontSize: 11,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonText(
                      text: AppStrings.quickNote,
                      fontWeight: FontWeight.bold,
                      fontFamily: poppins,
                      fontColor: Theme.of(context).colorScheme.onSurface,
                      fontSize: 17,
                    ),
                    const Spacer(),
                    GetBuilder<HomeController>(
                      builder: (controller) {
                        if (controller.historyList.isEmpty) {
                          return const SizedBox();
                        } else {
                          return GestureDetector(
                            onTap: () {
                              deleteDialogBox(
                                onConfirm: () {
                                  controller.deleteNoteTable();
                                  Get.back();
                                },
                                titleText: AppStrings.clearAllNotes,
                              );
                            },
                            child:  Text(
                              AppStrings.clearAll,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontFamily: poppins,
                                fontSize: 12.5,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                GetBuilder<HomeController>(
                  builder: (controller) {
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: controller.getNotes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              controller.isSearch == false) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorCodes.purple,
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              child: controller.isSearch == false
                                  ? const Center(child: NoHistoryWidget())
                                  : const Center(child: NoSearchFoundWidget()),
                            );
                          }
                        } else {
                          final data = snapshot.data!;

                          /// DATA SHOW REVERSE
                          final reversedData = data.reversed.toList();

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reversedData.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 220,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                ),
                            itemBuilder: (context, index) {
                              /// Change Date Formate
                              String createdAt =
                                  reversedData[index]["createdAt"] ?? "";

                              DateTime dateTime = DateFormat(
                                "EEE, M/d/yyyy hh:mm:ss a",
                              ).parse(createdAt);
                              String formattedDate = DateFormat(
                                "EEE, yyyy/MM/dd hh:mm a",
                              ).format(dateTime);

                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.addNoteView,
                                    arguments: {
                                      "id": reversedData[index]["id"],
                                      "title": reversedData[index]["title"],
                                      "description":
                                          reversedData[index]["description"],
                                    },
                                  );
                                },
                                child: Card(
                                  elevation: 0.5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(radius),
                                  ),
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: ColorCodes.background,
                                      borderRadius: BorderRadius.circular(
                                        radius,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 4,
                                        top: 4,
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CommonText(
                                                  text:
                                                      reversedData[index]["title"] ??
                                                      "",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: poppins,
                                                  fontSize: 14,
                                                  fontColor: ColorCodes.primary
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                              GetBuilder<HomeController>(
                                                builder: (controller) {
                                                  return SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        controller.toggleFavorite(
                                                          reversedData[index]["id"],
                                                          reversedData[index]["favorite"],
                                                        );
                                                      },
                                                      icon: CommonmIcon(
                                                        icon:
                                                            reversedData[index]["favorite"] ==
                                                                1
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        size: 18,
                                                        color:
                                                            reversedData[index]["favorite"] ==
                                                                1
                                                            ? ColorCodes.orange
                                                            : ColorCodes
                                                                  .blueGray,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    deleteDialogBox(
                                                      onConfirm: () {
                                                        controller.deleteNote(
                                                          reversedData[index]["id"],
                                                        );
                                                        Get.back();
                                                      },
                                                      titleText:
                                                          AppStrings.deleteNote,
                                                    );
                                                  },
                                                  icon: const CommonmIcon(
                                                    icon: Icons.delete,
                                                    size: 18,
                                                    color: ColorCodes.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
                                          Divider(
                                            height: 0,
                                            thickness: 0.4,
                                            endIndent: 6,
                                            color: ColorCodes.grey.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                          SizedBox(height: 15.h),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 6,
                                            ),
                                            child: CommonText(
                                              text:
                                                  reversedData[index]["description"] ??
                                                  "",
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: poppins,
                                              fontSize: 8,
                                              maxLines: 11,
                                              fontColor: ColorCodes.primary
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              CommonmIcon(
                                                icon: Icons
                                                    .access_time_filled_rounded,
                                                size: 12,
                                                color: ColorCodes.primary
                                                    .withOpacity(0.4),
                                              ),
                                              SizedBox(width: 3.w),
                                              CommonText(
                                                text: formattedDate.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: poppins,
                                                fontSize: 9.sp,
                                                maxLines: 1,
                                                fontColor: ColorCodes.primary
                                                    .withOpacity(0.4),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
