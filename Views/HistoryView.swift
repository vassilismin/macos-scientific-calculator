import SwiftUI

struct HistoryView: View {
    @ObservedObject var calculator: Calculator
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if calculator.calculationHistory.isEmpty {
                    Spacer()
                    Text("No calculations yet")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(calculator.calculationHistory.reversed(), id: \.self) { entry in
                            Text(entry)
                                .font(.system(.body, design: .monospaced))
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        calculator.clearHistory()
                    }
                    .disabled(calculator.calculationHistory.isEmpty)
                }
            }
        }
    }
}