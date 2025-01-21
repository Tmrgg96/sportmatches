import Foundation
import FirebaseFirestore
import Combine
import Network

class SportMatchViewModel: ObservableObject {
    @Published var matches = [SportMatch]()
    @Published var filteredMatches = [SportMatch]()
    @Published var isLoading = false
    @Published var error: String?
    
    private var db = Firestore.firestore()
    private var listeners: [ListenerRegistration] = []
    private var networkMonitor = NWPathMonitor()
    private var isNetworkAvailable = true
    
    private var tennisMatches: [SportMatch] = []
    private var basketballMatches: [SportMatch] = []
    private var footballMatches: [SportMatch] = []
    
    init() {
        setupNetworkMonitoring()
    }
    
    deinit {
        listeners.forEach { $0.remove() }
        networkMonitor.cancel()
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
                if self?.isNetworkAvailable == true {
                    self?.fetchMatches() // Повторно загружаем данные при восстановлении сети
                }
            }
        }
        networkMonitor.start(queue: DispatchQueue.global())
    }
    
    func fetchMatches() {
        guard isNetworkAvailable else {
            self.error = "Отсутствует подключение к интернету"
            return
        }
        
        isLoading = true
        error = nil
        
        listeners.forEach { $0.remove() }
        listeners.removeAll()
        
        // Очищаем массивы только если это не повторная загрузка после ошибки сети
        if !matches.isEmpty {
            tennisMatches.removeAll()
            basketballMatches.removeAll()
            footballMatches.removeAll()
            matches.removeAll()
        }
        
        let tennisListener = db.collection("tennis")
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.error = "Ошибка при загрузке теннисных матчей: \(error.localizedDescription)"
                        self?.isLoading = false
                    }
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("Нет документов в коллекции tennis")
                    return
                }
                
                let matches = documents.compactMap { document -> SportMatch? in
                    do {
                        var match = try document.data(as: SportMatch.self)
                        match.sport_type = "tennis"
                        return match
                    } catch {
                        print("Ошибка декодирования теннисного матча: \(error)")
                        return nil
                    }
                }
                
                self?.updateTennisMatches(matches)
            }
        
        let basketballListener = db.collection("basketball")
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self?.error = "Ошибка при загрузке баскетбольных матчей: \(error.localizedDescription)"
                        self?.isLoading = false
                    }
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("Нет документов в коллекции basketball")
                    return
                }
                
                let matches = documents.compactMap { document -> SportMatch? in
                    do {
                        var match = try document.data(as: SportMatch.self)
                        match.sport_type = "basketball"
                        return match
                    } catch {
                        print("Ошибка декодирования баскетбольного матча: \(error)")
                        return nil
                    }
                }
                
                self?.updateBasketballMatches(matches)
            }
        
        listeners.append(contentsOf: [tennisListener, basketballListener])
    }
    
    private func updateTennisMatches(_ newMatches: [SportMatch]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tennisMatches = self.sortMatches(newMatches)
            self.filterMatches(by: "tennis") // Всегда показываем теннис по умолчанию
            self.isLoading = false
        }
    }
    
    private func updateBasketballMatches(_ newMatches: [SportMatch]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.basketballMatches = self.sortMatches(newMatches)
            if self.filteredMatches.first?.sport_type == "basketball" {
                self.filterMatches(by: "basketball")
            }
            self.isLoading = false
        }
    }
    
    private func sortMatches(_ matches: [SportMatch]) -> [SportMatch] {
        // Разделяем матчи на три группы: live, upcoming, finished
        let liveMatches = matches.filter { $0.status == "live" }
        let upcomingMatches = matches.filter { $0.status == "upcoming" }
        let finishedMatches = matches.filter { $0.status == "finished" }

        // Сортируем upcoming матчи по ближайшему времени
        let sortedUpcomingMatches = upcomingMatches.sorted { match1, match2 in
            let date1 = self.getDateFromMatch(match1)
            let date2 = self.getDateFromMatch(match2)
            return date1 < date2
        }

        // Сортируем finished матчи по времени окончания (если нужно)
        let sortedFinishedMatches = finishedMatches.sorted { match1, match2 in
            let date1 = self.getDateFromMatch(match1)
            let date2 = self.getDateFromMatch(match2)
            return date1 > date2  // Сначала более свежие матчи
        }

        // Объединяем матчи в нужном порядке
        return liveMatches + sortedUpcomingMatches + sortedFinishedMatches
    }
    
    func filterMatches(by sportType: String) {
        switch sportType {
        case "tennis":
            filteredMatches = sortMatches(tennisMatches)
        case "basketball":
            filteredMatches = sortMatches(basketballMatches)
        case "football":
            filteredMatches = sortMatches(footballMatches)
        default:
            filteredMatches = []
        }
    }
    
    private func getDateFromMatch(_ match: SportMatch) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM HH:mm"  // Формат, который используется в данных
        dateFormatter.locale = Locale(identifier: "ru_RU")  // Убедись, что локаль соответствует данным

        let dateString = "\(match.date) \(match.time)"
        if let date = dateFormatter.date(from: dateString) {
            return date
        }

        return Date()  // Если дата не распознана, возвращаем текущую дату
    }
}
