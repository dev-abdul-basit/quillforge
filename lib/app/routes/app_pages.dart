import 'package:get/get.dart';
import 'package:ainotes/app/modules/Add_Note/binding/add_note_binding.dart';
import 'package:ainotes/app/modules/Add_Note/view/add_note_view.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/binding/ai_tools_response_binding.dart';
import 'package:ainotes/app/modules/Ai_Tools_Response/view/ai_tools_response_view.dart';
import 'package:ainotes/app/modules/FAQ/binding/faq_binding.dart';
import 'package:ainotes/app/modules/FAQ/view/faq_view.dart';
import 'package:ainotes/app/modules/Premium/binding/premium_binding.dart';
import 'package:ainotes/app/modules/Premium/view/premium_view.dart';
import 'package:ainotes/app/modules/Splash/binding/splash_binding.dart';
import 'package:ainotes/app/modules/Splash/view/splash_view.dart';
import 'package:ainotes/app/modules/ai_tool_create/binding/ai_tool_create_binding.dart';
import 'package:ainotes/app/modules/ai_tool_create/view/ai_tool_create_view.dart';
import 'package:ainotes/app/modules/ai_tools/binding/ai_tools_binding.dart';
import 'package:ainotes/app/modules/ai_tools/view/ai_tools_view.dart';
import 'package:ainotes/app/modules/favourite/binding/favourite_binding.dart';
import 'package:ainotes/app/modules/favourite/view/favourite_view.dart';
import 'package:ainotes/app/modules/generate_post/binding/generate_post_binding.dart';
import 'package:ainotes/app/modules/generate_post/view/generate_post_view.dart';
import 'package:ainotes/app/modules/home/binding/home_binding.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/modules/post_create/binding/post_create_binding.dart';
import 'package:ainotes/app/modules/post_create/view/post_create_view.dart';
import 'package:ainotes/app/modules/setting/binding/setting_binding.dart';
import 'package:ainotes/app/modules/setting/view/setting_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: Paths.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Paths.homeView,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Paths.settingView,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Paths.addNoteView,
      page: () => const AddNoteView(),
      binding: AddNoteBinding(),
    ),
    GetPage(
      name: Paths.premiumView,
      page: () => const PremiumView(),
      binding: PremiumBinding(),
    ),
    GetPage(
      name: Paths.favouriteView,
      page: () => const FavouriteView(),
      binding: FavouriteBinding(),
    ),
    GetPage(
      name: Paths.generatePostView,
      page: () => const GeneratePostView(),
      binding: GeneratePostBinding(),
    ),
    GetPage(
      name: Paths.postCreateView,
      page: () => const PostCreateView(),
      binding: PostCreateBinding(),
    ),
    GetPage(
      name: Paths.aiToolsView,
      page: () => const AiToolsView(),
      binding: AiToolsBinding(),
    ),
    GetPage(
      name: Paths.aiToolsResponseView,
      page: () => const AiToolsResponseView(),
      binding: AiToolsResponseBinding(),
    ),
    GetPage(
      name: Paths.aiToolCreateView,
      page: () => const AiToolCreateView(),
      binding: AiToolCreateBinding(),
    ),
    GetPage(
      name: Paths.faqView,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
  ];
}
