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
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'package:ainotes/app/common/constants/app_constants.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';
import 'package:ainotes/app/modules/favourite/controller/favourite_controller.dart';
import 'package:ainotes/app/modules/home/view/home_view.dart';
import 'package:ainotes/app/sql/sql_helper.dart';

class AddNoteController extends GetxController {
  // Focus Nodes
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();

  // Text Controllers
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController contentTextController = TextEditingController();
  final TextEditingController aiPromptController = TextEditingController();

  // Route Arguments
  Map<String, dynamic>? arguments = Get.arguments;
  int? noteId;
  String? noteTitle;
  String? noteDescription;
  bool? isFromFavourites;

  // Content Management
  String? noteContent;

  // AI Chat GPT States
  bool isAiChatVisible = false;
  bool isAiGenerating = false;
  String? aiGeneratedText;

  // Audio Recording States
  late AudioRecorder audioRecorder;
  bool isRecordingAudio = false;
  bool isProcessingAudio = false;
  String audioFilePath = '';
  String transcribedText = '';

  // Image Scanning States
  bool isScanningImage = false;
  bool isLoadingImage = false;
  XFile? selectedImage;
  String scannedImageText = '';

  @override
  void onInit() {
    super.onInit();
    _initializeOpenAI();
    _initializeAudioRecorder();
    _loadArgumentsFromRoute();
    _setupNoteContent();
  }

  void _initializeOpenAI() {
    OpenAI.apiKey = API_KEY;
  }

  void _initializeAudioRecorder() {
    audioRecorder = AudioRecorder();
  }

  void _loadArgumentsFromRoute() {
    if (arguments != null) {
      noteId = arguments!["id"];
      noteTitle = arguments!["title"];
      noteDescription = arguments!["description"];
      isFromFavourites = arguments!["isFavoriteScreen"];
    }
  }

  void _setupNoteContent() {
    if (noteId == null) {
      // New note
      noteContent = null;
      contentTextController.text = noteContent ?? '';
      _listenToContentChanges();
    } else {
      // Edit existing note
      titleTextController.text = noteTitle ?? '';
      noteContent = noteDescription ?? '';
      contentTextController.text = noteContent!;
      _listenToContentChanges();
      _setCursorToEnd();
    }
  }

  void _listenToContentChanges() {
    contentTextController.addListener(() {
      noteContent = contentTextController.text;
      update();
    });
  }

  void _setCursorToEnd() {
    contentTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: contentTextController.text.length),
    );
  }

  // ===== NOTE CRUD OPERATIONS =====

  Future<void> saveOrUpdateNote() async {
    if (titleTextController.text.isEmpty && contentTextController.text.isEmpty) {
      return;
    }

    if (noteId != null) {
      await _updateExistingNote();
    } else {
      await _createNewNote();
    }

    homeController.refreshData();

    if (isFromFavourites == true) {
      Get.find<FavouriteController>().refreshFavoriteNote();
    }
  }

  Future<void> _createNewNote() async {
    await SqlHelper.createNote(
      titleTextController.text.trim().isNotEmpty
          ? titleTextController.text.trim()
          : "Quick Note",
      contentTextController.text.trim(),
      DateFormat.yMEd().add_jms().format(DateTime.now()),
    );
  }

  Future<void> _updateExistingNote() async {
    await SqlHelper.updateNote(
      noteId!,
      titleTextController.text.trim().isNotEmpty
          ? titleTextController.text.trim()
          : "Quick Note",
      contentTextController.text.trim(),
    );
  }

  // ===== FOCUS MANAGEMENT =====

  void focusContentField() {
    contentFocusNode.requestFocus();
    update();
  }

  void unfocusAllFields() {
    FocusManager.instance.primaryFocus?.unfocus();
    update();
  }

  // ===== AI CHAT GPT OPERATIONS =====

  void showAiChat() {
    isAiChatVisible = true;
    update();
  }

  void hideAiChat() {
    isAiChatVisible = false;
    update();
  }

  Future<void> generateAiResponse({required String prompt}) async {
    final String trimmedPrompt = prompt.trim();
    aiPromptController.clear();
    unfocusAllFields();

    if (trimmedPrompt.isEmpty) return;

    try {
      isAiGenerating = true;
      update();

      if (premiumController.isPremium) {
        await _generateWithPremiumModel(trimmedPrompt);
      } else if (homeController.messageLimit > 0) {
        await _generateWithFreeModel(trimmedPrompt);
        homeController.decreaseMessageLimit();
      } else {
        aiGeneratedText = AppConstants.limitOver;
      }
    } catch (error) {
      _showErrorToast();
      if (kDebugMode) print("AI Generation Error: $error");
    } finally {
      isAiGenerating = false;
      update();
    }
  }

  Future<void> _generateWithPremiumModel(String prompt) async {
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
          role: OpenAIChatMessageRole.user,
        ),
      ],
      temperature: 0.2,
      maxTokens: 500,
    );

    aiGeneratedText = response.choices.first.message.content?.map((item) => item.text).join();
  }

  Future<void> _generateWithFreeModel(String prompt) async {
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
          role: OpenAIChatMessageRole.user,
        ),
      ],
      temperature: 0.2,
      maxTokens: 500,
    );

    aiGeneratedText = response.choices.first.message.content?.map((item) => item.text).join();
  }

  void insertTextIntoNote(String text) {
    noteContent = (noteContent ?? '') + text;
    contentTextController.text = noteContent!;
    _setCursorToEnd();
    Fluttertoast.showToast(msg: 'Inserted successfully');
    update();
  }

  // ===== AUDIO RECORDING OPERATIONS =====

  Future<void> startAudioRecording() async {
    try {
      final PermissionStatus micPermission = await Permission.microphone.request();

      if (micPermission.isGranted && await audioRecorder.hasPermission()) {
        final Directory appDirectory = await getApplicationDocumentsDirectory();
        final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        audioFilePath = '${appDirectory.path}/audio_$timestamp.m4a';

        await audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: audioFilePath,
        );

        isRecordingAudio = true;
        update();
      } else if (micPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    } catch (error) {
      if (kDebugMode) print("Start Recording Error: $error");
    }
  }

  Future<void> stopAudioRecording() async {
    try {
      final String? recordedPath = await audioRecorder.stop();

      if (recordedPath != null) {
        await _transcribeAudio(recordedPath);
      }

      isRecordingAudio = false;
      update();
    } catch (error) {
      if (kDebugMode) print("Stop Recording Error: $error");
    }
  }

  Future<void> _transcribeAudio(String audioPath) async {
    try {
      isProcessingAudio = true;
      update();

      if (premiumController.isPremium) {
        await _transcribeWithPremium(audioPath);
      } else if (homeController.messageLimit > 0) {
        await _transcribeWithFreeLimit(audioPath);
        homeController.decreaseMessageLimit();
      } else {
        transcribedText = AppConstants.limitOver;
      }
    } catch (error) {
      _showErrorToast();
      if (kDebugMode) print("Transcription Error: $error");
    } finally {
      isProcessingAudio = false;
      update();
    }
  }

  Future<void> _transcribeWithPremium(String audioPath) async {
    final transcription = await OpenAI.instance.audio.createTranscription(
      file: File(audioPath),
      model: "whisper-1",
      responseFormat: OpenAIAudioResponseFormat.json,
    );
    transcribedText = transcription.text;
  }

  Future<void> _transcribeWithFreeLimit(String audioPath) async {
    final transcription = await OpenAI.instance.audio.createTranscription(
      file: File(audioPath),
      model: "whisper-1",
      responseFormat: OpenAIAudioResponseFormat.json,
    );
    transcribedText = transcription.text;
  }

  // ===== IMAGE SCANNING OPERATIONS =====

  Future<void> pickImageFromGallery() async {
    final PermissionStatus permission = await _requestGalleryPermission();

    if (permission.isGranted) {
      await _pickImage(ImageSource.gallery);
    } else if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> pickImageFromCamera() async {
    final PermissionStatus permission = await Permission.camera.request();

    if (permission.isGranted) {
      await _pickImage(ImageSource.camera);
    } else if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<PermissionStatus> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = int.parse(androidInfo.version.release);
      return androidVersion >= 13
          ? await Permission.photos.request()
          : await Permission.storage.request();
    } else if (Platform.isIOS) {
      return await Permission.photos.request();
    }
    return PermissionStatus.denied;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      isLoadingImage = true;
      update();

      final XFile? pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        selectedImage = pickedFile;
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Failed to pick image");
      if (kDebugMode) print("Image Pick Error: $error");
    } finally {
      isLoadingImage = false;
      update();
    }
  }

  Future<void> extractTextFromImage(XFile? image) async {
    if (image == null) return;

    try {
      isScanningImage = true;
      update();

      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognizedText = await textRecognizer.processImage(
        InputImage.fromFilePath(image.path),
      );

      scannedImageText = recognizedText.text;

      if (scannedImageText.isEmpty) {
        Fluttertoast.showToast(
          msg: "No text found in image",
          backgroundColor: ColorCodes.red,
        );
      }
    } catch (error) {
      scannedImageText = 'Error occurred while scanning';
      if (kDebugMode) print("OCR Error: $error");
    } finally {
      isScanningImage = false;
      update();
    }
  }

  void clearImageData() {
    selectedImage = null;
    scannedImageText = '';
    isScanningImage = false;
    update();
  }

  void clearAudioData() {
    transcribedText = '';
    isRecordingAudio = false;
    isProcessingAudio = false;
    audioFilePath = '';
    update();
  }

  // ===== HELPER METHODS =====

  void _showErrorToast() {
    Fluttertoast.showToast(
      msg: "Something went wrong. Please try again.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 12.0,
    );
  }

  @override
  void onClose() {
    titleFocusNode.dispose();
    contentFocusNode.dispose();
    titleTextController.dispose();
    contentTextController.dispose();
    aiPromptController.dispose();
    audioRecorder.dispose();
    super.onClose();
  }
}


// class AddNoteController extends GetxController {
//   FocusNode focusNodeTitle = FocusNode();
//   FocusNode focusNode = FocusNode();
//
//   Map<String, dynamic>? arguments = Get.arguments;
//
//   /// Inser Below variable
//   String? data;
//
//   /// Arguments variables
//   int? id;
//   String? title;
//   String? description;
//   bool? isFavourite;
//
//   /// Chat Gpt
//   bool isChatGpt = false;
//   bool isChatGptResponse = false;
//   dynamic aiResponseText;
//
//   /// Voice Translation
//   late AudioRecorder audioRecord;
//   late String correctionAiResponse = '';
//   String? fromSelectedLanguage = "English";
//   String? toSelectedLanguage = "Hindi";
//   bool isLoading = false;
//   bool isRecording = false;
//   bool isAiResponse = false;
//   String audioPath = '';
//
//   /// Scanner Gallery And Camera variables
//   bool textScanning = false;
//   bool pickedImageValue = false;
//
//   XFile? imageFile;
//
//   String scannedText = "";
//
//   TextEditingController titleController = TextEditingController();
//   TextEditingController textController = TextEditingController();
//   TextEditingController chatGptController = TextEditingController();
//
//   @override
//   void onInit() {
//     OpenAI.apiKey = API_KEY;
//     audioRecord = AudioRecorder();
//
//     if (arguments != null) {
//       id = arguments!["id"];
//       title = arguments!["title"];
//       description = arguments!["description"];
//       isFavourite = arguments!["isFavoriteScreen"];
//     }
//
//     /// This will be call update Notes
//     if (id == null) {
//       data = null; // You can assign some initial value to data if you have one
//       textController = TextEditingController(text: data ?? '');
//       textController.addListener(() {
//         data = textController.text;
//         update();
//       });
//     } else {
//       titleController = TextEditingController(text: title);
//       // textController = TextEditingController(text: description);
//
//       data = null; // You can assign some initial value to data if you have one
//       textController = TextEditingController(text: data ?? "");
//       textController.addListener(() {
//         data = textController.text;
//         update();
//       });
//
//       data = (data ?? '') + description!;
//       textController.text = data!;
//       textController.selection = TextSelection.fromPosition(
//         TextPosition(offset: textController.text.length),
//       );
//     }
//
//     // TODO: implement onInit
//     super.onInit();
//
//     // focusNode.addListener(() {
//     //   if (kDebugMode) {
//     //     print('+++++++++++++++++++++++++++++ :  ${focusNode.hasFocus}');
//     //   }
//     // });
//   }
//
//   /// Get Message to Sql Flite
//   Future<void> getMessage() async {
//     if (id != null) {
//       final data = await SqlHelper.getNote(id!);
//
//       update();
//     }
//   }
//
//   /// updateNote to Sql Flite
//   Future<void> updateNote() async {
//     await SqlHelper.updateNote(
//         id!,
//         titleController.text.trim().isNotEmpty
//             ? titleController.text.trim()
//             : "Quick Note",
//         textController.text.trim());
//   }
//
//   /// createNote to Sql Flite
//   Future<void> createNote() async {
//     // DateTime now = DateTime.now();
//     // String formattedDate = DateFormat('EEEE, yyyy/MM/dd hh:mm a').format(now);
//
//     await SqlHelper.createNote(
//       titleController.text.trim().isNotEmpty
//           ? titleController.text.trim()
//           : "Quick Note",
//       textController.text.trim(),
//       DateFormat.yMEd().add_jms().format(DateTime.now()),
//     );
//   }
//
//   void focusToTextField() {
//     focusNode.requestFocus();
//     update();
//   }
//
//   void unfocusToTextField() {
//     FocusManager.instance.primaryFocus?.unfocus();
//     update();
//   }
//
//   void insertBelow(String response) {
//     data = (data ?? '') + response;
//     textController.text = data!;
//     textController.selection = TextSelection.fromPosition(
//       TextPosition(offset: textController.text.length),
//     );
//
//     Fluttertoast.showToast(msg: 'Inserted successful..');
//
//     update();
//   }
//
//   /// START RECORDING
//   /// START RECORDING
//   Future<void> startRecording() async {
//     try {
//       final PermissionStatus status = await Permission.microphone.request();
//
//       if (status.isGranted) {
//         if (await audioRecord.hasPermission()) {
//           // Generate a unique file path for the recording
//           final Directory appDir = await getApplicationDocumentsDirectory();
//           final String filePath = '${appDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
//
//           await audioRecord.start(
//             const RecordConfig(
//               encoder: AudioEncoder.aacLc,
//             ),
//             path: filePath,
//           );
//
//           audioPath = filePath;
//           isRecording = true;
//           update();
//         }
//       }
//
//       if (status.isDenied) {
//         if (kDebugMode) {
//           print("Denied");
//         }
//       }
//
//       if (status.isPermanentlyDenied) {
//         openAppSettings();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error Start Recording : $e");
//       }
//     }
//   }
//   /// STOP RECORDING
//   Future<void> stopRecording() async {
//     try {
//       String? path = await audioRecord.stop();
//
//       speechToText(path!);
//
//       isRecording = false;
//
//       update();
//     } catch (e) {
//       if (kDebugMode) {
//         print("Error stop Recording : $e");
//       }
//     }
//   }
//
//   /// Select Image gallery
//   void selectImageToGallery() async {
//     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     PermissionStatus permissionStatus;
//
//     if (Platform.isAndroid) {
//       final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       final int androidVersion = int.parse(androidInfo.version.release);
//
//       if (androidVersion >= 13) {
//         permissionStatus = await Permission.photos.request();
//       } else {
//         permissionStatus = await Permission.storage.request();
//       }
//     } else if (Platform.isIOS) {
//       permissionStatus = await Permission.photos.request();
//       if (!permissionStatus.isGranted) {
//         permissionStatus = await Permission.storage.request();
//       }
//     } else {
//       if (kDebugMode) {
//         print("Unsupported platform");
//       }
//
//       return;
//     }
//
//     if (permissionStatus.isGranted) {
//       try {
//         getImage(ImageSource.gallery);
//       } catch (e) {
//         if (kDebugMode) {
//           print("Error: $e");
//         }
//       }
//     }
//
//     if (permissionStatus.isDenied) {
//       if (kDebugMode) {
//         print("Denied");
//       }
//     }
//
//     if (permissionStatus.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
//
//   /// Select Image Camera
//   void selectImageToCamera() async {
//     final PermissionStatus permissionStatus = await Permission.camera.request();
//
//     if (permissionStatus.isGranted) {
//       try {
//         getImage(ImageSource.camera);
//       } catch (e) {
//         if (kDebugMode) {
//           print("Error: $e");
//         }
//       }
//     }
//
//     if (permissionStatus.isDenied) {
//       if (kDebugMode) {
//         print("Denied");
//       }
//     }
//
//     if (permissionStatus.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
//
//   /// Picked Image to gallery other wise camera
//   void getImage(ImageSource source) async {
//     try {
//       final pickedImage = await ImagePicker().pickImage(source: source);
//
//       if (pickedImage != null) {
//         pickedImageValue = true;
//
//         imageFile = pickedImage;
//
//         pickedImageValue = false;
//
//         update();
//       }
//     } catch (e) {
//       pickedImageValue = false;
//       imageFile = null;
//       update();
//
//       Fluttertoast.showToast(msg: "Something wrong..");
//     }
//   }
//
//   /// Speech to text convert
//   Future<void> speechToText(String audioPath) async {
//     try {
//       isLoading = true;
//       update();
//
//       if (premiumController.isPremium) {
//         final OpenAI openai = OpenAI.instance;
//
//         OpenAIAudioModel transcription = await openai.audio.createTranscription(
//           file: File(audioPath),
//           model: "whisper-1",
//           responseFormat: OpenAIAudioResponseFormat.json,
//         );
//
//         correctionAiResponse = transcription.text.toString();
//         isLoading = false;
//         update();
//       } else if (homeController.messageLimit > 0) {
//         final OpenAI openai = OpenAI.instance;
//
//         OpenAIAudioModel transcription = await openai.audio.createTranscription(
//           file: File(audioPath),
//           model: "whisper-1",
//           responseFormat: OpenAIAudioResponseFormat.json,
//         );
//
//         correctionAiResponse = transcription.text.toString();
//         homeController.decreaseMessageLimit();
//         isLoading = false;
//         update();
//       } else {
//         correctionAiResponse = AppConstants.limitOver;
//         isLoading = false;
//         update();
//       }
//     } catch (err) {
//       /// Show Error Toast USER
//       Fluttertoast.showToast(
//           msg: "Hmm...something seems to have gone wrong.",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           fontSize: 12.0);
//
//       /// Print Error debug mode
//       if (kDebugMode) {
//         print("ERROR $err");
//       }
//
//       isLoading = false;
//       update();
//     }
//   }
//
//   /// Image to convert text
//   void getImageToText(XFile? imagePath) async {
//     try {
//       textScanning = true;
//
//       final textRecognizer =
//       TextRecognizer(script: TextRecognitionScript.latin);
//       final RecognizedText recognizedText = await textRecognizer.processImage(
//         InputImage.fromFilePath(
//           imagePath!.path,
//         ),
//       );
//       scannedText = recognizedText.text.toString();
//
//       if (scannedText.isEmpty) {
//         Fluttertoast.showToast(
//           msg: "Error occurred while scanning",
//           backgroundColor: ColorCodes.red,
//         );
//       }
//
//       textScanning = false;
//       update();
//     } catch (e) {
//       textScanning = false;
//       update();
//       scannedText = 'Error occurred while scanning';
//     }
//   }
//
//   void chatGpt() {
//     isChatGpt = true;
//     update();
//   }
//
//   void onChangeValueGpt(value) {
//     chatGptController.text == value;
//
//     update();
//   }
//
//   void onChangeValueTitle(value) {
//     titleController.text == value;
//
//     update();
//   }
//
//   /// Send Response to ChatGpt
//   void sendMsg({required String text}) async {
//     //String text = controller.text.trim();
//     text = text.trim();
//     chatGptController.clear();
//     FocusManager.instance.primaryFocus?.unfocus();
//
//     try {
//       if (text.isNotEmpty) {
//         /// User Response ADD in List
//         // msgs.insert(0, MessageGPT4(true, text));
//
//         isChatGptResponse = true;
//         update();
//
//         if (premiumController.isPremium) {
//           final OpenAI openai = OpenAI.instance;
//
//           /// the user message that will be sent to the request.
//           final userMessage = OpenAIChatCompletionChoiceMessageModel(
//             content: [
//               OpenAIChatCompletionChoiceMessageContentItemModel.text(
//                 text,
//               ),
//             ],
//             role: OpenAIChatMessageRole.user,
//           );
//
//           final requestMessages = [
//             userMessage,
//           ];
//
//           /// the actual request.
//           OpenAIChatCompletionModel chatCompletion = await openai.chat.create(
//             model: "gpt-4o",
//             messages: requestMessages,
//             temperature: 0.2,
//             maxTokens: 500,
//           );
//
//           aiResponseText = chatCompletion.choices.first.message.content
//               ?.map((item) => item.text)
//               .join();
//
//           isChatGptResponse = false;
//           update();
//         } else if (homeController.messageLimit > 0) {
//           final OpenAI openai = OpenAI.instance;
//
//           /// the user message that will be sent to the request.
//           final userMessage = OpenAIChatCompletionChoiceMessageModel(
//             content: [
//               OpenAIChatCompletionChoiceMessageContentItemModel.text(
//                 text,
//               ),
//             ],
//             role: OpenAIChatMessageRole.user,
//           );
//
//           final requestMessages = [
//             userMessage,
//           ];
//
//           /// the actual request.
//           OpenAIChatCompletionModel chatCompletion = await openai.chat.create(
//             model: "gpt-4-turbo",
//             messages: requestMessages,
//             temperature: 0.2,
//             maxTokens: 500,
//           );
//
//           aiResponseText = chatCompletion.choices.first.message.content
//               ?.map((item) => item.text)
//               .join();
//
//           homeController.decreaseMessageLimit();
//           isChatGptResponse = false;
//           update();
//         } else {
//           aiResponseText = "${AppConstants.limitOver}";
//           isChatGptResponse = false;
//           update();
//         }
//       }
//     } catch (err) {
//       /// Show Error Toast USER
//       Fluttertoast.showToast(
//           msg: "Hmm...something seems to have gone wrong.",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           fontSize: 12.0);
//
//       /// Print Error debug mode
//       if (kDebugMode) {
//         print("ERROR $err");
//       }
//
//       isChatGptResponse = false;
//       update();
//     }
//   }
//
//   /// creteNote and Update Note in Sql Save button
//   void creteAndUpdateNote() {
//     if (titleController.text.isNotEmpty || textController.text.isNotEmpty) {
//       if (id != null) {
//         /// If id is not null, update the existing conversation
//         updateNote();
//
//         // homeController.refreshData();
//         // Get.find<FavouriteController>().refreshFavoriteNote();
//       } else {
//         /// If id is null, insert a new conversation
//         createNote();
//
//         // homeController.refreshData();
//         // Get.find<FavouriteController>().refreshFavoriteNote();
//       }
//
//       homeController.refreshData();
//
//       if (isFavourite == true) {
//         Get.find<FavouriteController>().refreshFavoriteNote();
//       }
//     }
//   }
//
//   @override
//   void onClose() {
//     focusNodeTitle.dispose();
//     focusNode.dispose();
//     audioRecord.dispose();
//
//     // TODO: implement onClose
//     super.onClose();
//   }
// }
