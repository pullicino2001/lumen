# Firebase App Distribution — Deploy Workflow

## Prerequisites
- Firebase CLI installed and authenticated (`firebase login`)
- Flutter environment set up

## Steps

### 1. Bump the version
In `pubspec.yaml`, increment the build number (`+N`):
```yaml
version: 1.0.0+3   # increment the number after +
```

### 2. Build split APKs
```bash
flutter build apk --release --split-per-abi
```
Outputs three APKs in `build/app/outputs/flutter-apk/`:
- `app-arm64-v8a-release.apk` — modern Android phones (use this one)
- `app-armeabi-v7a-release.apk` — older 32-bit devices
- `app-x86_64-release.apk` — emulators

### 3. Distribute to Firebase
```bash
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-arm64-v8a-release.apk \
  --app 1:92462142923:android:7f93d6b236798ecd3bd24e \
  --project lumen-2026 \
  --testers "peter@pullicino.com" \
  --release-notes "Your release notes here"
```

## Notes
- Always use `--split-per-abi` — without it Flutter builds a fat APK (~50MB) containing all architectures
- Always bump `pubspec.yaml` version before building — Firebase will show "downgrade" if the build number hasn't changed
- The `--testers` flag is required to push a notification to your device; omitting it uploads the build but sends no notification
- Firebase App ID: `1:92462142923:android:7f93d6b236798ecd3bd24e`
- Firebase Project: `lumen-2026`
- Tester email: `peter@pullicino.com`
