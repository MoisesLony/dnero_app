# dnero_app

A new application developed with Flutter.

## Technologies Used

- **Flutter**: UI framework for creating native applications on multiple platforms.
- **Dart**: Programming language used by Flutter.
- **Gradle**: Build system used by Android.
- **Java 17**: Required for compiling the application on Android; this was the version I used during development.

## Prerequisites

Before running the application, make sure you have the following components installed:

- **Flutter SDK**: [Installation Instructions](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Generally included with Flutter.
- **Android Studio or Xcode**: Depending on whether you want to compile for Android or iOS.
- **Emulator or physical device**: To test the application.
- **Java 17**: Required to compile the application on Android. You can download it from:
    - [Adoptium OpenJDK 17](https://adoptium.net/es/temurin/releases/)
    - [Oracle JDK 17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
- **Visual Studio Code (VS Code)**: Recommended as a code editor. You can download it from: 
    - [Visual Studio Code](https://code.visualstudio.com/)
    - Also, install the **Flutter** extension in VS Code to facilitate development.


## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/MoisesLony/dnero_app.git
   cd dnero_app
   ```

2. **Install dependencies**:

Run the following command to install the dependencies listed in `pubspec.yaml`:

```bash
flutter pub get
```

## Execution

1. **Start an emulator or connect a physical device.**
2. **Run the application**:

```bash
flutter run
```

**Note:**  
I recommend using a **physical device**. Since I worked on the Welcome Screen with the video, my computer would freeze when running the app on the emulator. However, you can try it with **Android Emulator** or another emulator to test its functionality.

## Project Structure

- `lib/`: Contains the main source code of the application.
- `assets/`: Directory for static resources such as images and fonts.

## Notes

1. **Issue with Java and video playback:**  
   I had issues with the **Java version** while working with the video in the app, so I installed **Java 17** and configured it in `gradle.properties` with:

   ```properties
   org.gradle.java.home=C:/Program Files/Java/jdk-17
   ```

   Later, I managed to make it work without this configuration, so I removed it. If you encounter issues with the Java version and Gradle does not recognize it, you can add a similar directory.

2. **Gradle version:**  
   In `gradle-wrapper.properties`, it is important to use version **8.1**, as defined here:

   ```properties
   distributionUrl=https\://services.gradle.org/distributions/gradle-8.1-bin.zip
   ```

   A higher version may cause issues and prevent the project from running correctly.

## Additional Resources

For more information about Flutter and Dart, you can check:

- [Flutter Documentation](https://docs.flutter.dev)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)