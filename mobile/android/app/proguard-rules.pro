# Keep Google J2ObjC annotations
-keep class com.google.j2objc.annotations.** { *; }
-dontwarn com.google.j2objc.annotations.**
-keep class com.google.common.** { *; }

# Keep Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Play Core
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Java reflection related classes
-keep class java.lang.reflect.** { *; }

# Keep specific missing classes
-keep class com.google.j2objc.annotations.ReflectionSupport { *; }
-keep class com.google.j2objc.annotations.RetainedWith { *; } 