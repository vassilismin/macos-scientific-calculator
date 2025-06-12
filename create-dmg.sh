#!/bin/bash

# DMG creation script for Calculator app

APP_NAME="Scientific Calculator"
BUNDLE_NAME="$APP_NAME.app"
BUNDLE_PATH="build/$BUNDLE_NAME"
DMG_NAME="Scientific-Calculator-Installer"
DMG_PATH="build/$DMG_NAME.dmg"
TEMP_DMG_PATH="build/temp.dmg"

echo "Creating DMG installer for Calculator app..."

# Check if app bundle exists
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "Error: App bundle not found. Run build.sh first."
    exit 1
fi

# Clean up previous DMG
rm -f "$DMG_PATH" "$TEMP_DMG_PATH"

# Create temporary DMG directory
TEMP_DIR=$(mktemp -d)
DMG_DIR="$TEMP_DIR/dmg"
mkdir -p "$DMG_DIR"

echo "Preparing DMG contents..."

# Copy app to DMG directory
cp -R "$BUNDLE_PATH" "$DMG_DIR/"

# Create Applications symlink
ln -sf /Applications "$DMG_DIR/Applications"

# Create README file
cat > "$DMG_DIR/README.txt" << EOF
Scientific Calculator for macOS

Installation Instructions:
1. Drag the Scientific Calculator app to the Applications folder
2. Launch from Applications or Spotlight

Features:
• Basic arithmetic operations (+, -, ×, ÷)
• Scientific functions (sin, cos, tan, log, ln)
• Memory functions (MC, MR, M+, M-)
• Power and root operations (x², √, x^y)
• Constants (π, e)
• Parentheses support
• Degree/Radian toggle
• Calculation history
• Keyboard shortcuts

Keyboard Shortcuts:
• Numbers: 0-9
• Operations: +, -, *, /, ^
• Equals: = or Enter
• Clear: C
• Parentheses: (, )
• Functions: s(in), o(cos), t(an), l(og), n(ln), r(oot)
• Constants: p(π), e
• History: h

System Requirements:
• macOS 12.0 or later

Copyright © 2024 Calculator App. All rights reserved.
EOF

# Calculate size for DMG (add some padding)
SIZE=$(du -sm "$DMG_DIR" | cut -f1)
SIZE=$((SIZE + 10))

echo "Creating DMG image (${SIZE}MB)..."

# Create DMG
hdiutil create -srcfolder "$DMG_DIR" -volname "$APP_NAME" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDZO -size ${SIZE}m "$DMG_PATH"

if [ $? -eq 0 ]; then
    echo "DMG created successfully: $DMG_PATH"
    
    # Get DMG size
    DMG_SIZE=$(ls -lh "$DMG_PATH" | awk '{print $5}')
    echo "DMG size: $DMG_SIZE"
    
    # Verify DMG
    echo "Verifying DMG..."
    hdiutil verify "$DMG_PATH"
    
    if [ $? -eq 0 ]; then
        echo "DMG verification successful!"
        echo ""
        echo "Distribution files created:"
        echo "• App bundle: $BUNDLE_PATH"
        echo "• DMG installer: $DMG_PATH"
        echo ""
        echo "To install: Double-click the DMG and drag the app to Applications"
    else
        echo "Warning: DMG verification failed"
    fi
else
    echo "Error: Failed to create DMG"
    exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"

echo "DMG creation complete!"