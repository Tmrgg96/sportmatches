import Foundation

class FavoritesManager: ObservableObject {
    @Published var favoriteMatches: [SportMatch] = []
    private let favoritesKey = "favoriteMatches"

    init() {
        loadFavorites()
    }

    func toggleFavorite(match: SportMatch) {
        if let index = favoriteMatches.firstIndex(where: { $0.match_id == match.match_id }) {
            favoriteMatches.remove(at: index)
        } else {
            favoriteMatches.append(match)
        }
        saveFavorites()
    }

    func isFavorite(match: SportMatch) -> Bool {
        return favoriteMatches.contains(where: { $0.match_id == match.match_id })
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteMatches) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([SportMatch].self, from: data) {
            favoriteMatches = decoded
        }
    }
}
