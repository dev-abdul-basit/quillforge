# Keep ML Kit core
-keep class com.google.mlkit.** { *; }
-keep class com.google_mlkit_text_recognition.** { *; }

# Explicitly ignore unused language recognizers
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.devanagari.**

# Keep TextRecognizer initialization
-keepclassmembers class com.google.mlkit.vision.text.TextRecognizer {
    *;
}
