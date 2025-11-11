# Habit Tracker (Flutter)

A lightweight Flutter habit-tracker app (calendar + per-day habits + Firebase auth support).

Quick links
- App entry: [`MyApp`](Habit-Tracker/my_app/lib/main.dart)
- Firebase options: [`DefaultFirebaseOptions.currentPlatform`](Habit-Tracker/my_app/lib/firebase_options.dart)
- Bottom nav component: [`ButtomNavbar`](Habit-Tracker/my_app/lib/components/buttom_navbar.dart)
- Home page: [Habit-Tracker/my_app/lib/pages/home_page.dart](Habit-Tracker/my_app/lib/pages/home_page.dart)
- Login page: [Habit-Tracker/my_app/lib/pages/login_page.dart](Habit-Tracker/my_app/lib/pages/login_page.dart)
- Pubspec (dependencies & assets): [Habit-Tracker/my_app/pubspec.yaml](Habit-Tracker/my_app/pubspec.yaml)
- Project Flutter subfolder: [Habit-Tracker/my_app/README.md](Habit-Tracker/my_app/README.md)

Prerequisites
- Flutter SDK (stable) — install & add to PATH: https://docs.flutter.dev/get-started/install
- Android SDK / Android Studio (for Android builds)
- Xcode (for iOS builds on macOS)
- JDK 11+ (set JAVA_HOME)
- Git
- (Optional) Visual Studio with "Desktop development with C++" for Windows desktop builds
- (Optional) GTK 3 dev packages for Linux desktop builds

Verified with
- Run locally:
  flutter --version
  flutter doctor

Dependencies (detected in project)
- firebase_core
- firebase_auth
- google_sign_in (optional UI helpers)
- curved_navigation_bar
- flutter_test (dev)
Note: Exact versions are defined in [Habit-Tracker/my_app/pubspec.yaml](Habit-Tracker/my_app/pubspec.yaml). Run `flutter pub get` to fetch them.

Setup & run (recommended)
1. Clone repository and open project root:
   git clone https://github.com/jiro0823/Habit-Tracker.git
   cd Habit-Tracker/my_app

2. Install Dart/Flutter packages:
   flutter pub get

3. (Optional) Firebase
   - The app initializes Firebase via [`DefaultFirebaseOptions.currentPlatform`](Habit-Tracker/my_app/lib/firebase_options.dart).
   - If you use Firebase auth, create a Firebase project and add platform config:
     - Android: copy google-services.json → android/app/google-services.json
     - iOS: copy GoogleService-Info.plist → ios/Runner/GoogleService-Info.plist
   - Do NOT commit these files. Add to .gitignore if needed.
   - Enable auth providers (Email, Google) in Firebase Console.

4. Run on device/emulator:
   flutter run

5. Build release
   - Android APK: flutter build apk --release
   - iOS: flutter build ios --release
   - Web: flutter build web

Desktop build notes
- Windows: Visual Studio (Desktop C++) + run from project root (my_app) with `flutter build windows` or `flutter run -d windows`.
- macOS: Xcode command-line tools + `flutter build macos`.
- Linux: GTK development packages + `flutter build linux`.

Assets
- Images used by login/social tiles are referenced from assets/ (see [Habit-Tracker/my_app/pubspec.yaml](Habit-Tracker/my_app/pubspec.yaml)). If images are missing, add them under my_app/assets/images and update pubspec.

Important notes & troubleshooting
- If Firebase is not configured, the app still runs but auth features will fail. You can comment out initialization in [Habit-Tracker/my_app/lib/main.dart](Habit-Tracker/my_app/lib/main.dart) during local testing.
- Keep local Firebase config out of VCS (see top-level README notes).
- If you see Android Gradle/JDK version errors, install JDK 11+ and set JAVA_HOME accordingly.
- For Windows "detected dubious ownership" Git errors, see tips in this repo's top-level README.

Useful commands
- Fetch packages: flutter pub get
- Run: flutter run
- Analyze: flutter analyze
- Format: dart format .
- Test: flutter test

Contributing / License
- See [Habit-Tracker/my_app/README.md](Habit-Tracker/my_app/README.md) for the starter project notes.
- Add a license of your choice (e.g., MIT) to the repo root.

If you want, I can update [Habit-Tracker/my_app/README.md](Habit-Tracker/my_app/README.md) as well with the same content.
