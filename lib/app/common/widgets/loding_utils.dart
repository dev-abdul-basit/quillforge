import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';

import '../constants/app_strings.dart';

class CommonLoderUtils {
  Future<void> startLoading() async {
    return Get.dialog(
      barrierDismissible: false,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              decoration: BoxDecoration(
                color: ColorCodes.background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Material(
                  color: ColorCodes.background,
                  child: Column(
                    children: [
                      const SpinKitPouringHourGlass(
                        color: ColorCodes.purple,
                        duration: Duration(milliseconds: 900),
                        strokeWidth: 2,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        "Please Wait",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        "Ad showing in a few seconds",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> stopLoading() async {
    Get.back();
  }

  Future<void> startLoadingGenerateAiResponse() async {
    return Get.dialog(
      barrierDismissible: false,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              decoration: BoxDecoration(
                color: ColorCodes.background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Material(
                  color: ColorCodes.background,
                  child: Column(
                    children: [
                      const SpinKitPouringHourGlass(
                        color: ColorCodes.purple,
                        duration: Duration(milliseconds: 900),
                        strokeWidth: 2,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        "Please Wait",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        AppStrings.preparedResponse,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Future<void> showError(Object? error) async {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       action: SnackBarAction(
//         label: 'Dismiss',
//         onPressed: () {
//           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         },
//       ),
//       backgroundColor: Colors.red,
//       content: const Text("demo"),
//     ),
//   );
// }
}
