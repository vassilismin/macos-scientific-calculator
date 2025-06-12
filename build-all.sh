#!/bin/bash

# Master build script - builds everything for distribution

echo "=== Scientific Calculator - Complete Build Process ==="
echo ""

# Step 1: Build the app
echo "Step 1: Building application..."
./build.sh

if [ $? -ne 0 ]; then
    echo "Error: App build failed"
    exit 1
fi

echo ""

# Step 2: Code signing (optional, will warn if no certificate)
echo "Step 2: Code signing..."
./codesign.sh

echo ""

# Step 3: Create DMG installer
echo "Step 3: Creating DMG installer..."
./create-dmg.sh

if [ $? -ne 0 ]; then
    echo "Error: DMG creation failed"
    exit 1
fi

echo ""
echo "=== Build Complete! ==="
echo ""
echo "Distribution files:"
echo "• App: build/Scientific Calculator.app"
echo "• Installer: build/Scientific-Calculator-Installer.dmg"
echo ""
echo "Optional next steps:"
echo "• Run ./notarize.sh (requires Apple Developer Account)"
echo "• Test the DMG installer on a clean macOS system"
echo ""
echo "To distribute:"
echo "1. Share the DMG file with users"
echo "2. Users double-click DMG and drag app to Applications"
echo "3. App will be available in Applications folder and Spotlight"