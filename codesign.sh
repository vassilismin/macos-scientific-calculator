#!/bin/bash

# Code signing script for Calculator app
# Note: Requires Apple Developer Account and certificates

APP_NAME="Scientific Calculator"
BUNDLE_NAME="$APP_NAME.app"
BUNDLE_PATH="build/$BUNDLE_NAME"

# Check if app bundle exists
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "Error: App bundle not found. Run build.sh first."
    exit 1
fi

echo "Code signing Calculator app..."

# Check for developer certificate
CERT_NAME=$(security find-identity -v -p codesigning | grep "Developer ID Application" | head -1 | sed 's/.*"//; s/".*//')

if [ -z "$CERT_NAME" ]; then
    echo "Warning: No Developer ID Application certificate found."
    echo "To sign the app for distribution outside the App Store, you need:"
    echo "1. Apple Developer Account"
    echo "2. Developer ID Application certificate installed in Keychain"
    echo ""
    echo "For development/testing, the app can run unsigned."
    exit 0
fi

echo "Using certificate: $CERT_NAME"

# Sign the app
codesign --force --options runtime --sign "$CERT_NAME" "$BUNDLE_PATH"

if [ $? -eq 0 ]; then
    echo "App signed successfully!"
    
    # Verify signature
    echo "Verifying signature..."
    codesign --verify --verbose "$BUNDLE_PATH"
    
    if [ $? -eq 0 ]; then
        echo "Signature verified!"
    else
        echo "Warning: Signature verification failed"
    fi
else
    echo "Error: Code signing failed"
    exit 1
fi