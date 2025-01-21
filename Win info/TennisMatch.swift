import Foundation
import FirebaseFirestore

struct TennisMatch: Identifiable, Codable {
    var id: String? // Используем обычный String вместо @DocumentID
    var away_flag: String?
    var away_odds: Double
    var away_player: String
    var home_flag: String?
    var home_odds: Double
    var home_player: String
    var last_updated: String
    var match_id: String
    var match_link: String
    var start_time: String
    var tournament_name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case away_flag
        case away_odds
        case away_player
        case home_flag
        case home_odds
        case home_player
        case last_updated
        case match_id
        case match_link
        case start_time
        case tournament_name
    }
}
