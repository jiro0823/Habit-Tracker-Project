# Habit Tracker (Flutter)

A lightweight Flutter habit-tracker app with a calendar, per-day habits, checkboxes, swipe-to-delete, and a bottom navigation bar.

## Features
- Calendar view to pick date
- Per-date habit list (add / edit / delete)
- Checkboxes that mute / strike-through completed habits
- Swipe left to delete (Dismissible)
- All-habits view grouped by date
- Quick add from bottom nav (+)
- Firebase Authentication (email sign-in) — optional (requires your Firebase config)

## Prerequisites
- Flutter SDK (stable) installed and on PATH
- Android SDK / Android Studio (or Xcode for iOS)
- JDK 11+ (set JAVA_HOME)
- Git
- (Optional) Firebase project for auth — add config files as noted below

Verify:
```powershell
flutter --version
git --version
java -version
flutter doctor
```

## Clone & open
```powershell
git clone https://github.com/jiro0823/Habit-Tracker.git
cd Habit-Tracker
```

Note: This repository may contain the Flutter project in a subfolder (for example `my_app`). If `flutter pub get` errors with "No pubspec.yaml file found", find the project root:
```powershell
# search for pubspec.yaml in repo
Get-ChildItem -Path . -Recurse -Filter pubspec.yaml
# then cd into the folder that contains pubspec.yaml, for example:
cd .\my_app
```

## Install dependencies & run
From the directory that contains `pubspec.yaml`:
```powershell
flutter pub get
# run on connected device or emulator
flutter run
```

## Firebase (optional)
If you use Firebase Authentication you must add Firebase config files:

- Android: copy `google-services.json` → `android/app/google-services.json`
- iOS: copy `GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`

Do not commit these files to public repos. Add them locally on each machine.

Enable desired sign-in providers in Firebase Console (Email, Google, etc.). For Android, add SHA-1 if you use Google sign-in.

## Common git / Windows issues
If you see "detected dubious ownership" on Windows:
```powershell
# mark repo folder as safe for current user (adjust path)
git config --global --add safe.directory "D:/xampp/htdocs/Flutter"
```
Or run PowerShell as Administrator and change ownership:
```powershell
takeown /F "D:\xampp\htdocs\Flutter" /R /D Y
icacls "D:\xampp\htdocs\Flutter" /setowner "%USERNAME%" /T /C
```

## Notes & tips
- If you see "BOTTOM OVERFLOWED" on small screens: reduce calendar height or use the responsive layout. The code uses a responsive calendar height; if necessary adjust the clamp values in `home_page.dart`.
- The '+' nav button opens the Add Habit dialog. Use long-press on list items to edit.
- To persist data across runs, integrate Hive or SharedPreferences (not included by default).

## Build release
Android:
```powershell
flutter build apk --release
```
iOS:
```bash
flutter build ios --release
```

## Contributing
- Fixes and improvements welcome. If you add Firebase config locally, keep it out of the repo and update .gitignore.

## License
Include your preferred license (e.g., MIT) or update this file to match your chosen license.
