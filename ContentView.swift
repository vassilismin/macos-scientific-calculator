import SwiftUI

struct ContentView: View {
    @StateObject private var calculator = Calculator()
    @State private var showingHistory = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                    showingHistory = true
                }) {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(8)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(.trailing, 16)
                .padding(.top, 8)
            }
            .frame(height: 40)
            
            DisplayView(display: calculator.display)
            ButtonGridView(calculator: calculator)
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .frame(width: 310, height: 660)
        .sheet(isPresented: $showingHistory) {
            HistoryView(calculator: calculator, isPresented: $showingHistory)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { _ in
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                handleKeyPress(event: event)
                return nil
            }
        }
    }
    
    private func handleKeyPress(event: NSEvent) {
        let key = event.charactersIgnoringModifiers ?? ""
        
        switch key {
        case "0"..."9":
            calculator.numberPressed(key)
        case ".":
            calculator.numberPressed(".")
        case "+":
            calculator.operationPressed(.add)
        case "-":
            calculator.operationPressed(.subtract)
        case "*":
            calculator.operationPressed(.multiply)
        case "/":
            calculator.operationPressed(.divide)
        case "^":
            calculator.operationPressed(.power)
        case "=", "\r":
            calculator.equalsPressed()
        case "c", "C":
            calculator.clearPressed()
        case "(":
            calculator.openParenthesesPressed()
        case ")":
            calculator.closeParenthesesPressed()
        case "s":
            calculator.sinPressed()
        case "o":
            calculator.cosPressed()
        case "t":
            calculator.tanPressed()
        case "l":
            calculator.logPressed()
        case "n":
            calculator.lnPressed()
        case "r":
            calculator.squareRootPressed()
        case "p":
            calculator.piPressed()
        case "e":
            calculator.ePressed()
        case "h":
            showingHistory = true
        default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}