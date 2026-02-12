
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../models/remote_config_model.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  static ConfigService get instance => _instance;

  ConfigService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _configKey = 'remote_config_cache';
  static const String _remoteConfigUrl = 'https://developermatic.com/apps/quillforge/get-config.php';

  // IMPORTANT: Replace with your generated secret key
  // This should match the SECRET_KEY in get-config.php
  static const String _secretKey = '26df36f58b88e6f0a0689b4dadb8b4260f24327ffdfbd58bebe0184108efc0ea';

  RemoteConfigModel? _config;
  bool _isInitialized = false;

  /// Public getters
  String get apiKey => _config?.openaiApiKey ?? '';
  String get premiumChatModel => _config?.models.premiumChat ?? 'gpt-4o';
  String get freeChatModel => _config?.models.freeChat ?? 'gpt-4o-mini';
  String get audioModel => _config?.models.audioTranscription ?? 'whisper-1';
  int get freeDailyLimit => _config?.rateLimits.freeDailyMessages ?? 10;
  bool get isVisionEnabled => _config?.featureFlags.enableVision ?? true;
  bool get areSocialToolsEnabled => _config?.featureFlags.enableSocialMediaTools ?? true;
  bool get isInitialized => _isInitialized;

  /// Initialize config
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final cachedJson = await _secureStorage.read(key: _configKey);

      if (cachedJson != null) {
        final Map<String, dynamic> jsonData = jsonDecode(cachedJson);
        final cachedConfig = RemoteConfigModel.fromJson(jsonData);

        if (!cachedConfig.isExpired(cachedConfig.rateLimits.cacheExpiryHours)) {
          _config = cachedConfig;
          _isInitialized = true;
          if (kDebugMode) print('✓ Config loaded from secure cache');
          return;
        }
      }

      await _fetchRemoteConfig();
    } catch (e) {
      if (kDebugMode) print('⚠ Config initialization error: $e');
      _useFallbackConfig();
    }

    _isInitialized = true;
  }

  /// Generate HMAC signature
  String _generateSignature(String timestamp) {
    final key = utf8.encode(_secretKey);
    final bytes = utf8.encode(timestamp);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return digest.toString();
  }

  /// Fetch from remote with signed request
  Future<void> _fetchRemoteConfig() async {
    try {
      // Generate timestamp (Unix seconds)
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

      // Generate signature
      final signature = _generateSignature(timestamp);

      if (kDebugMode) {
        print('Fetching config with signed request...');
        print('Timestamp: $timestamp');
        print('Signature: $signature');
      }

      final response = await http.get(
        Uri.parse(_remoteConfigUrl),
        headers: {
          'X-Signature': signature,
          'X-Timestamp': timestamp,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        _config = RemoteConfigModel.fromJson(jsonData);

        await _secureStorage.write(
          key: _configKey,
          value: jsonEncode(_config!.toJson()),
        );

        if (kDebugMode) print('✓ Config fetched and cached from remote');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed - check timestamp sync');
      } else if (response.statusCode == 403) {
        throw Exception('Invalid signature - check SECRET_KEY matches');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded - try again later');
      } else {
        throw Exception('Remote config returned ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('⚠ Failed to fetch remote config: $e');
      _useFallbackConfig();
    }
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchRemoteConfig();
  }

  /// Fallback config (emergency only)
  void _useFallbackConfig() {
    if (kDebugMode) print('⚠ Using hardcoded fallback config');
    _config = RemoteConfigModel(
      version: '0.0.0-fallback',
      openaiApiKey: 'sk-proj-EMERGENCY_FALLBACK_KEY', // Replace with emergency key
      models: ConfigModels(
        premiumChat: 'gpt-4o',
        freeChat: 'gpt-4o-mini',
        audioTranscription: 'whisper-1',
      ),
      featureFlags: FeatureFlags(
        enableVision: true,
        enableSocialMediaTools: true,
      ),
      rateLimits: RateLimits(
        freeDailyMessages: 10,
        cacheExpiryHours: 24,
      ),
      fetchedAt: DateTime.now(),
    );
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _secureStorage.delete(key: _configKey);
    _config = null;
    _isInitialized = false;
    if (kDebugMode) print('✓ Config cache cleared');
  }
}