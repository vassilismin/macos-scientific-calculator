import SwiftUI

struct CalculatorButtonView: View {
    let button: CalculatorButton
    @ObservedObject var calculator: Calculator
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            buttonTapped()
        }) {
            Text(buttonText)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(width: buttonWidth, height: 60)
                .background(button.backgroundColor)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var buttonWidth: CGFloat {
        return button == .zero ? 130 : 60
    }
    
    private var buttonText: String {
        if button == .angleToggle {
            return calculator.angleMode == .degrees ? "DEG" : "RAD"
        }
        return button.rawValue
    }
    
    private func buttonTapped() {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            calculator.numberPressed(button.rawValue)
        case .add:
            calculator.operationPressed(.add)
        case .subtract:
            calculator.operationPressed(.subtract)
        case .multiply:
            calculator.operationPressed(.multiply)
        case .divide:
            calculator.operationPressed(.divide)
        case .equals:
            calculator.equalsPressed()
        case .clear:
            calculator.clearPressed()
        case .decimal:
            calculator.numberPressed(".")
        case .plusMinus:
            calculator.plusMinusPressed()
        case .memoryClear:
            calculator.memoryClear()
        case .memoryRecall:
            calculator.memoryRecall()
        case .memoryAdd:
            calculator.memoryAdd()
        case .memorySubtract:
            calculator.memorySubtract()
        case .sin:
            calculator.sinPressed()
        case .cos:
            calculator.cosPressed()
        case .tan:
            calculator.tanPressed()
        case .log:
            calculator.logPressed()
        case .ln:
            calculator.lnPressed()
        case .square:
            calculator.squarePressed()
        case .squareRoot:
            calculator.squareRootPressed()
        case .power:
            calculator.powerPressed()
        case .pi:
            calculator.piPressed()
        case .e:
            calculator.ePressed()
        case .angleToggle:
            calculator.toggleAngleMode()
        case .openParen:
            calculator.openParenthesesPressed()
        case .closeParen:
            calculator.closeParenthesesPressed()
        case .backspace:
            calculator.backspacePressed()
        case .percent:
            break
        }
    }
}