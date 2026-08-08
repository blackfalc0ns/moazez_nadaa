import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use(keystoreProperties::load)
}

android {
    namespace = "sa.moazez.nedaa"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "sa.moazez.nedaa"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val configuredStoreFile = keystoreProperties.getProperty("storeFile")
                ?: error("storeFile is missing from android/key.properties")
            keyAlias = keystoreProperties.getProperty("keyAlias")
                ?: error("keyAlias is missing from android/key.properties")
            keyPassword = keystoreProperties.getProperty("keyPassword")
                ?: error("keyPassword is missing from android/key.properties")
            storeFile = file(configuredStoreFile)
            storePassword = keystoreProperties.getProperty("storePassword")
                ?: error("storePassword is missing from android/key.properties")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // DataStore 1.2.1 includes a 16 KB page-size compatible native counter.
    implementation("androidx.datastore:datastore:1.2.1")
    implementation("androidx.datastore:datastore-preferences:1.2.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
