import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/image_constants.dart';
import 'package:ainotes/app/common/widgets/loding_utils.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/routes/app_pages.dart';

class GeneratePostController extends GetxController {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int selectedSocialMediaType = 0;
  int selectedVoiceTone = 0;

  String selectedVoiceToneType = AppConstants.funny;
  String selectedSocialMedia = AppConstants.instagram;
  String? fromSelectedLanguage = "English";

  String? generatedResponse;

  @override
  void onInit() {
    OpenAI.apiKey = API_KEY;

    // TODO: implement onInit
    super.onInit();
  }

  List socialMediaPlatFormImage = [
    instagramIcon,
    facebookIcon,
    twitterIcon,
  ];
  List<String> socialMediaPlatFormType = [
    AppConstants.instagram,
    AppConstants.facebook,
    AppConstants.x,
  ];

  List<String> voiceToneType = [
    AppConstants.funny,
    AppConstants.serious,
    AppConstants.friendly,
    AppConstants.motivational,
    AppConstants.professional,
    AppConstants.objective,
    AppConstants.humorous,
  ];

  void sendMsg({required String text}) async {
    text = text.trim();
    // controller.clear();

    print("TEXT $text");

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      if (text.isNotEmpty) {
        /// User Response ADD in List

        await Future.delayed(const Duration(milliseconds: 100));

        /// Check MessageLimit was not zero
        if (premiumController.isPremium) {
          LoadingUtils().startLoadingGenerateAiResponse();
          update();

          final OpenAI openai = OpenAI.instance;

          /// the user message that will be sent to the request.
          final userMessage = OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "Generate in the $fromSelectedLanguage language, a social post caption about: $text. The voice tone is: $selectedVoiceToneType.",
              ),
            ],
            role: OpenAIChatMessageRole.user,
          );

          final requestMessages = [
            userMessage,
          ];

          /// the actual request.
          OpenAIChatCompletionModel chatCompletion = await openai.chat.create(
            model: gptModelGPTpt4OMini,
            messages: requestMessages,
            temperature: 0.2,
            maxTokens: 500,
          );

          var aiResponseText = chatCompletion.choices.first.message.content
              ?.map((item) => item.text)
              .join();

          LoadingUtils().stopLoading();
          generatedResponse = aiResponseText;
          update();

          /// Navigate Screen
          if (generatedResponse!.isNotEmpty) {
            Get.toNamed(
              Routes.postCreateView,
              arguments: {
                "PostType": selectedSocialMedia,
                "PostResponse": generatedResponse,
              },
            );
          }
        } else if (homeController.messageLimit > 0) {
          LoadingUtils().startLoadingGenerateAiResponse();
          update();

          final OpenAI openai = OpenAI.instance;

          /// the user message that will be sent to the request.
          final userMessage = OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "Generate in the $fromSelectedLanguage language, a social post caption about: $text. The voice tone is: $selectedVoiceToneType.",
              ),
            ],
            role: OpenAIChatMessageRole.user,
          );

          final requestMessages = [
            userMessage,
          ];

          /// the actual request.
          OpenAIChatCompletionModel chatCompletion = await openai.chat.create(
            // model: "gpt-3.5-turbo-1106",
            model: gptModelGPTpt4OMini,
            messages: requestMessages,
            temperature: 0.2,
            maxTokens: 500,
          );

          var aiResponseText = chatCompletion.choices.first.message.content
              ?.map((item) => item.text)
              .join();

          LoadingUtils().stopLoading();
          generatedResponse = aiResponseText;
          update();

          /// Navigate Screen
          if (generatedResponse!.isNotEmpty) {
            Get.toNamed(
              Routes.postCreateView,
              arguments: {
                "PostType": selectedSocialMedia,
                "PostResponse": generatedResponse,
              },
            );
          }

          /// MessageLimit DecreaseMessageLimit
          homeController.decreaseMessageLimit();
        } else {
          Fluttertoast.showToast(
              msg: AppConstants.limitOver,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              fontSize: 12.0);
        }
      }
    } catch (err) {
      /// Show Error Toast USER
      Fluttertoast.showToast(
          msg: "Hmm...something seems to have gone wrong.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 12.0);

      /// Print Error debug mode
      if (kDebugMode) {
        print("ERROR $err");
      }

      LoadingUtils().stopLoading();
      update();
    }
  }

  @override
  void onClose() {
    controller.dispose();
    // TODO: implement onClose
    super.onClose();
  }
}
