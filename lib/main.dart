import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ainotes/app/routes/app_pages.dart';
import 'package:ainotes/app/theme/theme_controller/theme_controller.dart';
import 'package:ainotes/app/theme/theme_helper/theme_helper.dart';

import 'app/common/services/config_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();
  await dotenv.load();
  // Initialize remote config BEFORE runApp
  await ConfigService.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final ThemeController themeController = Get.put(ThemeController());


    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetBuilder<ThemeController>(
        builder: (themeController) {
          return GetMaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeController.isDarkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          );
        },
      ),
    );
  }
}
