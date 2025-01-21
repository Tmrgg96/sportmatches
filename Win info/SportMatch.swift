struct SportMatch: Identifiable, Codable, Equatable {
    var id: String?
    var away: TeamData
    var home: TeamData
    var last_updated: String
    var match_id: String
    var match_link: String
    var tournament_name: String
    var status: String
    var time: String
    var date: String
    var sport_type: String?
    
    struct TeamData: Codable, Equatable {
        var flag: String?
        var name: String
        var odds: Double?  // Сделай odds опциональным
        var score: String?
    }
    
    // Вычисляемые свойства для совместимости со старым кодом
    var away_flag: String? { away.flag }
    var away_odds: Double { away.odds ?? 0.0 }  // Укажи значение по умолчанию
    var away_player: String { away.name }
    var home_flag: String? { home.flag }
    var home_odds: Double { home.odds ?? 0.0 }  // Укажи значение по умолчанию
    var home_player: String { home.name }
    var start_time: String { date }
    
    enum CodingKeys: String, CodingKey {
        case id
        case away
        case home
        case last_updated
        case match_id
        case match_link
        case tournament_name
        case status
        case time
        case date
        case sport_type
    }
    
    static func == (lhs: SportMatch, rhs: SportMatch) -> Bool {
        return lhs.match_id == rhs.match_id
    }
}
