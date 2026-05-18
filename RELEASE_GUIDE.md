# 🚀 LoanBee - Release Build Guide

## Android App Bundle (AAB) Configuration

### ✅ Files Created:

1. **`android/key.properties`** - Signing configuration
2. **`android/app/loanbee-keystore.jks`** - Keystore file
3. **`android/app/proguard-rules.pro`** - ProGuard rules
4. **`android/app/build.gradle.kts`** - Updated with signing config

### 🔐 Step 1: Configure Signing Credentials

**IMPORTANT:** You need to update the `android/key.properties` file with your actual passwords.

1. Open `android/key.properties` in a text editor
2. Replace the placeholder values:

```properties
storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
keyPassword=YOUR_ACTUAL_KEY_PASSWORD  
keyAlias=loanbee
storeFile=loanbee-keystore.jks
```

**⚠️ Security Notes:**
- ✅ Added to `.gitignore` - won't be committed to Git
- ✅ Keep this file secure
- ✅ Never share these passwords

### 📦 Step 2: Build Release AAB

#### Option A: Build AAB (for Google Play Store)

```bash
flutter build appbundle --release
```

**Output location:**
```
build/app/outputs/bundle/release/app-release.aab
```

#### Option B: Build APK (for direct distribution)

```bash
flutter build apk --release
```

**Output location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

#### Option C: Build Split APKs (smaller size)

```bash
flutter build apk --split-per-abi --release
```

**Output location:**
```
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

### 📊 Build Configuration

The release build includes:
- ✅ **Code Shrinking** - Removes unused code
- ✅ **Resource Shrinking** - Removes unused resources
- ✅ **Code Obfuscation** - ProGuard optimization
- ✅ **Proper Signing** - With your release keystore

### 🎯 Version Management

Update version in `pubspec.yaml`:

```yaml
version: 1.0.0+1
#        ↑   ↑
#        |   +-- Build number (increment for each release)
#        +------ Version name (shown to users)
```

### 📝 Pre-Release Checklist

Before building for release:

- [ ] Update version number in `pubspec.yaml`
- [ ] Test all features in release mode
- [ ] Verify signing credentials in `key.properties`
- [ ] Update app icon if needed
- [ ] Review `AndroidManifest.xml` permissions
- [ ] Update app name and description
- [ ] Test on multiple devices
- [ ] Check ProGuard rules

### 🏪 Google Play Store Upload

1. **Build the AAB:**
   ```bash
   flutter build appbundle --release
   ```

2. **Go to Google Play Console:**
   - https://play.google.com/console

3. **Upload AAB:**
   - Navigate to your app
   - Go to "Release" → "Production"
   - Create new release
   - Upload `app-release.aab`

4. **Fill in release details:**
   - Release name
   - Release notes
   - Screenshots
   - App description

### 🧪 Testing Release Build

Test the release build before uploading:

```bash
# Install release APK on device
flutter install --release

# Or install AAB using bundletool
java -jar bundletool-1.15.6.jar build-apks --bundle=app-release.aab --output=app.apks --mode=universal
```

### 🔍 Verify Signing

Check if AAB is properly signed:

```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab
```

### 📱 App Details

**Package Name:** `com.uksolutions.loanbee`
**App Name:** LoanBee
**Current Version:** 1.0.0+1

### 🐛 Troubleshooting

**Problem:** Build fails with signing error
**Solution:** Check that passwords in `key.properties` are correct

**Problem:** ProGuard removes required code
**Solution:** Update `proguard-rules.pro` with keep rules

**Problem:** App crashes in release mode
**Solution:** Test with `--release` flag and check logs:
```bash
flutter run --release
adb logcat
```

### 📚 Additional Resources

- [Flutter Release Guide](https://docs.flutter.dev/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [ProGuard Rules](https://www.guardsquare.com/manual/configuration)

---

## 🎉 Ready to Build!

Once you've updated the passwords in `key.properties`, run:

```bash
flutter build appbundle --release
```

Your production-ready AAB will be in:
```
build/app/outputs/bundle/release/app-release.aab
```

Good luck with your release! 🚀
