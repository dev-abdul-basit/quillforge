import 'dart:async';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/Pref/share_pref.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/constants/app_strings.dart';

class PremiumController extends GetxController
    with GetSingleTickerProviderStateMixin {
  SharePrefService sharePrefService = SharePrefService();

  int selected = 0;

  bool isPremium = false;

  InAppPurchase inAppPurchase = InAppPurchase.instance;

  late StreamSubscription<dynamic> streamSubscription;

  Set<String> ids = Platform.isAndroid
      ? {
          androidInAppPurchaseIdWeekly,
          androidInAppPurchaseIdMonthly,
          androidInAppPurchaseIdYearly,
        }
      : {
          iOSInAppPurchaseIdWeekly,
          iOSInAppPurchaseIdMonthly,
          iOSInAppPurchaseIdYearly,
        };

  List<ProductDetails> products = [];

  @override
  void onInit() {
    getDate();

    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;

    streamSubscription = purchaseUpdated.listen(
      (purchaseList) {
        listenToPurchase(purchaseList);
      },
      onDone: () {
        streamSubscription.cancel();
      },
      onError: (error) {
        Fluttertoast.showToast(msg: "some thing went wrong");
      },
    );

    initStore();

    // TODO: implement onInit
    super.onInit();
  }

  List type = [
    AppStrings.Gpt4,
    AppStrings.socialAssistant,
    AppStrings.unlimited,
    AppStrings.adsFree,
  ];

  listenToPurchase(List<ProductDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach(
      (PurchaseDetails purchaseDetails) async {
            if (purchaseDetails.status == PurchaseStatus.pending) {
              Fluttertoast.showToast(msg: "pending");
            } else if (purchaseDetails.status == PurchaseStatus.error) {
              Fluttertoast.showToast(msg: "error");
            } else if (purchaseDetails.status == PurchaseStatus.purchased) {
              Fluttertoast.showToast(msg: "purchased");
            }
          }
          as void Function(ProductDetails element),
    );
  }

  initStore() async {
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    ProductDetailsResponse productDetailsResponse = await inAppPurchase
        .queryProductDetails(ids);
    if (productDetailsResponse.error == null) {
      if (kDebugMode) {
        print("loading Product$productDetailsResponse");
        print(productDetailsResponse.error);
        print("NotFoundIds ${productDetailsResponse.notFoundIDs}");
        print(productDetailsResponse.productDetails.length);
      }
      products = productDetailsResponse.productDetails;
      update();
    }
  }

  buy() {
    DateTime date = DateTime.now();

    DateTime monthLater = DateTime(date.year, date.month + 1, date.day);
    DateTime weekLater = DateTime(date.year, date.month, date.day + 7);
    DateTime yearLater = DateTime(date.year + 1, date.month, date.day);

    if (products.isNotEmpty) {
      final PurchaseParam param = PurchaseParam(
        productDetails: products[selected],
      );
      inAppPurchase.buyConsumable(purchaseParam: param);
      InAppPurchase.instance.purchaseStream.listen((event) {
        if (event[0].status == PurchaseStatus.purchased ||
            event[1].status == PurchaseStatus.purchased ||
            event[2].status == PurchaseStatus.purchased) {
          if (Platform.isIOS) {
            if (products[selected].id == iOSInAppPurchaseIdWeekly) {
            } else if (products[selected].id == iOSInAppPurchaseIdMonthly) {
            } else if (products[selected].id == iOSInAppPurchaseIdYearly) {}
          } else {
            if (products[selected].id == androidInAppPurchaseIdWeekly) {
              storeDate(weekLater.toString());
            } else if (products[selected].id == androidInAppPurchaseIdMonthly) {
              storeDate(monthLater.toString());
            } else if (products[selected].id == androidInAppPurchaseIdYearly) {
              storeDate(yearLater.toString());
            }
          }
        } else if (event[0].status == PurchaseStatus.canceled ||
            event[1].status == PurchaseStatus.canceled ||
            event[2].status == PurchaseStatus.canceled) {
          Fluttertoast.showToast(msg: "Something went wrong");
        }
      });
    } else {
      Fluttertoast.showToast(msg: "No products available for purchase");
    }
  }

  storeDate(String dateTime) async {
    await sharePrefService.addStringToSF(key: 'Premium_Date', value: dateTime);
    isPremium = true;
    Get.toNamed(Routes.homeView);
    update();
  }

  getDate() async {
    String premiumDate = await sharePrefService.getStringToSF(
      key: 'Premium_Date',
    );
    if (premiumDate.isNotEmpty) {
      DateTime fin = DateTime.parse(premiumDate);
      DateTime date = DateTime.now();
      DateTime time = DateTime(date.year, date.month, date.day);
      if (premiumDate != "") {
        if (time.compareTo(fin) < 0) {
          isPremium = true;
          update();
        } else {
          isPremium = false;
          update();
        }
      }
    }
  }

  void onSelected(index) {
    selected = index;
    update();
  }

  // Sorted products getter
  List<ProductDetails> get sortedProducts {
    if (products.isEmpty) return [];
    final sorted = List<ProductDetails>.from(products);
    sorted.sort((a, b) {
      return _getPlanOrder(a.id).compareTo(_getPlanOrder(b.id));
    });
    return sorted;
  }

  int _getPlanOrder(String id) {
    if (id.contains('weekly')) return 0;
    if (id.contains('monthly')) return 1;
    if (id.contains('yearly')) return 2;
    return 3;
  }

  bool isMonthlyPlan(String id) {
    return id.contains('monthly');
  }

  String getCleanTitle(String id) {
    if (id.contains('weekly')) return 'Weekly';
    if (id.contains('monthly')) return 'Monthly';
    if (id.contains('yearly')) return 'Yearly';
    return 'Premium';
  }

  String? getSavingsText(String id) {
    if (id.contains('monthly')) return 'Save 40% vs weekly';
    if (id.contains('yearly')) return 'Save 70% vs weekly';
    return null;
  }

  int getActualIndex(ProductDetails product) {
    return products.indexOf(product);
  }

  void restorePurchases() {
    inAppPurchase.restorePurchases();
  }

  void openTerms() async {
    final termsAndConditionUri = Uri.parse(termsAndConditionUrl);
    if (!await launchUrl(termsAndConditionUri)) {
      throw Exception('Could not launch $termsAndConditionUri');
    }
  }

  void openPrivacy() async {
    final privacyPolicyUri = Uri.parse(privacyPolicyUrl);
    if (!await launchUrl(privacyPolicyUri)) {
      throw Exception('Could not launch $privacyPolicyUri');
    }
  }

  @override
  void onClose() {
    streamSubscription.cancel();
    super.onClose();
  }
}
