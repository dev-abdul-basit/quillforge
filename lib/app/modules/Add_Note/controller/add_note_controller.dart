import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/modules/favourite/controller/favourite_controller.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/sql/sql_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:record/record.dart';

class AddNoteController extends GetxController {
  FocusNode focusNodeTitle = FocusNode();
  FocusNode focusNode = FocusNode();

  Map<String, dynamic>? arguments = Get.arguments;

  /// Inser Below variable
  String? data;

  /// Arguments variables
  int? id;
  String? title;
  String? description;
  bool? isFavourite;

  /// Chat Gpt
  bool isChatGpt = false;
  bool isChatGptResponse = false;
  dynamic aiResponseText;

  /// Voice Translation
  //late Record audioRecord;
  late String correctionAiResponse = '';
  String? fromSelectedLanguage = "English";
  String? toSelectedLanguage = "Hindi";
  bool isLoading = false;
  bool isRecording = false;
  bool isAiResponse = false;
  String audioPath = '';

  /// Scanner Gallery And Camera variables
  bool textScanning = false;
  bool pickedImageValue = false;

  XFile? imageFile;

  String scannedText = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController chatGptController = TextEditingController();

  @override
  void onInit() {
    OpenAI.apiKey = API_KEY;
   // audioRecord = Record();

    if (arguments != null) {
      id = arguments!["id"];
      title = arguments!["title"];
      description = arguments!["description"];
      isFavourite = arguments!["isFavoriteScreen"];
    }

    /// This will be call update Notes
    if (id == null) {
      data = null; // You can assign some initial value to data if you have one
      textController = TextEditingController(text: data ?? '');
      textController.addListener(() {
        data = textController.text;
        update();
      });
    } else {
      titleController = TextEditingController(text: title);
      // textController = TextEditingController(text: description);

      data = null; // You can assign some initial value to data if you have one
      textController = TextEditingController(text: data ?? "");
      textController.addListener(() {
        data = textController.text;
        update();
      });

      data = (data ?? '') + description!;
      textController.text = data!;
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
    }

    // TODO: implement onInit
    super.onInit();

    // focusNode.addListener(() {
    //   if (kDebugMode) {
    //     print('+++++++++++++++++++++++++++++ :  ${focusNode.hasFocus}');
    //   }
    // });
  }

  /// Get Message to Sql Flite
  Future<void> getMessage() async {
    if (id != null) {
      final data = await SqlHelper.getNote(id!);

      update();
    }
  }

  /// updateNote to Sql Flite
  Future<void> updateNote() async {
    await SqlHelper.updateNote(
        id!,
        titleController.text.trim().isNotEmpty
            ? titleController.text.trim()
            : "Quick Note",
        textController.text.trim());
  }

  /// createNote to Sql Flite
  Future<void> createNote() async {
    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('EEEE, yyyy/MM/dd hh:mm a').format(now);

    await SqlHelper.createNote(
      titleController.text.trim().isNotEmpty
          ? titleController.text.trim()
          : "Quick Note",
      textController.text.trim(),
      DateFormat.yMEd().add_jms().format(DateTime.now()),
    );
  }

  void focusToTextField() {
    focusNode.requestFocus();
    update();
  }

  void unfocusToTextField() {
    FocusManager.instance.primaryFocus?.unfocus();
    update();
  }

  void insertBelow(String response) {
    data = (data ?? '') + response;
    textController.text = data!;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: textController.text.length),
    );

    Fluttertoast.showToast(msg: 'Inserted successful..');

    update();
  }

  /// START RECORDING
  Future<void> startRecording() async {
    try {
      final PermissionStatus status = await Permission.microphone.request();

      if (status.isGranted) {
        // if (await audioRecord.hasPermission()) {
        //   await audioRecord.start();
        //   isRecording = true;
        //   update();
        // }
      }

      if (status.isDenied) {
        if (kDebugMode) {
          print("Denied");
        }
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Start Recording : $e");
      }
    }
  }

  /// STOP RECORDING
  Future<void> stopRecording() async {
    try {
      // String? path = await audioRecord.stop();

      //speechToText(path);

      isRecording = false;

      update();
    } catch (e) {
      if (kDebugMode) {
        print("Error stop Recording : $e");
      }
    }
  }

  /// Select Image gallery
  void selectImageToGallery() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PermissionStatus permissionStatus;

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final int androidVersion = int.parse(androidInfo.version.release);

      if (androidVersion >= 13) {
        permissionStatus = await Permission.photos.request();
      } else {
        permissionStatus = await Permission.storage.request();
      }
    } else if (Platform.isIOS) {
      permissionStatus = await Permission.photos.request();
      if (!permissionStatus.isGranted) {
        permissionStatus = await Permission.storage.request();
      }
    } else {
      if (kDebugMode) {
        print("Unsupported platform");
      }

      return;
    }

    if (permissionStatus.isGranted) {
      try {
        getImage(ImageSource.gallery);
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
      }
    }

    if (permissionStatus.isDenied) {
      if (kDebugMode) {
        print("Denied");
      }
    }

    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// Select Image Camera
  void selectImageToCamera() async {
    final PermissionStatus permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      try {
        getImage(ImageSource.camera);
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
      }
    }

    if (permissionStatus.isDenied) {
      if (kDebugMode) {
        print("Denied");
      }
    }

    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// Picked Image to gallery other wise camera
  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);

      if (pickedImage != null) {
        pickedImageValue = true;

        imageFile = pickedImage;

        pickedImageValue = false;

        update();
      }
    } catch (e) {
      pickedImageValue = false;
      imageFile = null;
      update();

      Fluttertoast.showToast(msg: "Something wrong..");
    }
  }

  /// Speech to text convert
  Future<void> speechToText(String audioPath) async {
    try {
      isLoading = true;
      update();

      if (premiumController.isPremium) {
        final OpenAI openai = OpenAI.instance;

        OpenAIAudioModel transcription = await openai.audio.createTranscription(
          file: File(audioPath),
          model: "whisper-1",
          responseFormat: OpenAIAudioResponseFormat.json,
        );

        correctionAiResponse = transcription.text.toString();
        isLoading = false;
        update();
      } else if (homeController.messageLimit > 0) {
        final OpenAI openai = OpenAI.instance;

        OpenAIAudioModel transcription = await openai.audio.createTranscription(
          file: File(audioPath),
          model: "whisper-1",
          responseFormat: OpenAIAudioResponseFormat.json,
        );

        correctionAiResponse = transcription.text.toString();
        homeController.decreaseMessageLimit();
        isLoading = false;
        update();
      } else {
        correctionAiResponse = AppConstants.limitOver;
        isLoading = false;
        update();
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

      isLoading = false;
      update();
    }
  }

  /// Image to convert text
  void getImageToText(XFile? imagePath) async {
    try {
      textScanning = true;

      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        InputImage.fromFilePath(
          imagePath!.path,
        ),
      );
      scannedText = recognizedText.text.toString();

      if (scannedText.isEmpty) {
        Fluttertoast.showToast(
          msg: "Error occurred while scanning",
          backgroundColor: ColorCodes.red,
        );
      }

      textScanning = false;
      update();
    } catch (e) {
      textScanning = false;
      update();
      scannedText = 'Error occurred while scanning';
    }
  }

  void chatGpt() {
    isChatGpt = true;
    update();
  }

  void onChangeValueGpt(value) {
    chatGptController.text == value;

    update();
  }

  void onChangeValueTitle(value) {
    titleController.text == value;

    update();
  }

  /// Send Response to ChatGpt
  void sendMsg({required String text}) async {
    //String text = controller.text.trim();
    text = text.trim();
    chatGptController.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      if (text.isNotEmpty) {
        /// User Response ADD in List
        // msgs.insert(0, MessageGPT4(true, text));

        isChatGptResponse = true;
        update();

        if (premiumController.isPremium) {
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
            model: "gpt-4o",
            messages: requestMessages,
            temperature: 0.2,
            maxTokens: 500,
          );

          aiResponseText = chatCompletion.choices.first.message.content
              ?.map((item) => item.text)
              .join();

          isChatGptResponse = false;
          update();
        } else if (homeController.messageLimit > 0) {
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
            model: "gpt-4-turbo",
            messages: requestMessages,
            temperature: 0.2,
            maxTokens: 500,
          );

          aiResponseText = chatCompletion.choices.first.message.content
              ?.map((item) => item.text)
              .join();

          homeController.decreaseMessageLimit();
          isChatGptResponse = false;
          update();
        } else {
          aiResponseText = "${AppConstants.limitOver}";
          isChatGptResponse = false;
          update();
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

      isChatGptResponse = false;
      update();
    }
  }

  /// creteNote and Update Note in Sql Save button
  void creteAndUpdateNote() {
    if (titleController.text.isNotEmpty || textController.text.isNotEmpty) {
      if (id != null) {
        /// If id is not null, update the existing conversation
        updateNote();

        // homeController.refreshData();
        // Get.find<FavouriteController>().refreshFavoriteNote();
      } else {
        /// If id is null, insert a new conversation
        createNote();

        // homeController.refreshData();
        // Get.find<FavouriteController>().refreshFavoriteNote();
      }

      homeController.refreshData();

      if (isFavourite == true) {
        Get.find<FavouriteController>().refreshFavoriteNote();
      }
    }
  }

  @override
  void onClose() {
    focusNodeTitle.dispose();
    focusNode.dispose();
   // audioRecord.dispose();

    // TODO: implement onClose
    super.onClose();
  }
}
