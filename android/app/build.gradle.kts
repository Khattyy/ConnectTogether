plugins {
    id("com.android.application")

    // FlutterFire: Google Services plugin
    id("com.google.gms.google-services")

    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.connect_fixed"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.connect_fixed"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM (manages all Firebase versions)
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

    // Add this if you use Firebase Auth (optional)
    // implementation("com.google.firebase:firebase-auth")

    // Add this if you use Firestore (optional)
    // implementation("com.google.firebase:firebase-firestore")

    // Add this if you use Realtime Database (optional)
    // implementation("com.google.firebase:firebase-database")

    // Add this if you use Storage (optional)
    // implementation("com.google.firebase:firebase-storage")
}
