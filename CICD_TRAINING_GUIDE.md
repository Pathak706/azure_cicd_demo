# React Native CI/CD Pipeline Training Guide

## Introduction

This training guide provides a comprehensive overview of setting up Continuous Integration and Continuous Deployment (CI/CD) pipelines for React Native applications. It covers both GitHub Actions and Azure DevOps pipelines, focusing on automating the build and distribution processes for iOS and Android platforms.

## Table of Contents

1. [CI/CD Fundamentals](#cicd-fundamentals)
2. [Project Overview](#project-overview)
3. [GitHub Actions Workflow](#github-actions-workflow)
4. [Azure DevOps Pipeline](#azure-devops-pipeline)
5. [Setting Up Required Credentials](#setting-up-required-credentials)
6. [Version Management System](#version-management-system)
7. [Firebase App Distribution](#firebase-app-distribution)
8. [Troubleshooting Common Issues](#troubleshooting-common-issues)
9. [Hands-on Exercises](#hands-on-exercises)
10. [Q&A](#qa)

## CI/CD Fundamentals

### What is CI/CD?

- **Continuous Integration (CI)**: The practice of frequently merging code changes into a shared repository, followed by automated builds and tests.
- **Continuous Deployment (CD)**: The practice of automatically deploying code changes to production or staging environments after passing CI checks.

### Benefits of CI/CD for Mobile Development

- Faster release cycles
- Early bug detection
- Consistent build processes
- Automated testing
- Streamlined deployment to testers and app stores
- Reduced manual errors
- Better collaboration between team members

### CI/CD Pipeline Components

1. **Source Control**: GitHub, GitLab, Bitbucket
2. **Build Automation**: Compiling code, running tests
3. **Artifact Generation**: Creating APKs, AABs, IPAs
4. **Distribution**: Deploying to Firebase App Distribution, TestFlight, Play Store
5. **Monitoring**: Tracking build status and deployment success

## Project Overview

### Repository Structure

```
azure_cicd_demo/
├── .github/workflows/       # GitHub Actions workflow files
│   ├── android.yml          # Android build and deploy workflow
│   └── ios.yml              # iOS build and deploy workflow
├── android/                 # Android project files
│   ├── app/                 # Android app module
│   ├── fastlane/            # Fastlane configuration for Android
│   └── keystore.properties  # Keystore configuration (template)
├── ios/                     # iOS project files
│   ├── azure_cicd_demo/     # iOS app module
│   ├── fastlane/            # Fastlane configuration for iOS
│   └── Podfile              # CocoaPods dependencies
├── azure-pipelines.yml      # Azure DevOps pipeline configuration
├── package.json             # Node.js dependencies and scripts
└── README.md                # Project documentation
```

### CI/CD Architecture

Our CI/CD setup uses two parallel systems:

1. **GitHub Actions**: Cloud-based CI/CD service integrated with GitHub repositories
2. **Azure DevOps Pipelines**: Microsoft's CI/CD service that can be integrated with various source control systems

Both systems are configured to:
- Trigger on push to main branch or pull requests
- Build the app for both iOS and Android platforms
- Deploy to testing platforms (Firebase App Distribution for Android, TestFlight for iOS)
- Manage app versioning automatically

## GitHub Actions Workflow

### Android Workflow (`android.yml`)

The Android workflow performs the following steps:

1. **Checkout code**: Retrieves the latest code from the repository
2. **Setup environment**: Configures Node.js, Java, and Android SDK
3. **Install dependencies**: Installs npm packages
4. **Decode secrets**: Sets up keystore and Firebase configuration
5. **Update app version**: Increments version code and updates version name
6. **Build APK**: Compiles the Android app
7. **Upload artifacts**: Stores the APK for download
8. **Deploy to Firebase**: Distributes the app to testers

Key features:
- Caching of dependencies for faster builds
- Automatic version management
- Secure handling of sensitive information

### iOS Workflow (`ios.yml`)

The iOS workflow performs the following steps:

1. **Checkout code**: Retrieves the latest code from the repository
2. **Setup environment**: Configures Node.js, Ruby, and Xcode
3. **Install dependencies**: Installs npm packages and CocoaPods
4. **Verify Firebase configuration**: Ensures Firebase setup is correct
5. **Update app version**: Increments build number and updates version
6. **Build iOS app**: Compiles the iOS app for simulator (demo mode)
7. **Create demo IPA**: Packages the app for distribution
8. **Upload artifacts**: Stores the IPA for download

Key features:
- Xcode version management
- Modular build process for local testing
- Detailed logging for troubleshooting

## Azure DevOps Pipeline

### Pipeline Configuration (`azure-pipelines.yml`)

The Azure DevOps pipeline performs similar steps to the GitHub Actions workflows but is configured differently:

1. **Stages and Jobs**: Organizes the pipeline into Android and iOS stages
2. **Variable Groups**: Uses centralized variable management
3. **Secure Files**: Stores sensitive files securely in Azure DevOps
4. **Task-based approach**: Uses predefined tasks for common operations

Key differences from GitHub Actions:
- Different syntax and structure
- Integration with Azure DevOps services
- Different approach to secret management

### Android Build and Deploy

The Android stage in Azure DevOps:

1. **Prepares the environment**: Installs Node.js and Java
2. **Downloads secure files**: Retrieves keystore and Firebase configuration
3. **Sets up signing configuration**: Configures app signing
4. **Updates app version**: Manages version information
5. **Builds the app**: Uses Fastlane to build and deploy
6. **Publishes artifacts**: Makes the APK available for download

### iOS Build and Deploy (Commented Out)

The iOS stage is commented out but would perform similar steps to the Android stage, with iOS-specific configurations.

## Setting Up Required Credentials

### Android Requirements

1. **Keystore File**: Used for signing the Android app
   - Creation: `keytool -genkey -v -keystore your_keystore.keystore -alias your_alias -keyalg RSA -keysize 2048 -validity 10000`
   - Storage: Upload to GitHub Secrets or Azure DevOps Secure Files

2. **Firebase Configuration**:
   - Create a Firebase project
   - Add an Android app with your package name
   - Download `google-services.json`
   - Upload to GitHub Secrets or Azure DevOps Secure Files

3. **Firebase CLI Token**:
   - Install Firebase CLI: `npm install -g firebase-tools`
   - Login: `firebase login`
   - Generate token: `firebase login:ci`
   - Add token to GitHub Secrets or Azure DevOps variables

### iOS Requirements

1. **Apple Developer Account**: Required for app signing and distribution
2. **Distribution Certificate**: Used for signing the iOS app
3. **Provisioning Profile**: Links the app to your Apple Developer account
4. **App Store Connect API Key**: Used for uploading to TestFlight
5. **Firebase Configuration**: Similar to Android but using `GoogleService-Info.plist`

## Version Management System

Our CI/CD pipelines include automatic version management:

1. **Version Name/Marketing Version**: Taken from `package.json`
2. **Version Code/Build Number**: Automatically incremented during the build process

### Implementation in GitHub Actions:

```yaml
- name: Update app version
  run: |
    # Get version from package.json
    VERSION=$(node -p "require('./package.json').version")

    # Get current versionCode from build.gradle
    CURRENT_VERSION_CODE=$(grep -o "versionCode [0-9]*" android/app/build.gradle | awk '{print $2}')
    NEW_VERSION_CODE=$((CURRENT_VERSION_CODE + 1))

    # Update versionName and versionCode in build.gradle
    sed -i "s/versionCode $CURRENT_VERSION_CODE/versionCode $NEW_VERSION_CODE/" android/app/build.gradle
    sed -i "s/versionName \"[^\"]*\"/versionName \"$VERSION\"/" android/app/build.gradle
```

### Implementation in Azure DevOps:

Similar to GitHub Actions, with the same logic for extracting and updating version information.

## Firebase App Distribution

Firebase App Distribution is used to distribute app builds to testers before releasing to app stores.

### Setup Process:

1. Create a Firebase project
2. Add your app to the project
3. Set up App Distribution
4. Add testers by email or create tester groups

### Integration with CI/CD:

#### GitHub Actions:

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

#### Azure DevOps (via Fastlane):

```ruby
sh("firebase appdistribution:distribute app/build/outputs/apk/release/app-release.apk \
  --app #{ENV["FIREBASE_APP_ID_ANDROID"]} \
  --testers #{ENV["FIREBASE_TESTERS"]} \
  --release-notes \"New beta build\" \
  --token \"#{ENV["FIREBASE_CLI_TOKEN"]}\"")
```

## Troubleshooting Common Issues

### Android Build Issues

1. **Missing Keystore**: Ensure the keystore file is correctly uploaded and referenced
   - Solution: Follow the instructions in `upload_secure_files_guide.md`

2. **Autolinking Issues**: Problems with React Native autolinking
   - Solution: Add the `createAutolinkingJson` task in `app/build.gradle`

3. **Version Code Conflicts**: Multiple processes trying to increment version code
   - Solution: Skip version code increment in Fastlane if it's handled in the CI pipeline

### iOS Build Issues

1. **Xcode Version Compatibility**: React Native requires specific Xcode versions
   - Solution: Use the Xcode version selection step in the workflow

2. **CocoaPods Installation**: Issues with CocoaPods dependencies
   - Solution: Use the `build_ios_local_modular.sh` script to test locally

3. **Signing Issues**: Problems with certificates and provisioning profiles
   - Solution: For demo purposes, build for simulator only to avoid signing requirements

## Hands-on Exercises

### Exercise 1: Set Up Local Build Environment

1. Clone the repository
2. Install dependencies: `npm install`
3. Install CocoaPods: `cd ios && pod install`
4. Test local builds:
   - Android: `npm run android`
   - iOS: `npm run ios`

### Exercise 2: Test the iOS Build Script

1. Make the script executable: `chmod +x build_ios_local_modular.sh`
2. Run individual steps:
   - Check Xcode: `./build_ios_local_modular.sh --check-xcode`
   - Update version: `./build_ios_local_modular.sh --update-version`
   - Build app: `./build_ios_local_modular.sh --build`

### Exercise 3: Create a Pull Request

1. Create a new branch: `git checkout -b feature/update-readme`
2. Make changes to README.md
3. Commit and push: `git commit -am "Update README" && git push origin feature/update-readme`
4. Create a pull request on GitHub
5. Observe the CI/CD pipeline running

## Q&A

### Common Questions

1. **Q: Why use both GitHub Actions and Azure DevOps?**
   A: This demonstrates two popular CI/CD platforms, allowing teams to choose based on their preferences and existing infrastructure.

2. **Q: How do I add new testers to Firebase App Distribution?**
   A: Update the `FIREBASE_TESTERS` secret/variable with comma-separated email addresses.

3. **Q: Can I use this setup for other React Native projects?**
   A: Yes, the configuration can be adapted for other projects by updating app identifiers and credentials.

4. **Q: How do I handle different environments (dev, staging, prod)?**
   A: You can extend the workflows to use different configurations based on branch or tags.

5. **Q: What about automated testing?**
   A: You can add test steps to the workflows using Jest, Detox, or other testing frameworks.

### Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure DevOps Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Firebase App Distribution Documentation](https://firebase.google.com/docs/app-distribution)
- [React Native Documentation](https://reactnative.dev/docs/getting-started)
