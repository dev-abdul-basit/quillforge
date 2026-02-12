import '../services/config_service.dart';


/// OpenAI API Key - now loaded from remote config
/// @deprecated Direct access removed. Use ConfigService.instance.apiKey or ApiClient
String get API_KEY => ConfigService.instance.apiKey;

/// OpenAI Models - now loaded from remote config
class OpenAIModels {
  static String get premiumChatModel => ConfigService.instance.premiumChatModel;
  static String get freeChatModel => ConfigService.instance.freeChatModel;
  static String get audioTranscriptionModel => ConfigService.instance.audioModel;

  // Legacy constants for backward compatibility
  static const String gpt4o = "gpt-4o";
  static const String gpt4oMini = "gpt-4o-mini";
  static const String gpt35Turbo = "gpt-3.5-turbo-1106";
  static const String whisper1 = "whisper-1";
}

/// @deprecated Use OpenAIModels.gpt35Turbo instead
String gptModelGPTTurbo1106 = OpenAIModels.gpt35Turbo;

/// @deprecated Use OpenAIModels.gpt4oMini instead
String gptModelGPTpt4OMini = OpenAIModels.gpt4oMini;

/// In App Purchase Subscription for Android
const androidInAppPurchaseIdWeekly = "Add weekly premium key for android";
const androidInAppPurchaseIdMonthly = "Add monthly premium key for android";
const androidInAppPurchaseIdYearly = "Add yearly premium key for android";

/// In App Purchase Subscription for IOS
const iOSInAppPurchaseIdWeekly = "Add weekly premium key for ios";
const iOSInAppPurchaseIdMonthly = "Add monthly premium key for ios";
const iOSInAppPurchaseIdYearly = "Add yearly premium key for ios";

/// Privacy Policy & Terms URLs
const privacyPolicyUrl = "https://www.developermatic.com/privacy-policy";
const termsAndConditionUrl = "https://www.developermatic.com/terms-and-conditions";
const double radius = 15;

/// kFAQString
const KFAQString =
    "Q: What is QuillForge?\nA: QuillForge is an AI-powered productivity app that helps you create, edit, and organize notes using intelligent writing and content-generation tools.\n\n"
    "Q: How do AI Notes work in QuillForge?\nA: QuillForge uses advanced AI models to understand your input and generate structured, clear, and useful notes based on your intent.\n\n"
    "Q: What are the benefits of using QuillForge?\nA: QuillForge saves time by automating note creation, improving clarity, and helping you manage ideas, tasks, and content more efficiently.\n\n"
    "Q: Can QuillForge be used for different types of content?\nA: Yes, QuillForge supports meetings, study notes, brainstorming, social posts, marketing content, and many other use cases.\n\n"
    "Q: Is QuillForge easy to use?\nA: Yes, QuillForge is designed with a simple and intuitive interface, allowing you to generate and manage content with minimal effort.\n\n"
    "Q: Does QuillForge include tools beyond note-taking?\nA: Yes, QuillForge includes a library of AI tools for writing, marketing, social media, and productivity tasks.\n\n"
    "Q: Is my data secure in QuillForge?\nA: Yes, QuillForge takes data privacy seriously and applies security best practices to protect your notes and personal information.\n\n"
    "Q: How do I get started with QuillForge?\nA: Download the app, complete the onboarding process, and start creating AI-powered notes and content right away.";
