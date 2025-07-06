plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.carecircle.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Application ID for CareCircle
        applicationId = "com.carecircle.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            
            // Disable R8 for release builds to avoid class issues
            isMinifyEnabled = false
            isShrinkResources = false
            
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    configurations.all {
        resolutionStrategy {
            // Force use of a specific version for all dependencies
            force("com.google.android.play:core:1.10.3")
            // Exclude conflicting dependencies
            exclude(group = "com.google.android.play", module = "core-common")
        }
    }
}

dependencies {
    implementation("com.google.j2objc:j2objc-annotations:2.8")
    implementation("com.google.android.play:core:1.10.3")
    // Remove the core-ktx dependency as it's causing conflicts
    // implementation("com.google.android.play:core-ktx:1.8.1")
}

flutter {
    source = "../.."
}
