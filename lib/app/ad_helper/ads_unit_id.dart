import 'dart:io';

class AdsUnitIdHelper {
  static String get bannerUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("UnSupported Platform");
    }
  }

  static String get interstitialUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("UnSupported Platform");
    }
  }

  static String get rewardedUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw UnsupportedError("UnSupported Platform");
    }
  }
}
