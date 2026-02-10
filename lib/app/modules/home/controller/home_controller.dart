import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ainotes/app/Pref/share_pref.dart';
import 'package:ainotes/app/ad_helper/ads_unit_id.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/widgets/loding_utils.dart';
import 'package:ainotes/app/modules/home/widget/earn_reward_dialog_box.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:ainotes/app/sql/sql_helper.dart';

import '../../../common/constants/app_strings.dart';

class HomeController extends GetxController {
  SharePrefService sharePrefService = SharePrefService();

  TextEditingController searchController = TextEditingController();

  var filteredList = <Map<String, dynamic>>[].obs;
  var historyList = <Map<String, dynamic>>[].obs;

  /// Favourite
  bool isSearch = false;

  ///  Set Limit Message
  int messageLimit = 0;

  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  late RewardedAd rewardedAd;

  /// Google Ads Loaded variable
  bool isAdLoadedBanner = false;
  bool isAdLoaded = false;
  bool isAdLoadedRewarded = false;

  List aiTools = [
    AppStrings.generatePost,
    AppStrings.more,
  ];
  List aiToolsScreens = [
    Routes.generatePostView,
    Routes.aiToolsView,
  ];

  @override
  void onInit() {
    initBannerAd();
    getMessageLimit();
    fetchNotes();
    searchController.addListener(_onSearchChanged);

    // TODO: implement onInit
    super.onInit();
  }

  /// msg Limit set first time open app
  Future<void> getMessageLimit() async {
    int? getMessageSF = await sharePrefService.getIntToSF(key: "messageLimit");

    if (getMessageSF == null) {
      messageLimit = 5;
      sharePrefService.addIntToSF(key: "messageLimit", value: messageLimit);
    } else {
      messageLimit = getMessageSF;
    }
    update();
  }

  /// remove value to SharePref
  Future<void> removeLimit() async {
    sharePrefService.removeIntToSF(key: "messageLimit");

    /// Add value to SharePref  Set Limit
    await getMessageLimit();
  }

  void onTapToSearch() {
    isSearch = true;
    update();
  }

  void onTapToSearchBack() {
    isSearch = false;
    searchController.clear();
    update();
  }

  /// msg Limit Decrement
  Future<void> decreaseMessageLimit() async {
    if (messageLimit > 0) {
      messageLimit--;
      await sharePrefService.addIntToSF(
          key: "messageLimit", value: messageLimit);
      update();
    }
  }

  void refreshData() {
    fetchNotes();
    update();
  }

  void _onSearchChanged() {
    filterNotes(searchController.text);
    update();
  }

  Future<void> fetchNotes() async {
    final data = await SqlHelper.getNotes();

    historyList.value = data;

    filteredList.value = data;

    update();
  }

  void filterNotes(String query) {
    if (query.isEmpty) {
      filteredList.value = historyList!;
    } else {
      var lowerCaseQuery = query.trim().toLowerCase();
      filteredList.value = historyList!.where((element) {
        var title = element['title']?.toLowerCase() ?? '';
        var description = element['description']?.toLowerCase() ?? '';

        return title.contains(lowerCaseQuery) ||
            description.contains(lowerCaseQuery);
      }).toList();
    }
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    return filteredList; // Return the filtered list for the FutureBuilder
  }

  /// Delete Note to SQL FLITE
  Future<void> deleteNote(int id) async {
    await SqlHelper.deleteNote(id);
    refreshData();
    update();
  }

  /// Delete table to SQL FLITE
  Future<void> deleteNoteTable() async {
    await SqlHelper.deleteTAbleNote();
    refreshData();
    update();
  }

  /// Banner Ads show
  void initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdsUnitIdHelper.bannerUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdLoadedBanner = true;
          update();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (kDebugMode) {
            print("FAIL $error");
          }
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  /// initInterstitialAd Load
  void loadInterstitialAd() async {
    if (kDebugMode) {
      print("....START....");
    }

    CommonLoderUtils().startLoading();

    try {
      InterstitialAd.load(
        adUnitId: AdsUnitIdHelper.interstitialUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;

            isAdLoaded = true;
            update();

            ad.show();

            if (kDebugMode) {
              print("....STOP....");
            }

            interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();

                isAdLoaded = false;
                update();

                if (kDebugMode) {
                  print("AD IS DISMISSED");
                }
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                if (kDebugMode) {
                  print("onAdFailedToShowFullScreenContent ===>  $error");
                }

                isAdLoaded = false;
                update();
              },
            );

            //  LoadingUtils().stopLoading();
          },
          onAdFailedToLoad: (error) {
            interstitialAd.dispose();
            //  LoadingUtils().stopLoading();
            if (kDebugMode) {
              print("InterstitialAdLoadedError ===>  $error");
            }
          },
        ),
      );
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Ad Error ===> $e");
      }
    }
  }

  void loadRewardedAd(BuildContext context) {
    if (kDebugMode) {
      print("....START....");
    }

    CommonLoderUtils().startLoading();

    RewardedAd.load(
      adUnitId: AdsUnitIdHelper.rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isAdLoadedRewarded = true;
          update();

          ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            /// Loader Stop
            CommonLoderUtils().stopLoading();

            /// dialog Box off
            Get.back();

            congratulationDialogBox(
              context: context,
              collected: () async {
                ///  Remove value to sharePref  and getData call Then set value 5 limit
                await removeLimit();

                Get.back();
              },
            );
          });

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();

              isAdLoadedRewarded = false;
              update();

              if (kDebugMode) {
                print("AD IS DISMISSED");
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (kDebugMode) {
                print("onAdFailedToShowFullScreenContent ===>  $error");
              }
              isAdLoadedRewarded = false;
              update();
            },
          );

          isAdLoadedRewarded = true;
          update();
        },
        onAdFailedToLoad: (err) async {
          if (kDebugMode) {
            print('Failed to load a rewarded ad: ${err.message}');
          }

          await Future.delayed(
            const Duration(seconds: 5),
            () {
              /// Loader Stop
              CommonLoderUtils().stopLoading();

              Fluttertoast.showToast(
                msg: "Failed to load a ads..",
                toastLength: Toast.LENGTH_SHORT,
              );

              isAdLoadedRewarded = false;
              update();
            },
          );

          isAdLoadedRewarded = false;
          update();
        },
      ),
    );
  }

  Future<void> toggleFavorite(int noteId, int favorite) async {
    if (favorite == 1) {
      await SqlHelper.unmarkAsFavorite(noteId);
      favorite = 0;
      Fluttertoast.showToast(msg: AppStrings.favouriteRemove);
      update();
    } else {
      await SqlHelper.markAsFavorite(noteId);

      favorite = 1;
      Fluttertoast.showToast(msg: AppStrings.favouriteAdd);
      update();
    }
    fetchNotes();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
