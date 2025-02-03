# Keep all classes used by Razorpay
-keep class com.razorpay.** { *; }

# Keep Google Play Core SplitInstall classes
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Keep Google Pay-related classes
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }

# Avoid obfuscating Flutter deferred components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class io.flutter.app.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Additional ProGuard rules
-dontwarn com.google.android.**
-dontwarn proguard.annotation.**
