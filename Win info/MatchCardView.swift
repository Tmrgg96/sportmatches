import SwiftUI
import SDWebImageSwiftUI

struct MatchCardView: View {
    let match: SportMatch
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var isAnimating = false  // Состояние для анимации

    var body: some View {
        Button {
            let detailView = MatchDetailView(match: match)
            let hosting = UIHostingController(rootView: detailView)
            UIApplication.shared.windows.first?.rootViewController?.present(hosting, animated: true)
        } label: {
            VStack(spacing: 0) {
                // Tournament header
                HStack {
                    // Красный кружок для статуса live
                    if match.status == "live" {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                            .padding(.leading, 10)  // Отступ слева
                            .padding(.trailing, 4)  // Отступ справа
                    }
                    
                    Text(match.tournament_name)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.vertical, 16)
                        .padding(.leading, match.status == "live" ? 0 : 10)  // Убираем лишний отступ, если кружка нет
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Звездочка для избранного с анимацией
                    Image(systemName: favoritesManager.isFavorite(match: match) ? "star.fill" : "star")
                        .foregroundColor(favoritesManager.isFavorite(match: match) ? .yellow : .gray)
                        .padding(.trailing, 16)
                        .padding(.leading, 8)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)  // Анимация масштабирования
                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: isAnimating)
                        .onTapGesture {
                            favoritesManager.toggleFavorite(match: match)
                            isAnimating = true  // Запускаем анимацию
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isAnimating = false  // Возвращаем звездочку к исходному размеру
                            }
                        }
                }
                .frame(maxHeight: 50)
                .background(Color(hex: "#CFDFF2"))
                .cornerRadius(10, corners: [.topLeft, .topRight])

                // Остальная часть карточки матча
                HStack {
                    VStack {
                        if let homeFlag = match.home_flag {
                            WebImage(url: URL(string: homeFlag), options: .allowInvalidSSLCertificates) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "flag.fill")
                                    .resizable()
                                    .foregroundColor(.blue)
                            }
                            .frame(width: 60, height: 40)
                        } else {
                            Image(systemName: "flag.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 40)
                                .foregroundColor(.blue)
                        }
                        
                        Text(match.home_player)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(width: 100)
                        Text("Коэф.: \(String(format: "%.2f", match.home_odds))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text(match.date)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Отображаем сет и счет для матчей в статусе live
                        if match.status == "live" {
                            Text(match.time)  // Здесь отображается сет матча (например, "1-й сет")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text("\(match.home.score ?? "0") - \(match.away.score ?? "0")")
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                        }
                        // Отображаем "Finished" и счет для матчей в статусе finished
                        else if match.status == "finished" {
                            Text("Finished")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text("\(match.home.score ?? "0") - \(match.away.score ?? "0")")
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                        }
                        // Отображаем время для матчей в статусе upcoming
                        else {
                            Text(match.time)
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                        }
                        
                        Text("мск")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack {
                        if let awayFlag = match.away_flag {
                            WebImage(url: URL(string: awayFlag), options: .allowInvalidSSLCertificates) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "flag.fill")
                                    .resizable()
                                    .foregroundColor(.blue)
                            }
                            .frame(width: 60, height: 40)
                        } else {
                            Image(systemName: "flag.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 40)
                                .foregroundColor(.blue)
                        }
                        
                        Text(match.away_player)
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(width: 100)
                        Text("Коэф.: \(String(format: "%.2f", match.away_odds))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}
