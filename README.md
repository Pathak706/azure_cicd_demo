# Azure CICD Demo

This is a new [**React Native**](https://reactnative.dev) project, bootstrapped using [`@react-native-community/cli`](https://github.com/react-native-community/cli).

## CI/CD Setup

This repository has CI/CD pipelines set up for both GitHub Actions and Azure DevOps. The pipelines build and deploy the app to TestFlight (iOS) and Firebase App Tester (Android).

### GitHub Actions

GitHub Actions workflows are defined in the `.github/workflows` directory:

- `ios.yml`: Builds and deploys the iOS app to TestFlight
- `android.yml`: Builds and deploys the Android app to Firebase App Tester

### Azure DevOps

Azure DevOps pipeline is defined in the `azure-pipelines.yml` file at the root of the repository.

## Prerequisites for CI/CD

### iOS

1. Apple Developer Account
2. App Store Connect API Key
3. iOS Distribution Certificate (p12)
4. iOS Provisioning Profile
5. TestFlight app setup

### Android

1. Google Play Developer Account
2. Firebase Project with App Distribution enabled
3. Android Keystore for signing
4. Google Services JSON file
5. Firebase CLI token (instead of a service account)

## CI/CD Setup Instructions

### Note on Firebase Authentication

This project uses Firebase CLI token authentication for Firebase App Distribution instead of a service account. This approach is simpler and doesn't require creating and managing a service account JSON file. The Firebase CLI token is obtained by logging in to Firebase on your local machine and generating a CI token.

### How to Obtain Required Values

Below is a comprehensive guide on how to obtain all the required values for both GitHub Actions and Azure DevOps pipelines.

#### iOS-Related Values

1. **Apple Developer Account**
   - Sign up at [developer.apple.com](https://developer.apple.com)
   - Requires annual subscription ($99/year)

2. **Team ID**
   - Log in to [developer.apple.com](https://developer.apple.com)
   - Go to "Membership" section
   - Your Team ID is displayed under "Team ID" (usually a 10-character alphanumeric string)

3. **iOS Bundle Identifier**
   - This is the unique identifier for your app (e.g., `com.yourcompany.appname`)
   - Must match what's in your Xcode project and provisioning profile
   - Can be found in Xcode under your target's "General" tab or in Info.plist

4. **Apple ID**
   - The email address you use to log in to your Apple Developer account

5. **iOS Distribution Certificate (p12)**
   - In Xcode, go to Preferences > Accounts > [Your Apple ID] > Manage Certificates
   - Click "+" and select "Apple Distribution"
   - In Keychain Access, find the certificate, right-click and export as .p12
   - You'll be prompted to set a password (this will be your `IOS_P12_PASSWORD`)
   - To convert to base64 for GitHub Actions:
     ```sh
     base64 -i your_certificate.p12 | pbcopy
     ```

6. **iOS Provisioning Profile**
   - Log in to [developer.apple.com](https://developer.apple.com)
   - Go to "Certificates, Identifiers & Profiles" > "Profiles"
   - Create a distribution profile for App Store
   - Download the .mobileprovision file
   - To convert to base64 for GitHub Actions:
     ```sh
     base64 -i your_profile.mobileprovision | pbcopy
     ```

7. **App Store Connect API Key**
   - Log in to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
   - Go to "Users and Access" > "Keys"
   - Click "+" to create a new key
   - Note the Key ID (`APP_STORE_CONNECT_API_KEY_ID`)
   - Note the Issuer ID (`APP_STORE_CONNECT_API_KEY_ISSUER_ID`)
   - Download the .p8 file
   - To get the content for `APP_STORE_CONNECT_API_KEY_CONTENT`:
     ```sh
     cat AuthKey_KEYID.p8 | base64 | pbcopy
     ```

8. **Keychain Password**
   - This can be any secure password you choose for the temporary keychain created during the build process

9. **iOS Google Service Info**
   - In the Firebase console, add an iOS app to your project
   - Enter your iOS Bundle ID
   - Download the GoogleService-Info.plist file
   - To convert to base64 for GitHub Actions:
     ```sh
     base64 -i GoogleService-Info.plist | pbcopy
     ```

#### Android-Related Values

1. **Android Package Name**
   - The unique identifier for your Android app (e.g., `com.yourcompany.appname`)
   - Found in your app's build.gradle file under `applicationId`

2. **Android Keystore**
   - Create a keystore file using Android Studio or the command line:
     ```sh
     keytool -genkey -v -keystore your_keystore.keystore -alias your_alias -keyalg RSA -keysize 2048 -validity 10000
     ```
   - You'll be prompted to set a password (this will be your `ANDROID_KEYSTORE_PASSWORD`)
   - You'll also set an alias and key password (`ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD`)
   - To convert to base64 for GitHub Actions:
     ```sh
     base64 -i your_keystore.keystore | pbcopy
     ```

3. **Firebase App ID for Android**
   - In the Firebase console, go to Project Settings
   - In the "Your apps" section, find your Android app
   - The App ID is displayed as "App ID" (format: `1:123456789012:android:abcdef1234567890`)

4. **Google Services JSON**
   - In the Firebase console, add an Android app to your project
   - Enter your Android Package Name
   - Download the google-services.json file
   - To convert to base64 for GitHub Actions:
     ```sh
     base64 -i google-services.json | pbcopy
     ```

5. **Firebase CLI Token**
   - Install the Firebase CLI on your local machine:
     ```sh
     npm install -g firebase-tools
     ```
   - Log in to Firebase:
     ```sh
     firebase login
     ```
   - Generate a CI token:
     ```sh
     firebase login:ci
     ```
   - This will open a browser window for authentication and then display a token
   - Copy this token for use in GitHub Actions and Azure DevOps

### GitHub Actions Secrets

Add the following secrets to your GitHub repository (Settings > Secrets and variables > Actions > New repository secret):

#### iOS Secrets
- `IOS_P12_CERTIFICATE`: Base64-encoded p12 certificate
- `IOS_P12_PASSWORD`: Password for the p12 certificate
- `KEYCHAIN_PASSWORD`: Password for the temporary keychain
- `IOS_PROVISIONING_PROFILE`: Base64-encoded provisioning profile
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API Key ID
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: App Store Connect API Key Issuer ID
- `APP_STORE_CONNECT_API_KEY_CONTENT`: App Store Connect API Key Content
- `TEAM_ID`: Apple Developer Team ID
- `IOS_BUNDLE_IDENTIFIER`: Bundle identifier for your iOS app
- `APPLE_ID`: Apple ID email
- `IOS_GOOGLE_SERVICE_INFO`: Base64-encoded GoogleService-Info.plist file

#### Android Secrets
- `GOOGLE_SERVICES_JSON`: Base64-encoded google-services.json file
- `ANDROID_KEYSTORE`: Base64-encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD`: Password for the keystore
- `ANDROID_KEY_ALIAS`: Key alias in the keystore
- `ANDROID_KEY_PASSWORD`: Password for the key
- `FIREBASE_APP_ID_ANDROID`: Firebase App ID for Android
- `FIREBASE_CLI_TOKEN`: Firebase CLI token for authentication
- `FIREBASE_TESTERS`: Comma-separated list of tester email addresses for Firebase App Distribution (e.g., "user1@example.com,user2@example.com")
- `ANDROID_PACKAGE_NAME`: Package name for your Android app

### Azure DevOps Variable Group

Create a variable group named `react-native-app-variables` in Azure DevOps (Pipelines > Library > Variable groups > + Variable group):

#### iOS Variables
- `IOS_P12_PASSWORD`: Password for the p12 certificate
- `KEYCHAIN_PASSWORD`: Password for the temporary keychain
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API Key ID
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: App Store Connect API Key Issuer ID
- `APP_STORE_CONNECT_API_KEY_CONTENT`: App Store Connect API Key Content
- `TEAM_ID`: Apple Developer Team ID
- `IOS_BUNDLE_IDENTIFIER`: Bundle identifier for your iOS app
- `APPLE_ID`: Apple ID email

#### Android Variables
- `ANDROID_KEYSTORE_PASSWORD`: Password for the keystore
- `ANDROID_KEY_ALIAS`: Key alias in the keystore
- `ANDROID_KEY_PASSWORD`: Password for the key
- `FIREBASE_APP_ID_ANDROID`: Firebase App ID for Android
- `FIREBASE_CLI_TOKEN`: Firebase CLI token for authentication
- `FIREBASE_TESTERS`: Comma-separated list of tester email addresses for Firebase App Distribution (e.g., "user1@example.com,user2@example.com")
- `ANDROID_PACKAGE_NAME`: Package name for your Android app

### Azure DevOps Secure Files

Upload the following files to Azure DevOps Secure Files (Pipelines > Library > Secure files > + Secure file):

1. iOS p12 certificate (the .p12 file you exported from Keychain Access) - **Must be named exactly `ios_distribution.p12`**
2. iOS provisioning profile (the .mobileprovision file you downloaded from Apple Developer portal) - **Must be named exactly `distribution.mobileprovision`**
3. Android keystore (the .keystore file you created) - **Must be named exactly `my_app_release.keystore`**
4. google-services.json (downloaded from Firebase console for Android) - **Must be named exactly `google-services.json`**
5. GoogleService-Info.plist (downloaded from Firebase console for iOS) - **Must be named exactly `GoogleService-Info.plist`**

> **Important**: All secure files must be uploaded with the exact filenames specified above. The pipeline is configured to look for these specific filenames.

## Running the Pipelines

### GitHub Actions

GitHub Actions workflows will run automatically on:
- Push to the `main` branch
- Pull requests to the `main` branch

You can also run them manually from the Actions tab in your GitHub repository.

### Azure DevOps

The Azure DevOps pipeline will run automatically on:
- Push to the `main` branch
- Pull requests to the `main` branch

You can also run it manually from the Pipelines section in your Azure DevOps project.

# Getting Started with Development

> **Note**: Make sure you have completed the [Set Up Your Environment](https://reactnative.dev/docs/set-up-your-environment) guide before proceeding.

## Step 1: Start Metro

First, you will need to run **Metro**, the JavaScript build tool for React Native.

To start the Metro dev server, run the following command from the root of your React Native project:

```sh
# Using npm
npm start

# OR using Yarn
yarn start
```

## Step 2: Build and run your app

With Metro running, open a new terminal window/pane from the root of your React Native project, and use one of the following commands to build and run your Android or iOS app:

### Android

```sh
# Using npm
npm run android

# OR using Yarn
yarn android
```

### iOS

For iOS, remember to install CocoaPods dependencies (this only needs to be run on first clone or after updating native deps).

The first time you create a new project, run the Ruby bundler to install CocoaPods itself:

```sh
bundle install
```

Then, and every time you update your native dependencies, run:

```sh
bundle exec pod install
```

For more information, please visit [CocoaPods Getting Started guide](https://guides.cocoapods.org/using/getting-started.html).

```sh
# Using npm
npm run ios

# OR using Yarn
yarn ios
```

If everything is set up correctly, you should see your new app running in the Android Emulator, iOS Simulator, or your connected device.

This is one way to run your app — you can also build it directly from Android Studio or Xcode.

## Step 3: Modify your app

Now that you have successfully run the app, let's make changes!

Open `App.tsx` in your text editor of choice and make some changes. When you save, your app will automatically update and reflect these changes — this is powered by [Fast Refresh](https://reactnative.dev/docs/fast-refresh).

When you want to forcefully reload, for example to reset the state of your app, you can perform a full reload:

- **Android**: Press the <kbd>R</kbd> key twice or select **"Reload"** from the **Dev Menu**, accessed via <kbd>Ctrl</kbd> + <kbd>M</kbd> (Windows/Linux) or <kbd>Cmd ⌘</kbd> + <kbd>M</kbd> (macOS).
- **iOS**: Press <kbd>R</kbd> in iOS Simulator.

## Congratulations! :tada:

You've successfully run and modified your React Native App. :partying_face:

### Now what?

- If you want to add this new React Native code to an existing application, check out the [Integration guide](https://reactnative.dev/docs/integration-with-existing-apps).
- If you're curious to learn more about React Native, check out the [docs](https://reactnative.dev/docs/getting-started).

# Troubleshooting

If you're having issues getting the above steps to work, see the [Troubleshooting](https://reactnative.dev/docs/troubleshooting) page.

# Learn More

To learn more about React Native, take a look at the following resources:

- [React Native Website](https://reactnative.dev) - learn more about React Native.
- [Getting Started](https://reactnative.dev/docs/environment-setup) - an **overview** of React Native and how setup your environment.
- [Learn the Basics](https://reactnative.dev/docs/getting-started) - a **guided tour** of the React Native **basics**.
- [Blog](https://reactnative.dev/blog) - read the latest official React Native **Blog** posts.
- [`@facebook/react-native`](https://github.com/facebook/react-native) - the Open Source; GitHub **repository** for React Native.
