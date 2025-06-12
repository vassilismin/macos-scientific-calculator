// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Calculator",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "Calculator",
            targets: ["Calculator"]
        )
    ],
    targets: [
        .executableTarget(
            name: "Calculator",
            path: ".",
            sources: [
                "CalculatorApp.swift",
                "Calculator.swift", 
                "ContentView.swift",
                "Views/DisplayView.swift",
                "Views/ButtonGridView.swift",
                "Views/CalculatorButtonView.swift",
                "Views/HistoryView.swift"
            ]
        )
    ]
)