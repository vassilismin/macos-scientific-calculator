import SwiftUI

struct DisplayView: View {
    let display: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(display)
                .font(.system(size: 42, weight: .light, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
        .padding(.horizontal, 20)
        .frame(height: 90)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}