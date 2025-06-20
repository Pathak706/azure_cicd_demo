# Guide to Upload Secure Files to Azure DevOps

This guide explains how to upload the necessary secure files to Azure DevOps for the React Native CI/CD pipeline.

## Required Secure Files

Based on the variable values provided, you need to upload the following files to Azure DevOps Secure Files:

1. **Android Keystore File**
   - Filename: `my_app_release.keystore`
   - Description: Used for signing the Android app

2. **Google Services JSON**
   - Filename: `google-services.json`
   - Description: Firebase configuration for Android

## Steps to Upload Secure Files

1. **Navigate to Azure DevOps Secure Files**
   - Go to your Azure DevOps project
   - Select "Pipelines" from the left menu
   - Select "Library" from the sub-menu
   - Select the "Secure files" tab

2. **Upload Android Keystore**
   - Click the "+ Secure file" button
   - Browse and select your keystore file
   - **Important**: Rename the file to `my_app_release.keystore` if it's not already named that
   - Add a description (optional)
   - Click "OK" to upload

3. **Upload Google Services JSON**
   - Click the "+ Secure file" button again
   - Browse and select your google-services.json file
   - **Important**: Ensure the filename is `google-services.json`
   - Add a description (optional)
   - Click "OK" to upload

## Authorize Secure Files for Use in Pipelines

After uploading the files, you need to authorize them for use in your pipeline:

1. Click on each uploaded secure file
2. Click the "Pipeline permissions" button
3. Grant permission to the pipeline that will use this file

## Verify Pipeline Configuration

The `azure-pipelines.yml` file is already configured to use these filenames:

```yaml
- task: DownloadSecureFile@1
  name: googleServicesJson
  inputs:
    secureFile: 'google-services.json'
  displayName: 'Download google-services.json'

- task: DownloadSecureFile@1
  name: androidKeystore
  inputs:
    secureFile: 'my_app_release.keystore'
  displayName: 'Download Android keystore'
```

## Troubleshooting

If you encounter the error:
```
The secure file does not exist or has not been authorized for use.
```

Check the following:
1. Verify that the files are uploaded with the exact filenames specified above
2. Ensure the files are authorized for use in your pipeline
3. Check that the variable group `react-native-app-variables` contains all the required variables:
   - ANDROID_KEY_ALIAS: my-key-alias
   - ANDROID_KEY_PASSWORD: 12341234
   - ANDROID_KEYSTORE_PASSWORD: 12341234
   - ANDROID_PACKAGE_NAME: net.techconsulting.rn_cicd_demo
   - FIREBASE_APP_ID_ANDROID: 1:1079550415658:android:a6e083b473e88ad025c453
   - FIREBASE_CLI_TOKEN: (your token)
   - FIREBASE_TESTERS: (your comma-separated list of tester emails)
