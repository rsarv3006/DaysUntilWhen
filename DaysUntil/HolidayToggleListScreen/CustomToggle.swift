import Foundation
import GRDB
import SwiftUI
import WidgetKit

struct CustomToggle: View {
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isOn ? color : Color(.systemGray4))
                    .frame(width: 50, height: 30)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: isOn ? 10 : -10)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
