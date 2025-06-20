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

## CI/CD Setup Instructions

### GitHub Actions Secrets

Add the following secrets to your GitHub repository:

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

#### Android Secrets
- `GOOGLE_SERVICES_JSON`: Base64-encoded google-services.json file
- `ANDROID_KEYSTORE`: Base64-encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD`: Password for the keystore
- `ANDROID_KEY_ALIAS`: Key alias in the keystore
- `ANDROID_KEY_PASSWORD`: Password for the key
- `FIREBASE_APP_ID_ANDROID`: Firebase App ID for Android
- `FIREBASE_SERVICE_ACCOUNT`: Firebase service account JSON content
- `ANDROID_PACKAGE_NAME`: Package name for your Android app

### Azure DevOps Variable Group

Create a variable group named `react-native-app-variables` with the following variables:

#### iOS Variables
- `IOS_P12_CERTIFICATE_FILENAME`: Filename of the p12 certificate uploaded to Secure Files
- `IOS_P12_PASSWORD`: Password for the p12 certificate
- `KEYCHAIN_PASSWORD`: Password for the temporary keychain
- `IOS_PROVISIONING_PROFILE_FILENAME`: Filename of the provisioning profile uploaded to Secure Files
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API Key ID
- `APP_STORE_CONNECT_API_KEY_ISSUER_ID`: App Store Connect API Key Issuer ID
- `APP_STORE_CONNECT_API_KEY_CONTENT`: App Store Connect API Key Content
- `TEAM_ID`: Apple Developer Team ID
- `IOS_BUNDLE_IDENTIFIER`: Bundle identifier for your iOS app
- `APPLE_ID`: Apple ID email

#### Android Variables
- `GOOGLE_SERVICES_JSON_FILENAME`: Filename of the google-services.json file uploaded to Secure Files
- `ANDROID_KEYSTORE_FILENAME`: Filename of the keystore file uploaded to Secure Files
- `ANDROID_KEYSTORE_PASSWORD`: Password for the keystore
- `ANDROID_KEY_ALIAS`: Key alias in the keystore
- `ANDROID_KEY_PASSWORD`: Password for the key
- `FIREBASE_APP_ID_ANDROID`: Firebase App ID for Android
- `FIREBASE_SERVICE_ACCOUNT_FILENAME`: Filename of the Firebase service account JSON file uploaded to Secure Files
- `ANDROID_PACKAGE_NAME`: Package name for your Android app

### Azure DevOps Secure Files

Upload the following files to Azure DevOps Secure Files:

1. iOS p12 certificate
2. iOS provisioning profile
3. Android keystore
4. google-services.json
5. Firebase service account JSON

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
