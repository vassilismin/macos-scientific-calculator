# Scientific Calculator for macOS

A full-featured scientific calculator built with SwiftUI for macOS.

## Features

### Basic Operations
- Addition, subtraction, multiplication, division
- Decimal point and negative number support
- Order of operations (PEMDAS)
- Error handling and input validation

### Scientific Functions
- Trigonometric functions (sin, cos, tan)
- Logarithmic functions (log, ln)
- Power and root operations (x², √, x^y)
- Mathematical constants (π, e)

### Advanced Features
- Memory functions (MC, MR, M+, M-)
- Parentheses for complex expressions
- Degree/Radian toggle for trigonometric functions
- Calculation history with persistent storage
- Comprehensive keyboard shortcuts

### User Interface
- Native macOS design with SwiftUI
- Responsive button layout with backspace support
- Visual feedback and animations
- History panel with clear functionality
- Input correction with backspace button

## System Requirements

- macOS 12.0 or later
- Apple Silicon or Intel processor

## Installation

### Option 1: DMG Installer (Recommended)
1. Download `Scientific-Calculator-Installer.dmg`
2. Double-click the DMG file to mount it
3. Drag "Scientific Calculator" to the Applications folder
4. Launch from Applications or Spotlight search

### Option 2: Build from Source
```bash
# Clone the repository
git clone <repository-url>
cd Calculator

# Build everything
./build-all.sh
```

## Building from Source

### Prerequisites
- Xcode 14.0 or later
- Swift 5.8 or later
- macOS development environment

### Build Steps
```bash
# Build the app
./build.sh

# Optional: Code sign (requires Apple Developer certificate)
./codesign.sh

# Create DMG installer
./create-dmg.sh

# Or build everything at once
./build-all.sh
```

### Distribution
```bash
# For App Store distribution (requires additional setup)
./notarize.sh

# For direct distribution
# Use the generated DMG file
```

## Keyboard Shortcuts

| Key | Function |
|-----|----------|
| 0-9 | Number input |
| +, -, *, / | Basic operations |
| ^ | Power |
| = or Enter | Equals |
| C | Clear |
| Delete/Backspace | Backspace |
| ( , ) | Parentheses |
| . | Decimal point |
| s | Sine |
| o | Cosine |
| t | Tangent |
| l | Logarithm (log) |
| n | Natural log (ln) |
| r | Square root |
| p | Pi (π) |
| e | Euler's number (e) |
| h | Show history |

## Project Structure

```
Calculator/
├── Calculator.swift          # Core calculation logic
├── CalculatorApp.swift      # App entry point
├── ContentView.swift        # Main view controller
├── Views/
│   ├── DisplayView.swift    # Calculator display
│   ├── ButtonGridView.swift # Button layout
│   ├── CalculatorButtonView.swift # Individual buttons
│   └── HistoryView.swift    # History interface
├── Package.swift            # Swift Package Manager
├── Info.plist              # App metadata
└── Build Scripts/
    ├── build.sh            # Build app bundle
    ├── codesign.sh         # Code signing
    ├── notarize.sh         # Notarization
    ├── create-dmg.sh       # DMG creation
    └── build-all.sh        # Complete build process
```

## Development

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive state management
- **Native macOS**: Platform-optimized experience

### Key Components
- `Calculator`: Core calculation engine with order of operations
- `ContentView`: Main interface with keyboard handling
- `ButtonGridView`: Organized button layout with color coding
- `HistoryView`: Calculation history management

## License

Copyright © 2024 Calculator App. All rights reserved.

## Contributing

This is a complete implementation of a scientific calculator. The codebase follows SwiftUI best practices and is ready for distribution.

## Support

For issues or questions:
1. Check the keyboard shortcuts above
2. Verify system requirements
3. Try rebuilding from source if installation issues occur