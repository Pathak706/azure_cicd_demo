# React Native CI/CD Pipeline
## A Comprehensive Guide

---

## Agenda

1. CI/CD Fundamentals
2. Project Overview
3. GitHub Actions Workflow
4. Azure DevOps Pipeline
5. Setting Up Required Credentials
6. Version Management System
7. Firebase App Distribution
8. Troubleshooting Common Issues
9. Hands-on Exercises
10. Q&A

---

## CI/CD Fundamentals

### What is CI/CD?

- **Continuous Integration (CI)**
  - Frequently merging code changes
  - Automated builds and tests

- **Continuous Deployment (CD)**
  - Automatically deploying code changes
  - Streamlined delivery pipeline

---

## Benefits of CI/CD for Mobile Development

- ⚡ Faster release cycles
- 🐛 Early bug detection
- 🔄 Consistent build processes
- 🧪 Automated testing
- 📱 Streamlined deployment
- 🛠️ Reduced manual errors
- 👥 Better team collaboration

---

## CI/CD Pipeline Components

1. **Source Control**: GitHub, GitLab, Bitbucket
2. **Build Automation**: Compiling code, running tests
3. **Artifact Generation**: Creating APKs, AABs, IPAs
4. **Distribution**: Firebase App Distribution, TestFlight, Play Store
5. **Monitoring**: Tracking build status and deployment success

---

## Project Overview

### Repository Structure

```
azure_cicd_demo/
├── .github/workflows/       # GitHub Actions workflow files
├── android/                 # Android project files
├── ios/                     # iOS project files
├── azure-pipelines.yml      # Azure DevOps pipeline configuration
├── package.json             # Node.js dependencies and scripts
└── README.md                # Project documentation
```

---

## CI/CD Architecture

Our CI/CD setup uses two parallel systems:

1. **GitHub Actions**: Cloud-based CI/CD service integrated with GitHub
2. **Azure DevOps Pipelines**: Microsoft's CI/CD service

Both systems:
- Trigger on push to main branch or pull requests
- Build for iOS and Android platforms
- Deploy to testing platforms
- Manage app versioning automatically

---

## GitHub Actions Workflow

### Android Workflow (`android.yml`)

1. Checkout code
2. Setup environment (Node.js, Java, Android SDK)
3. Install dependencies
4. Decode secrets (keystore, Firebase config)
5. Update app version
6. Build APK
7. Upload artifacts
8. Deploy to Firebase

---

## GitHub Actions Workflow

### iOS Workflow (`ios.yml`)

1. Checkout code
2. Setup environment (Node.js, Ruby, Xcode)
3. Install dependencies (npm, CocoaPods)
4. Verify Firebase configuration
5. Update app version
6. Build iOS app (demo mode)
7. Create demo IPA
8. Upload artifacts

---

## Azure DevOps Pipeline

### Pipeline Configuration (`azure-pipelines.yml`)

- **Stages and Jobs**: Android and iOS stages
- **Variable Groups**: Centralized variable management
- **Secure Files**: Secure storage for sensitive files
- **Task-based approach**: Predefined tasks for common operations

---

## Azure DevOps Pipeline

### Key Differences from GitHub Actions

- Different syntax and structure
- Integration with Azure DevOps services
- Different approach to secret management
- Task-based vs. script-based approach

---

## Setting Up Required Credentials

### Android Requirements

1. **Keystore File**
   ```bash
   keytool -genkey -v -keystore your_keystore.keystore -alias your_alias -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Firebase Configuration**
   - Download `google-services.json` from Firebase console

3. **Firebase CLI Token**
   ```bash
   firebase login:ci
   ```

---

## Setting Up Required Credentials

### iOS Requirements

1. **Apple Developer Account**
2. **Distribution Certificate**
3. **Provisioning Profile**
4. **App Store Connect API Key**
5. **Firebase Configuration** (`GoogleService-Info.plist`)

---

## Version Management System

Our CI/CD pipelines include automatic version management:

1. **Version Name/Marketing Version**: From `package.json`
2. **Version Code/Build Number**: Auto-incremented during build

```yaml
- name: Update app version
  run: |
    # Get version from package.json
    VERSION=$(node -p "require('./package.json').version")
    
    # Get current versionCode from build.gradle
    CURRENT_VERSION_CODE=$(grep -o "versionCode [0-9]*" android/app/build.gradle | awk '{print $2}')
    NEW_VERSION_CODE=$((CURRENT_VERSION_CODE + 1))
    
    # Update build.gradle
    sed -i "s/versionCode $CURRENT_VERSION_CODE/versionCode $NEW_VERSION_CODE/" android/app/build.gradle
    sed -i "s/versionName \"[^\"]*\"/versionName \"$VERSION\"/" android/app/build.gradle
```

---

## Firebase App Distribution

### Setup Process

1. Create a Firebase project
2. Add your app to the project
3. Set up App Distribution
4. Add testers by email or create tester groups

---

## Firebase App Distribution

### Integration with GitHub Actions

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

---

## Firebase App Distribution

### Integration with Azure DevOps (via Fastlane)

```ruby
sh("firebase appdistribution:distribute app/build/outputs/bundle/release/app-release.aab \
  --app #{ENV["FIREBASE_APP_ID_ANDROID"]} \
  --testers #{ENV["FIREBASE_TESTERS"]} \
  --release-notes \"New beta build\" \
  --token \"#{ENV["FIREBASE_CLI_TOKEN"]}\"")
```

---

## Troubleshooting Common Issues

### Android Build Issues

1. **Missing Keystore**
   - Solution: Follow instructions in `upload_secure_files_guide.md`

2. **Autolinking Issues**
   - Solution: Add `createAutolinkingJson` task in `app/build.gradle`

3. **Version Code Conflicts**
   - Solution: Skip version code increment in Fastlane

---

## Troubleshooting Common Issues

### iOS Build Issues

1. **Xcode Version Compatibility**
   - Solution: Use Xcode version selection step

2. **CocoaPods Installation Issues**
   - Solution: Use `build_ios_local_modular.sh` script

3. **Signing Issues**
   - Solution: For demo, build for simulator only

---

## Hands-on Exercises

### Exercise 1: Set Up Local Build Environment

1. Clone the repository
2. Install dependencies: `npm install`
3. Install CocoaPods: `cd ios && pod install`
4. Test local builds:
   - Android: `npm run android`
   - iOS: `npm run ios`

---

## Hands-on Exercises

### Exercise 2: Test the iOS Build Script

1. Make the script executable:
   ```bash
   chmod +x build_ios_local_modular.sh
   ```

2. Run individual steps:
   ```bash
   ./build_ios_local_modular.sh --check-xcode
   ./build_ios_local_modular.sh --update-version
   ./build_ios_local_modular.sh --build
   ```

---

## Hands-on Exercises

### Exercise 3: Create a Pull Request

1. Create a new branch:
   ```bash
   git checkout -b feature/update-readme
   ```

2. Make changes to README.md

3. Commit and push:
   ```bash
   git commit -am "Update README"
   git push origin feature/update-readme
   ```

4. Create a pull request on GitHub

5. Observe the CI/CD pipeline running

---

## Q&A

1. **Why use both GitHub Actions and Azure DevOps?**
   - Demonstrates two popular CI/CD platforms

2. **How do I add new testers to Firebase App Distribution?**
   - Update the `FIREBASE_TESTERS` secret/variable

3. **Can I use this setup for other React Native projects?**
   - Yes, by updating app identifiers and credentials

---

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure DevOps Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [Firebase App Distribution Documentation](https://firebase.google.com/docs/app-distribution)
- [React Native Documentation](https://reactnative.dev/docs/getting-started)

---

## Thank You!

### Questions?