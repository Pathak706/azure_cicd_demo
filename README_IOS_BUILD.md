# Testing iOS Build Locally

This document provides instructions for testing the iOS build process locally before pushing changes to GitHub. This helps ensure that the build will work correctly in the GitHub Actions workflow.

## Prerequisites

- macOS with Xcode 15.1 or higher installed
- Node.js 18 or higher
- CocoaPods

## Installation

If you don't have CocoaPods installed, you can install it using one of the following methods:

```bash
# Using RubyGems
sudo gem install cocoapods

# Using Homebrew
brew install cocoapods
```

## Testing the Build Process

We've provided a modular script that allows you to test different parts of the build process individually. This script is located at the root of the project and is called `build_ios_local_modular.sh`.

### Making the Script Executable

```bash
chmod +x build_ios_local_modular.sh
```

### Script Options

The script supports the following options:

- `--check-xcode`: Check Xcode version
- `--clean-install`: Clean node_modules and reinstall
- `--pods`: Install CocoaPods dependencies
- `--check-firebase`: Verify Firebase configuration
- `--update-version`: Update app version in project.pbxproj
- `--build`: Build iOS app
- `--create-ipa`: Create demo IPA file
- `--all`: Run all steps (default)

### Testing Individual Steps

You can test individual steps of the build process by running the script with the corresponding option:

```bash
# Check Xcode version
./build_ios_local_modular.sh --check-xcode

# Install CocoaPods dependencies
./build_ios_local_modular.sh --pods

# Update app version
./build_ios_local_modular.sh --update-version

# Build iOS app
./build_ios_local_modular.sh --build

# Create demo IPA file
./build_ios_local_modular.sh --create-ipa
```

### Testing the Complete Build Process

To test the complete build process, run the script without any options or with the `--all` option:

```bash
./build_ios_local_modular.sh
```

or

```bash
./build_ios_local_modular.sh --all
```

## Troubleshooting

### CocoaPods Installation Issues

If you encounter issues with CocoaPods installation, try the following:

1. Make sure you have the latest version of Ruby installed
2. Try installing CocoaPods with sudo: `sudo gem install cocoapods`
3. If using Homebrew, make sure it's updated: `brew update` then `brew install cocoapods`

### Build Failures

If the build fails, check the following:

1. Make sure Xcode is updated to version 15.1 or higher
2. Make sure all dependencies are installed: `npm install` and `cd ios && pod install`
3. Check the build logs for specific errors

## Updating the GitHub Actions Workflow

After successfully testing the build process locally, you can update the GitHub Actions workflow file (`.github/workflows/ios.yml`) with any necessary changes. The workflow file should mirror the steps that work successfully in your local environment.