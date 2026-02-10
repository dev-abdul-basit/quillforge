import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/lists/ai_tools_list.dart';
import 'package:ainotes/app/common/widgets/loding_utils.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/routes/app_pages.dart';

import '../../../common/constants/app_strings.dart';

class AiToolsResponseController extends GetxController {
  Map<String, dynamic>? arguments = Get.arguments;
  TextEditingController subheadingsController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController titledController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController domainsController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int selectedSocialMediaType = 0;
  int selectedVoiceTone = 0;

  String selectedVoiceToneType = AppStrings.funny;
  String? fromSelectedLanguage = "English";
  String dropdownValue = 'Small';
  String? selectedLength;

  String? generatedResponse;

  /// Arguments variables
  String? title;
  String? info;
  String? prompt;
  String? category;
  bool? language;
  bool? subheadings;
  bool? keywords;
  bool? length;
  bool? product;
  bool? description;
  // bool? audience;
  bool? tone;
  bool? name;
  bool? titled;
  bool? company;
  bool? subject;
  bool? position;
  bool? domains;
  bool? content;

  @override
  void onInit() {
    OpenAI.apiKey = API_KEY;

    if (arguments != null) {
      title = arguments!["title"];
      info = arguments!["info"];
      prompt = arguments!["prompt"];
      category = arguments!["category"];
      language = arguments!["language"];
      subheadings = arguments!["subheadings"];
      keywords = arguments!["keywords"];
      length = arguments!["length"];
      product = arguments!["product"];
      description = arguments!["description"];
      //  audience = arguments!["audience"];
      tone = arguments!["tone"];
      name = arguments!["name"];
      titled = arguments!["titled"];
      company = arguments!["company"];
      subject = arguments!["subject"];
      position = arguments!["position"];
      domains = arguments!["domains"];
      content = arguments!["content"];
    }

    // TODO: implement onInit
    super.onInit();
  }

  Map<String, dynamic> items = {
    'Small': "20-50",
    'Medium': "51-100",
    'Large': "101-200",
  };

  List<String> voiceToneType = [
    AppStrings.funny,
    AppStrings.serious,
    AppStrings.friendly,
    AppStrings.motivational,
    AppStrings.professional,
    AppStrings.objective,
    AppStrings.humorous,
  ];

  String generatePrompt({
    required String language,
    required String product,
    required String tone,
    //  required String audience,
    required String description,
    required String keywords,
    required String length,
    required String name,
    required String titled,
    required String company,
    required String subject,
    required String position,
    required String domains,
    required String content,
    required String subheadings,
  }) {
    // Selecting the first tool under the "website" category, assuming it's the "About us" tool
    Map<String, dynamic>? selectedTool = aiTools.firstWhere(
      (tool) => tool['Category'] == "$category",
      //  orElse: () => null,
    );

    if (selectedTool != null &&
        selectedTool['SubCategory'] != null &&
        selectedTool['SubCategory'].isNotEmpty) {
      Map<String, dynamic>? aboutUsTool =
          selectedTool['SubCategory'].firstWhere(
        (subTool) => subTool['Title'] == "$title",
        //orElse: () => null,
      );
      if (aboutUsTool != null && aboutUsTool['prompt'] != null) {
        // Replace placeholders in the prompt with actual values
        String prompt = aboutUsTool['prompt']
            .replaceAll(':language', language)
            .replaceAll(':product', product)
            .replaceAll(':tone', tone)
            // .replaceAll(':audience', audience)
            .replaceAll(':description', description)
            .replaceAll(':keywords', keywords)
            .replaceAll(':length', length)
            .replaceAll(':name', name)
            .replaceAll(':title', titled)
            .replaceAll(':company', company)
            .replaceAll(':subject', subject)
            .replaceAll(':position', position)
            .replaceAll(':domains', domains)
            .replaceAll(':content', content)
            .replaceAll(':subheadings', subheadings);

        return prompt;
      }
    }

    return ''; // Return empty string or handle error if tool or prompt not found
  }

  void sendMsg({required String text}) async {
    text = text.trim();
    // controller.clear();

    FocusManager.instance.primaryFocus?.unfocus();

    try {
      if (text.isNotEmpty) {
        /// User Response ADD in List

        await Future.delayed(const Duration(milliseconds: 100));

        /// Check MessageLimit was not zero
        if (premiumController.isPremium) {
          CommonLoderUtils().startLoadingGenerateAiResponse();
          update();

          final OpenAI openai = OpenAI.instance;

          /// the user message that will be sent to the request.
          final userMessage = OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                text,
              ),
            ],
            role: OpenAIChatMessageRole.user,
          );

          final requestMessages = [
            userMessage,
          ];

          /// the actual request.
          OpenAIChatCompletionModel chatCompletion = await openai.chat.create(
            model: "gpt-3.5-turbo-1106",
            messages: requestMessages,
            temperature: 0.2,
            maxTokens: 500,
          );

          var aiResponseText = chatCompletion.choices.first.message.content
              ?.map((item) => item.text)
              .join();

          CommonLoderUtils().stopLoading();
          generatedResponse = aiResponseText;

          update();

          /// Navigate Screen
          if (generatedResponse!.isNotEmpty) {
            Get.toNamed(
              Routes.aiToolCreateView,
              arguments: {
                "title": title,
                "AiToolsResponse": generatedResponse,
              },
            );
          }
        } else if (homeController.messageLimit > 0) {
          CommonLoderUtils().startLoadingGenerateAiResponse();
          update();

          final OpenAI openai = OpenAI.instance;

          /// the user message that will be sent to the request.
          final userMessage = OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                text,
              ),
            ],
            role: OpenAIChatMessageRole.user,
          );

          final requestMessages = [
            userMessage,
          ];

          /// the actual request.
          OpenAIChatCompletionModel chatCompletion = await openai.chat.create(
            model: "gpt-3.5-turbo-1106",
            messages: requestMessages,
            temperature: 0.2,
            maxTokens: 500,
          );

          var aiResponseText = chatCompletion.choices.first.message.content
              ?.map((item) => item.text)
              .join();

          CommonLoderUtils().stopLoading();
          generatedResponse = aiResponseText;
          update();

          /// Navigate Screen
          if (generatedResponse!.isNotEmpty) {
            Get.toNamed(
              Routes.aiToolCreateView,
              arguments: {
                "title": title,
                "AiToolsResponse": generatedResponse,
              },
            );
          }

          /// MessageLimit DecreaseMessageLimit
          homeController.decreaseMessageLimit();
        } else {
          Fluttertoast.showToast(
              msg: AppStrings.limitOver,
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

      CommonLoderUtils().stopLoading();
      update();
    }
  }

  @override
  void onClose() {
    subheadingsController.dispose();
    keywordsController.dispose();
    productController.dispose();
    descriptionController.dispose();
    nameController.dispose();
    titledController.dispose();
    companyController.dispose();
    subjectController.dispose();
    positionController.dispose();
    domainsController.dispose();
    contentController.dispose();
    // TODO: implement onClose
    super.onClose();
  }
}
