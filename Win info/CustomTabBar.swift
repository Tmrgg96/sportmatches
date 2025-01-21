import SwiftUI // Не забудь импортировать SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int // @Binding для связи с внешним состоянием

    var body: some View {
        HStack {
            // Вкладка "Прогнозы"
            Button(action: {
                selectedTab = 0
            }) {
                VStack {
                    Image(systemName: "chart.bar.fill")
                    Text("Прогнозы")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 0 ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)

            // Вкладка "Избранное"
            Button(action: {
                selectedTab = 1
            }) {
                VStack {
                    Image(systemName: "heart.fill")
                    Text("Избранное")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 1 ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)

            // Вкладка "Настройки"
            Button(action: {
                selectedTab = 2
            }) {
                VStack {
                    Image(systemName: "gearshape.fill")
                    Text("Настройки")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 2 ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .shadow(radius: 2)
    }
}
