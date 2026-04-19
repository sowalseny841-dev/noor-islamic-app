# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Awesome Notifications
-keep class me.carda.awesome_notifications.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Just Audio
-keep class com.ryanheise.just_audio.** { *; }

# Hive
-keep class com.hive.** { *; }

# Google Play Core (pour les mises à jour in-app)
-keep class com.google.android.play.core.** { *; }

# Modèles Dart (sérialisation)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes EnclosingMethod

# Règles générales
-dontwarn com.google.**
-dontwarn okhttp3.**
-dontwarn okio.**
