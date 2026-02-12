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
import 'package:ainotes/app/common/constants/app_strings.dart';

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
        aiGeneratedText = AppStrings.limitOver;
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
      model: OpenAIModels.premiumChatModel,
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
      model: OpenAIModels.freeChatModel,
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
        transcribedText = AppStrings.limitOver;
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
      model: OpenAIModels.audioTranscriptionModel,
      responseFormat: OpenAIAudioResponseFormat.json,
    );
    transcribedText = transcription.text;
  }

  Future<void> _transcribeWithFreeLimit(String audioPath) async {
    final transcription = await OpenAI.instance.audio.createTranscription(
      file: File(audioPath),
      model: OpenAIModels.audioTranscriptionModel,
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

