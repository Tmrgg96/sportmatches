import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SportMatchViewModel()
    @StateObject private var favoritesManager = FavoritesManager()
    @State private var selectedSport: String = "tennis"
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if selectedTab == 0 {
                    HStack {
                        SportButton(title: "Теннис", sportType: "tennis", selectedSport: $selectedSport) {
                            viewModel.filterMatches(by: "tennis")
                        }

                        Spacer()

                        SportButton(title: "Футбол", sportType: "football", selectedSport: $selectedSport) {
                            viewModel.filterMatches(by: "football")
                        }

                        Spacer()

                        SportButton(title: "Баскетбол", sportType: "basketball", selectedSport: $selectedSport) {
                            viewModel.filterMatches(by: "basketball")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }

                ZStack {
                    switch selectedTab {
                    case 0:
                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                        } else if let error = viewModel.error {
                            VStack {
                                Text(error)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Button("Повторить") {
                                    viewModel.fetchMatches()
                                }
                                .padding()
                            }
                        } else if viewModel.filteredMatches.isEmpty {
                            Text("Нет доступных матчей")
                                .foregroundColor(.gray)
                        } else {
                            List(viewModel.filteredMatches, id: \.match_id) { match in
                                MatchCardView(match: match)
                                    .padding(.vertical, 4)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                        }
                        
                    case 1:
                        List(favoritesManager.favoriteMatches, id: \.match_id) { match in
                            MatchCardView(match: match)
                                .padding(.vertical, 4)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        
                    case 2:
                        Text("Настройки")
                            .font(.largeTitle)
                            .padding()
                        
                    default:
                        EmptyView()
                    }
                }
                .navigationTitle(getNavigationTitle())

                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(favoritesManager)
        .onAppear {
            viewModel.fetchMatches()
        }
    }
    
    private func getNavigationTitle() -> String {
        if selectedTab == 0 {
            switch selectedSport {
            case "tennis": return "Теннисные матчи"
            case "football": return "Футбольные матчи"
            case "basketball": return "Баскетбольные матчи"
            default: return "Матчи"
            }
        } else if selectedTab == 1 {
            return "Избранное"
        } else {
            return "Настройки"
        }
    }
}
