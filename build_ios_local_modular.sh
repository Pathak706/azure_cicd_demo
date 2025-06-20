#!/bin/bash
set -e

# Function to display usage information
usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --check-xcode      Check Xcode version"
  echo "  --clean-install    Clean node_modules and reinstall"
  echo "  --pods             Install CocoaPods"
  echo "  --check-firebase   Verify Firebase configuration"
  echo "  --update-version   Update app version in Info.plist"
  echo "  --build            Build iOS app"
  echo "  --create-ipa       Create demo IPA file"
  echo "  --all              Run all steps (default)"
  exit 1
}

# Parse command line arguments
if [ $# -eq 0 ]; then
  RUN_ALL=true
else
  RUN_ALL=false
  while [ $# -gt 0 ]; do
    case "$1" in
      --check-xcode) CHECK_XCODE=true ;;
      --clean-install) CLEAN_INSTALL=true ;;
      --pods) INSTALL_PODS=true ;;
      --check-firebase) CHECK_FIREBASE=true ;;
      --update-version) UPDATE_VERSION=true ;;
      --build) BUILD_APP=true ;;
      --create-ipa) CREATE_IPA=true ;;
      --all) RUN_ALL=true ;;
      *) usage ;;
    esac
    shift
  done
fi

# If --all is specified, run all steps
if [ "$RUN_ALL" = true ]; then
  CHECK_XCODE=true
  CLEAN_INSTALL=true
  INSTALL_PODS=true
  CHECK_FIREBASE=true
  UPDATE_VERSION=true
  BUILD_APP=true
  CREATE_IPA=true
fi

# Print commands before executing them
set -x

# Check Xcode version
if [ "$CHECK_XCODE" = true ]; then
  echo "Checking Xcode version..."
  xcodebuild -version
fi

# Clean node_modules and reinstall
if [ "$CLEAN_INSTALL" = true ]; then
  echo "Cleaning node_modules and reinstalling..."
  rm -rf node_modules
  npm ci
fi

# Install CocoaPods
if [ "$INSTALL_PODS" = true ]; then
  echo "Installing CocoaPods dependencies..."

  # Check if CocoaPods is installed
  if ! command -v pod &> /dev/null; then
    echo "Error: CocoaPods is not installed."
    echo "Please install CocoaPods manually using one of the following methods:"
    echo "  - sudo gem install cocoapods"
    echo "  - brew install cocoapods"
    echo "Then run this script again."
    exit 1
  fi

  echo "CocoaPods is installed. Installing project dependencies..."
  cd ios && pod install
  cd ..
fi

# Verify Firebase configuration
if [ "$CHECK_FIREBASE" = true ]; then
  echo "Verifying Firebase configuration..."
  if [ -f ios/GoogleService-Info.plist ]; then
    echo "Using existing GoogleService-Info.plist file"
  else
    echo "Error: GoogleService-Info.plist file not found"
    exit 1
  fi
fi

# Update app version
if [ "$UPDATE_VERSION" = true ]; then
  echo "Updating app version..."
  # Get version from package.json
  VERSION=$(node -p "require('./package.json').version")
  echo "Using version from package.json: $VERSION"

  # Get current build number from project.pbxproj
  CURRENT_BUILD_NUMBER=$(grep -m 1 "CURRENT_PROJECT_VERSION = " ios/azure_cicd_demo.xcodeproj/project.pbxproj | awk '{print $3}' | sed 's/;//')
  NEW_BUILD_NUMBER=$((CURRENT_BUILD_NUMBER + 1))
  echo "Incrementing build number from $CURRENT_BUILD_NUMBER to $NEW_BUILD_NUMBER"

  # Update version and build number in project.pbxproj
  sed -i '' "s/MARKETING_VERSION = [^;]*/MARKETING_VERSION = $VERSION/" ios/azure_cicd_demo.xcodeproj/project.pbxproj
  sed -i '' "s/CURRENT_PROJECT_VERSION = [^;]*/CURRENT_PROJECT_VERSION = $NEW_BUILD_NUMBER/" ios/azure_cicd_demo.xcodeproj/project.pbxproj

  echo "Updated project.pbxproj with new version information"
fi

# Build iOS app
if [ "$BUILD_APP" = true ]; then
  echo "Building iOS app..."
  cd ios
  mkdir -p build/logs

  # Run the build with verbose output and save logs
  set -o pipefail && xcodebuild -workspace azure_cicd_demo.xcworkspace \
    -scheme azure_cicd_demo \
    -configuration Debug \
    -sdk iphonesimulator \
    -derivedDataPath build \
    OTHER_CPLUSPLUSFLAGS="-std=c++17 -DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1" \
    COMPILER_INDEX_STORE_ENABLE=NO \
    | tee build/logs/xcodebuild.log

  cd ..
fi

# Create demo IPA file
if [ "$CREATE_IPA" = true ]; then
  echo "Creating demo IPA file..."
  cd ios/build
  mkdir -p Payload
  cp -R Debug-iphonesimulator/azure_cicd_demo.app Payload/
  zip -r azure_cicd_demo.ipa Payload
  echo "Created demo IPA file at $(pwd)/azure_cicd_demo.ipa"
  cd ../..
fi

echo "Script completed successfully!"
