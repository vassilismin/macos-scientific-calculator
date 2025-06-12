#!/bin/bash

# Notarization script for Calculator app
# Note: Requires Apple Developer Account and app-specific password

APP_NAME="Scientific Calculator"
BUNDLE_NAME="$APP_NAME.app"
BUNDLE_PATH="build/$BUNDLE_NAME"
ZIP_PATH="build/Calculator.zip"

# Configuration (replace with your Apple ID and team ID)
APPLE_ID="your-apple-id@example.com"
TEAM_ID="YOUR_TEAM_ID"

echo "Preparing app for notarization..."

# Check if app is signed
if ! codesign --verify "$BUNDLE_PATH" 2>/dev/null; then
    echo "Error: App must be code signed before notarization. Run codesign.sh first."
    exit 1
fi

# Create zip for notarization
echo "Creating zip archive..."
cd build
zip -r "Calculator.zip" "$BUNDLE_NAME"
cd ..

if [ ! -f "$ZIP_PATH" ]; then
    echo "Error: Failed to create zip archive"
    exit 1
fi

echo "Submitting app for notarization..."
echo "Note: You need to set up an app-specific password for your Apple ID"
echo "Visit: https://appleid.apple.com/account/manage -> Sign-In and Security -> App-Specific Passwords"

# Submit for notarization
xcrun notarytool submit "$ZIP_PATH" \
    --apple-id "$APPLE_ID" \
    --team-id "$TEAM_ID" \
    --password "@keychain:notarization-password" \
    --wait

if [ $? -eq 0 ]; then
    echo "Notarization successful!"
    
    # Staple the notarization
    echo "Stapling notarization..."
    xcrun stapler staple "$BUNDLE_PATH"
    
    if [ $? -eq 0 ]; then
        echo "Notarization stapled successfully!"
    else
        echo "Warning: Failed to staple notarization"
    fi
else
    echo "Error: Notarization failed"
    echo "Check your Apple ID, team ID, and app-specific password"
fi