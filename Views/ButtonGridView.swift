import SwiftUI

struct ButtonGridView: View {
    @ObservedObject var calculator: Calculator
    
    let buttons: [[CalculatorButton]] = [
        [.sin, .cos, .tan, .angleToggle],
        [.log, .ln, .square, .squareRoot],
        [.pi, .e, .power, .divide],
        [.memoryClear, .memoryRecall, .memoryAdd, .memorySubtract],
        [.openParen, .closeParen, .clear, .backspace],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .plusMinus, .equals]
    ]
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButtonView(
                            button: button,
                            calculator: calculator
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }
}

enum CalculatorButton: String, CaseIterable {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case add = "+"
    case subtract = "−"
    case multiply = "×"
    case divide = "÷"
    case equals = "="
    case clear = "C"
    case decimal = "."
    case percent = "%"
    case plusMinus = "±"
    case memoryClear = "MC"
    case memoryRecall = "MR"
    case memoryAdd = "M+"
    case memorySubtract = "M-"
    case sin = "sin"
    case cos = "cos"
    case tan = "tan"
    case log = "log"
    case ln = "ln"
    case square = "x²"
    case squareRoot = "√"
    case power = "xʸ"
    case pi = "π"
    case e = "e"
    case angleToggle = "DEG"
    case openParen = "("
    case closeParen = ")"
    case backspace = "⌫"
    
    var backgroundColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals, .power:
            return Color.orange
        case .clear, .plusMinus, .percent, .angleToggle, .openParen, .closeParen, .backspace:
            return Color.gray
        case .memoryClear, .memoryRecall, .memoryAdd, .memorySubtract:
            return Color.blue
        case .sin, .cos, .tan, .log, .ln, .square, .squareRoot, .pi, .e:
            return Color.purple
        default:
            return Color(.darkGray)
        }
    }
}