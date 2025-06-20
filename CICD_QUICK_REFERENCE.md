# CI/CD Quick Reference Guide

## Common Commands

### React Native Development

```bash
# Install dependencies
npm install
# or
yarn install

# Install CocoaPods (iOS)
cd ios && pod install

# Run Android app
npm run android
# or
yarn android

# Run iOS app
npm run ios
# or
yarn ios

# Start Metro bundler
npm start
# or
yarn start
```

### Android Build Commands

```bash
# Clean build
cd android && ./gradlew clean

# Build debug APK
cd android && ./gradlew assembleDebug

# Build release APK
cd android && ./gradlew assembleRelease

# Build release bundle (AAB)
cd android && ./gradlew bundleRelease
```

### iOS Build Commands

```bash
# Build for simulator
cd ios && xcodebuild -workspace azure_cicd_demo.xcworkspace -scheme azure_cicd_demo -configuration Debug -sdk iphonesimulator -derivedDataPath build

# Run iOS build script
./build_ios_local_modular.sh --all
# or individual steps
./build_ios_local_modular.sh --check-xcode
./build_ios_local_modular.sh --clean-install
./build_ios_local_modular.sh --pods
./build_ios_local_modular.sh --update-version
./build_ios_local_modular.sh --build
```

### Firebase Commands

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Generate CI token
firebase login:ci

# Deploy to Firebase App Distribution
firebase appdistribution:distribute <file-path> --app <app-id> --testers <testers> --release-notes "Release notes"
```

## Configuration Files

### GitHub Actions

#### Android Workflow (`.github/workflows/android.yml`)

Key sections:
- Triggers (push, pull request)
- Environment setup (Node.js, Java)
- Secret decoding (keystore, Firebase config)
- Version management
- Build process
- Firebase distribution

#### iOS Workflow (`.github/workflows/ios.yml`)

Key sections:
- Triggers (push, pull request)
- Environment setup (Node.js, Ruby, Xcode)
- CocoaPods installation
- Version management
- Build process (simulator mode)
- Artifact upload

### Azure DevOps

#### Pipeline Configuration (`azure-pipelines.yml`)

Key sections:
- Triggers (push, pull request)
- Variable groups
- Secure files
- Android build stage
- iOS build stage (commented out)
- Artifact publishing

### Fastlane

#### Android Fastlane (`android/fastlane/Fastfile`)

Key features:
- Build configuration
- Firebase distribution
- Version management

#### iOS Fastlane (`ios/fastlane/Fastfile`)

Key features:
- Build configuration
- TestFlight upload
- Version management

## Environment Variables and Secrets

### GitHub Actions Secrets

#### Android
- `ANDROID_KEYSTORE`: Base64-encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD`: Keystore password
- `ANDROID_KEY_ALIAS`: Key alias
- `ANDROID_KEY_PASSWORD`: Key password
- `GOOGLE_SERVICES_JSON`: Base64-encoded google-services.json
- `FIREBASE_APP_ID_ANDROID`: Firebase App ID
- `FIREBASE_CLI_TOKEN`: Firebase CLI token
- `FIREBASE_TESTERS`: Comma-separated list of tester emails

#### iOS
- `IOS_P12_CERTIFICATE`: Base64-encoded p12 certificate
- `IOS_P12_PASSWORD`: Certificate password
- `KEYCHAIN_PASSWORD`: Temporary keychain password
- `IOS_PROVISIONING_PROFILE`: Base64-encoded provisioning profile
- `IOS_GOOGLE_SERVICE_INFO`: Base64-encoded GoogleService-Info.plist
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API Key ID
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: Issuer ID
- `APP_STORE_CONNECT_API_KEY_CONTENT`: Base64-encoded API key content

### Azure DevOps Variables

- Create a variable group named `react-native-app-variables`
- Add the same variables as GitHub Actions secrets

### Azure DevOps Secure Files

Required files with exact names:
- `google-services.json`
- `my_app_release.keystore`
- `ios_distribution.p12`
- `distribution.mobileprovision`
- `GoogleService-Info.plist`

## Troubleshooting

### Android Issues

1. **Missing Keystore**
   - Check if keystore file exists at the expected location
   - Verify keystore.properties has correct path

2. **Autolinking Issues**
   ```gradle
   // Add to app/build.gradle
   task createAutolinkingJson {
       doLast {
           def autolinkDir = file("$buildDir/generated/autolinking")
           if (!autolinkDir.exists()) {
               autolinkDir.mkdirs()
           }
           def autolinkFile = file("$buildDir/generated/autolinking/autolinking.json")
           if (!autolinkFile.exists()) {
               autolinkFile.text = """
   {
     "packageName": "your.package.name",
     "applicationId": "your.package.name",
     "libraries": []
   }
   """
           }
       }
   }
   
   // Make sure the autolinking.json file is created before any React Native tasks
   preBuild.dependsOn createAutolinkingJson
   
   // Ensure generateAutolinkingNewArchitectureFiles task depends on createAutolinkingJson
   afterEvaluate {
       tasks.findByName('generateAutolinkingNewArchitectureFiles')?.dependsOn(createAutolinkingJson)
   }
   ```

3. **Version Code Conflicts**
   - Remove version code increment from Fastlane if it's handled in CI pipeline

### iOS Issues

1. **Xcode Version Compatibility**
   - Use Xcode 15.1 or higher for React Native 0.72+
   - Add Xcode version selection step in workflow

2. **CocoaPods Installation Issues**
   - Install CocoaPods: `sudo gem install cocoapods`
   - Run `pod install` with `--repo-update` flag if needed

3. **Signing Issues**
   - For demo purposes, build for simulator only
   - Ensure certificates and provisioning profiles are correctly set up

## Version Management

### Android

```bash
# Get version from package.json
VERSION=$(node -p "require('./package.json').version")

# Get current versionCode from build.gradle
CURRENT_VERSION_CODE=$(grep -o "versionCode [0-9]*" android/app/build.gradle | awk '{print $2}')
NEW_VERSION_CODE=$((CURRENT_VERSION_CODE + 1))

# Update build.gradle
sed -i "s/versionCode $CURRENT_VERSION_CODE/versionCode $NEW_VERSION_CODE/" android/app/build.gradle
sed -i "s/versionName \"[^\"]*\"/versionName \"$VERSION\"/" android/app/build.gradle
```

### iOS

```bash
# Get version from package.json
VERSION=$(node -p "require('./package.json').version")

# Get current build number from project.pbxproj
CURRENT_BUILD_NUMBER=$(grep -m 1 "CURRENT_PROJECT_VERSION = " ios/azure_cicd_demo.xcodeproj/project.pbxproj | awk '{print $3}' | sed 's/;//')
NEW_BUILD_NUMBER=$((CURRENT_BUILD_NUMBER + 1))

# Update project.pbxproj
sed -i '' "s/MARKETING_VERSION = [^;]*/MARKETING_VERSION = $VERSION/" ios/azure_cicd_demo.xcodeproj/project.pbxproj
sed -i '' "s/CURRENT_PROJECT_VERSION = [^;]*/CURRENT_PROJECT_VERSION = $NEW_BUILD_NUMBER/" ios/azure_cicd_demo.xcodeproj/project.pbxproj
```

## Firebase App Distribution

### GitHub Actions

```yaml
- name: Upload to Firebase App Distribution
  uses: wzieba/Firebase-Distribution-Github-Action@v1
  with:
    appId: ${{ secrets.FIREBASE_APP_ID_ANDROID }}
    token: ${{ secrets.FIREBASE_CLI_TOKEN }}
    testers: ${{ secrets.FIREBASE_TESTERS }}
    file: android/app/build/outputs/apk/release/app-release.apk
    releaseNotes: "New build from GitHub Actions"
```

### Azure DevOps (via Fastlane)

```ruby
sh("firebase appdistribution:distribute app/build/outputs/bundle/release/app-release.aab \
  --app #{ENV["FIREBASE_APP_ID_ANDROID"]} \
  --testers #{ENV["FIREBASE_TESTERS"]} \
  --release-notes \"New beta build\" \
  --token \"#{ENV["FIREBASE_CLI_TOKEN"]}\"")
```

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure DevOps Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Firebase App Distribution Documentation](https://firebase.google.com/docs/app-distribution)
- [React Native Documentation](https://reactnative.dev/docs/getting-started)