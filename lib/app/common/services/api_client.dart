// lib/app/common/services/api_client.dart

import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'config_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  ApiClient._internal() {
    _initializeOpenAI();
  }

  void _initializeOpenAI() {
    OpenAI.apiKey = ConfigService.instance.apiKey;
    if (kDebugMode) print('✓ OpenAI initialized with remote API key');
  }

  /// Chat Completion (Premium)
  Future<String?> generateChatCompletionPremium({
    required String prompt,
    double temperature = 0.2,
    int maxTokens = 500,
  }) async {
    try {
      final response = await OpenAI.instance.chat.create(
        model: ConfigService.instance.premiumChatModel,
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        temperature: temperature,
        maxTokens: maxTokens,
      );

      return response.choices.first.message.content
          ?.map((item) => item.text)
          .join();
    } catch (e) {
      if (kDebugMode) print('API Error (Premium): $e');
      rethrow;
    }
  }

  /// Chat Completion (Free)
  Future<String?> generateChatCompletionFree({
    required String prompt,
    double temperature = 0.2,
    int maxTokens = 500,
  }) async {
    try {
      final response = await OpenAI.instance.chat.create(
        model: ConfigService.instance.freeChatModel,
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)
            ],
            role: OpenAIChatMessageRole.user,
          ),
        ],
        temperature: temperature,
        maxTokens: maxTokens,
      );

      return response.choices.first.message.content
          ?.map((item) => item.text)
          .join();
    } catch (e) {
      if (kDebugMode) print('API Error (Free): $e');
      rethrow;
    }
  }

  /// Audio Transcription
  Future<String> transcribeAudio({
    required File audioFile,
  }) async {
    try {
      final transcription = await OpenAI.instance.audio.createTranscription(
        file: audioFile,
        model: ConfigService.instance.audioModel,
        responseFormat: OpenAIAudioResponseFormat.json,
      );

      return transcription.text;
    } catch (e) {
      if (kDebugMode) print('Transcription Error: $e');
      rethrow;
    }
  }

  /// Refresh API key if config is updated
  void refreshApiKey() {
    OpenAI.apiKey = ConfigService.instance.apiKey;
    if (kDebugMode) print('✓ OpenAI API key refreshed');
  }
}