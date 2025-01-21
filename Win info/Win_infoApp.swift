import SwiftUI
import FirebaseCore // Импортируем FirebaseCore
import SDWebImageSVGCoder // Импортируем SDWebImageSVGCoder, если используешь SVG

@main
struct Win_infoApp: App {
    init() {
        FirebaseApp.configure() // Инициализируем Firebase
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared) // Настройка SVG Coder, если используешь SVG
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
