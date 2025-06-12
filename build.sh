#!/bin/bash

# Build script for Calculator app

echo "Building Calculator app..."

# Clean previous builds
rm -rf build/
mkdir -p build

# Build the app using swift build
swift build -c release

# Create app bundle structure
APP_NAME="Scientific Calculator"
BUNDLE_NAME="$APP_NAME.app"
BUNDLE_PATH="build/$BUNDLE_NAME"

mkdir -p "$BUNDLE_PATH/Contents/MacOS"
mkdir -p "$BUNDLE_PATH/Contents/Resources"

# Copy executable
cp .build/release/Calculator "$BUNDLE_PATH/Contents/MacOS/"

# Copy Info.plist
cp Info.plist "$BUNDLE_PATH/Contents/"

echo "App built successfully at: $BUNDLE_PATH"
echo "You can run it with: open \"$BUNDLE_PATH\""