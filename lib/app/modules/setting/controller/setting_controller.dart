import 'dart:async';

import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingController extends GetxController {
  bool isShare = false;

  List<String> settings = [
    AppConstants.favourite,
    AppConstants.kFAQ,
    AppConstants.ratingUs,
    AppConstants.shareApp,
    AppConstants.privacyPolicy,
    AppConstants.termsAndConditions,
  ];

  void onShareAppLink() {
    if (isShare == false) {
      Share.share('Gpt Note Share Demo');
      isShare = true;
      Timer(const Duration(seconds: 1), () {
        isShare = false;
      });
      update();
    }
  }

  /// Url Privacy Policy
  void launchURLPrivacyPolicy() async {
    final privacyPolicyUri = Uri.parse(privacyPolicyUrl);
    if (!await launchUrl(privacyPolicyUri)) {
      throw Exception('Could not launch $privacyPolicyUri');
    }
  }

  /// Url Terms And Condition
  void launchURLTermsAndCondition() async {
    final termsAndConditionUri = Uri.parse(termsAndConditionUrl);
    if (!await launchUrl(termsAndConditionUri)) {
      throw Exception('Could not launch $termsAndConditionUri');
    }
  }

  void navigateToScreen(int index) {
    if (index == 0) {
      Get.toNamed(Routes.favouriteView);
    } else if (index == 1) {
      Get.toNamed(Routes.faqView);
    } else if (index == 2) {
    } else if (index == 3) {
      onShareAppLink();
    } else if (index == 4) {
      return launchURLPrivacyPolicy();
    } else if (index == 5) {
      return launchURLTermsAndCondition();
    }
  }
}
