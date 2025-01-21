import SwiftUI
import SDWebImageSwiftUI

struct MatchDetailView: View {
    let match: SportMatch
    @State private var note: String = ""
    @AppStorage private var savedNote: String
    
    init(match: SportMatch) {
        self.match = match
        self._savedNote = AppStorage(wrappedValue: "", "note_\(match.match_id)")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Карточка матча
                VStack(spacing: 0) {
                    HStack {
                        Text(match.tournament_name)
                            .font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.vertical, 16)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 50)
                    .background(Color(hex: "#CFDFF2"))
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                    
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
                            
                            Text(match.time)
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                            
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
                
                // Заметки
                VStack(alignment: .leading) {
                    Text("Заметка")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    TextEditor(text: $note)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: note) { newValue in
                            savedNote = newValue
                        }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 20)
        }
        .navigationTitle("Детали матча")
        .onAppear {
            note = savedNote
        }
    }
}
