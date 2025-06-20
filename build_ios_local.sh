#!/bin/bash
set -e

# Print commands before executing them
set -x

echo "Checking Xcode version..."
xcodebuild -version

echo "Cleaning node_modules and reinstalling..."
rm -rf node_modules
npm ci

echo "Installing CocoaPods..."
cd ios && pod install
cd ..

echo "Verifying Firebase configuration..."
if [ -f ios/GoogleService-Info.plist ]; then
  echo "Using existing GoogleService-Info.plist file"
else
  echo "Error: GoogleService-Info.plist file not found"
  exit 1
fi

echo "Updating app version..."
# Get version from package.json
VERSION=$(node -p "require('./package.json').version")
echo "Using version from package.json: $VERSION"

# Get current build number from Info.plist
CURRENT_BUILD_NUMBER=$(defaults read $(pwd)/ios/azure_cicd_demo/Info.plist CFBundleVersion || echo "1")
NEW_BUILD_NUMBER=$((CURRENT_BUILD_NUMBER + 1))
echo "Incrementing build number from $CURRENT_BUILD_NUMBER to $NEW_BUILD_NUMBER"

# Update version and build number in Info.plist
plutil -replace CFBundleShortVersionString -string "$VERSION" ios/azure_cicd_demo/Info.plist
plutil -replace CFBundleVersion -string "$NEW_BUILD_NUMBER" ios/azure_cicd_demo/Info.plist

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

echo "Creating demo IPA file..."
cd build
mkdir -p Payload
cp -R Debug-iphonesimulator/azure_cicd_demo.app Payload/
zip -r azure_cicd_demo.ipa Payload
echo "Created demo IPA file at $(pwd)/azure_cicd_demo.ipa"

echo "Build completed successfully!"