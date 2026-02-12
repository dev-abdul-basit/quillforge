// lib/app/common/models/remote_config_model.dart

class RemoteConfigModel {
  final String version;
  final String openaiApiKey;
  final ConfigModels models;
  final FeatureFlags featureFlags;
  final RateLimits rateLimits;
  final DateTime fetchedAt;

  RemoteConfigModel({
    required this.version,
    required this.openaiApiKey,
    required this.models,
    required this.featureFlags,
    required this.rateLimits,
    required this.fetchedAt,
  });

  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    return RemoteConfigModel(
      version: json['version'] as String,
      openaiApiKey: json['openai_api_key'] as String,
      models: ConfigModels.fromJson(json['models'] as Map<String, dynamic>),
      featureFlags: FeatureFlags.fromJson(json['feature_flags'] as Map<String, dynamic>),
      rateLimits: RateLimits.fromJson(json['rate_limits'] as Map<String, dynamic>),
      fetchedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'openai_api_key': openaiApiKey,
      'models': models.toJson(),
      'feature_flags': featureFlags.toJson(),
      'rate_limits': rateLimits.toJson(),
      'fetched_at': fetchedAt.toIso8601String(),
    };
  }

  bool isExpired(int cacheExpiryHours) {
    return DateTime.now().difference(fetchedAt).inHours >= cacheExpiryHours;
  }
}

class ConfigModels {
  final String premiumChat;
  final String freeChat;
  final String audioTranscription;

  ConfigModels({
    required this.premiumChat,
    required this.freeChat,
    required this.audioTranscription,
  });

  factory ConfigModels.fromJson(Map<String, dynamic> json) {
    return ConfigModels(
      premiumChat: json['premium_chat'] as String,
      freeChat: json['free_chat'] as String,
      audioTranscription: json['audio_transcription'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'premium_chat': premiumChat,
      'free_chat': freeChat,
      'audio_transcription': audioTranscription,
    };
  }
}

class FeatureFlags {
  final bool enableVision;
  final bool enableSocialMediaTools;

  FeatureFlags({
    required this.enableVision,
    required this.enableSocialMediaTools,
  });

  factory FeatureFlags.fromJson(Map<String, dynamic> json) {
    return FeatureFlags(
      enableVision: json['enable_vision'] as bool? ?? true,
      enableSocialMediaTools: json['enable_social_media_tools'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable_vision': enableVision,
      'enable_social_media_tools': enableSocialMediaTools,
    };
  }
}

class RateLimits {
  final int freeDailyMessages;
  final int cacheExpiryHours;

  RateLimits({
    required this.freeDailyMessages,
    required this.cacheExpiryHours,
  });

  factory RateLimits.fromJson(Map<String, dynamic> json) {
    return RateLimits(
      freeDailyMessages: json['free_daily_messages'] as int? ?? 10,
      cacheExpiryHours: json['cache_expiry_hours'] as int? ?? 24,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'free_daily_messages': freeDailyMessages,
      'cache_expiry_hours': cacheExpiryHours,
    };
  }
}