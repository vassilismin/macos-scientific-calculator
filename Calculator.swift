import Foundation

let euler = 2.718281828459045

struct ParenthesesContext {
    let previousNumber: Double
    let operation: Calculator.Operation?
    let display: String
    
    func encode() -> String {
        let opString = operation?.rawValue ?? "nil"
        return "\(previousNumber)|\(opString)|\(display)"
    }
    
    static func decode(_ string: String) -> ParenthesesContext {
        let parts = string.components(separatedBy: "|")
        guard parts.count == 3 else {
            return ParenthesesContext(previousNumber: 0, operation: nil, display: "0")
        }
        
        let previousNumber = Double(parts[0]) ?? 0
        let operation = parts[1] == "nil" ? nil : Calculator.Operation(rawValue: parts[1])
        let display = parts[2]
        
        return ParenthesesContext(previousNumber: previousNumber, operation: operation, display: display)
    }
}

class Calculator: ObservableObject {
    @Published var display = "0"
    @Published var angleMode: AngleMode = .degrees
    
    private var currentNumber: Double = 0
    private var previousNumber: Double = 0
    private var operation: Operation?
    private var userIsTyping = false
    private var operationQueue: [(Double, Operation)] = []
    private var memory: Double = 0
    private var parenthesesStack: [String] = []
    private var hasOpenParentheses: Bool { !parenthesesStack.isEmpty }
    @Published var calculationHistory: [String] = []
    
    enum AngleMode {
        case degrees
        case radians
    }
    
    enum Operation: String {
        case add = "+"
        case subtract = "−"
        case multiply = "×"
        case divide = "÷"
        case power = "^"
        
        var precedence: Int {
            switch self {
            case .add, .subtract:
                return 1
            case .multiply, .divide:
                return 2
            case .power:
                return 3
            }
        }
    }
    
    func numberPressed(_ number: String) {
        if display == "Error" {
            display = "0"
            userIsTyping = false
        }
        
        if userIsTyping {
            if number == "." && display.contains(".") {
                return
            }
            let maxLength = display.hasPrefix("-") ? 11 : 10
            if display.count >= maxLength {
                return
            }
            display = display + number
        } else {
            if number == "." {
                display = "0."
            } else {
                display = number
            }
            userIsTyping = true
        }
    }
    
    func operationPressed(_ op: Operation) {
        if display == "Error" {
            clearPressed()
        }
        
        let currentValue = Double(display) ?? 0
        
        if let pendingOp = operation {
            if pendingOp.precedence >= op.precedence {
                let result = performOperation(previousNumber, currentValue, pendingOp)
                display = formatNumber(result)
                previousNumber = result
            } else {
                operationQueue.append((previousNumber, pendingOp))
                previousNumber = currentValue
            }
        } else {
            previousNumber = currentValue
        }
        
        operation = op
        userIsTyping = false
    }
    
    func equalsPressed() {
        guard operation != nil else { return }
        
        let expression = buildExpression()
        calculate()
        
        while !operationQueue.isEmpty {
            let (savedNumber, savedOp) = operationQueue.removeLast()
            let result = performOperation(savedNumber, Double(display) ?? 0, savedOp)
            display = formatNumber(result)
        }
        
        if !expression.isEmpty && display != "Error" {
            let historyEntry = "\(expression) = \(display)"
            calculationHistory.append(historyEntry)
            if calculationHistory.count > 10 {
                calculationHistory.removeFirst()
            }
        }
        
        operation = nil
    }
    
    func clearPressed() {
        display = "0"
        currentNumber = 0
        previousNumber = 0
        operation = nil
        userIsTyping = false
        operationQueue.removeAll()
        parenthesesStack.removeAll()
    }
    
    func clearHistory() {
        calculationHistory.removeAll()
    }
    
    private func buildExpression() -> String {
        guard let op = operation else { return display }
        let prevFormatted = formatNumber(previousNumber)
        return "\(prevFormatted) \(op.rawValue) \(display)"
    }
    
    func memoryAdd() {
        if display != "Error" {
            memory += Double(display) ?? 0
        }
    }
    
    func memorySubtract() {
        if display != "Error" {
            memory -= Double(display) ?? 0
        }
    }
    
    func memoryRecall() {
        display = formatNumber(memory)
        userIsTyping = false
    }
    
    func memoryClear() {
        memory = 0
    }
    
    func sinPressed() {
        if display == "Error" { return }
        let value = Double(display) ?? 0
        let radians = angleMode == .degrees ? value * .pi / 180 : value
        let result = sin(radians)
        display = formatNumber(result)
        userIsTyping = false
    }
    
    func cosPressed() {
        if display == "Error" { return }
        let value = Double(display) ?? 0
        let radians = angleMode == .degrees ? value * .pi / 180 : value
        let result = cos(radians)
        display = formatNumber(result)
        userIsTyping = false
    }
    
    func tanPressed() {
        if display == "Error" { return }
        let value = Double(display) ?? 0
        let radians = angleMode == .degrees ? value * .pi / 180 : value
        let result = tan(radians)
        if result.isInfinite || result.isNaN {
            display = "Error"
        } else {
            display = formatNumber(result)
        }
        userIsTyping = false
    }
    
    func toggleAngleMode() {
        angleMode = angleMode == .degrees ? .radians : .degrees
    }
    
    func logPressed() {
        if display == "Error" { return }
        let value = Double(display) ?? 0
        if value > 0 {
            let result = log10(value)
            display = formatNumber(result)
        } else {
            display = "Error"
        }
        userIsTyping = false
    }
    
    func lnPressed() {
        if display == "Error" { return }
        let value = Double(display) ?? 0
        if value > 0 {
            let result = log(value)
            display = formatNumber(result)
        } else {
            display = "Error"
        }
        userIsTyping = false
    }
    
    func squarePressed() {
        if display == "Error" { return }
        let value = Double(display) ?? 0
        let result = value * value
        display = formatNumber(result)
        userIsTyping = false
    }
    
    func squareRootPressed() {
        if display == "Error" { return }
        let value = Double(display) ?? 0
        if value >= 0 {
            let result = sqrt(value)
            display = formatNumber(result)
        } else {
            display = "Error"
        }
        userIsTyping = false
    }
    
    func powerPressed() {
        operationPressed(.power)
    }
    
    func piPressed() {
        display = formatNumber(.pi)
        userIsTyping = false
    }
    
    func ePressed() {
        display = formatNumber(euler)
        userIsTyping = false
    }
    
    func openParenthesesPressed() {
        if userIsTyping {
            operationPressed(.multiply)
        }
        
        let context = ParenthesesContext(
            previousNumber: previousNumber,
            operation: operation,
            display: display
        )
        parenthesesStack.append(context.encode())
        
        display = "0"
        previousNumber = 0
        operation = nil
        userIsTyping = false
    }
    
    func closeParenthesesPressed() {
        guard !parenthesesStack.isEmpty else { return }
        
        if operation != nil {
            calculate()
        }
        
        let contextString = parenthesesStack.removeLast()
        let context = ParenthesesContext.decode(contextString)
        let currentResult = Double(display) ?? 0
        
        previousNumber = context.previousNumber
        operation = context.operation
        
        if let op = operation {
            let result = performOperation(previousNumber, currentResult, op)
            display = formatNumber(result)
            operation = nil
        } else {
            display = formatNumber(currentResult)
        }
        
        userIsTyping = false
    }
    
    func plusMinusPressed() {
        if display == "Error" { return }
        
        if display == "0" {
            return
        }
        
        if display.hasPrefix("-") {
            display = String(display.dropFirst())
        } else {
            display = "-" + display
        }
    }
    
    private func calculate() {
        guard let operation = operation else { return }
        currentNumber = Double(display) ?? 0
        let result = performOperation(previousNumber, currentNumber, operation)
        display = formatNumber(result)
        userIsTyping = false
    }
    
    private func performOperation(_ left: Double, _ right: Double, _ op: Operation) -> Double {
        switch op {
        case .add:
            return left + right
        case .subtract:
            return left - right
        case .multiply:
            return left * right
        case .divide:
            if right != 0 {
                return left / right
            } else {
                display = "Error"
                return 0
            }
        case .power:
            let result = pow(left, right)
            if result.isInfinite || result.isNaN {
                display = "Error"
                return 0
            }
            return result
        }
    }
    
    private func formatNumber(_ number: Double) -> String {
        if number.isInfinite || number.isNaN {
            return "Error"
        }
        
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            let intValue = Int(number)
            return String(intValue)
        } else {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 6
            formatter.minimumFractionDigits = 0
            return formatter.string(from: NSNumber(value: number)) ?? "Error"
        }
    }
}