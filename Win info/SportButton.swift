import SwiftUI

struct SportButton: View {
    let title: String
    let sportType: String
    @Binding var selectedSport: String
    let action: () -> Void

    var body: some View {
        Text(title)
            .font(.system(size: 14))
            .frame(width: 109, height: 42)
            .background(
                selectedSport == sportType ? Color(hex: "#CFDFF2") : Color(hex: "#FFFFFF")  // Синий фон для активной вкладки, белый для неактивных
            )
            .foregroundColor(
                selectedSport == sportType ? .blue : .gray  // Синий текст для активной вкладки, серый для неактивных
            )
            .cornerRadius(10)
            .onTapGesture {
                selectedSport = sportType
                action()
            }
    }
}
