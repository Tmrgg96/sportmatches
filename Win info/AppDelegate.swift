import SwiftUI
import SDWebImageSVGCoder

struct Win_infoapp: App {
    init() {
        // Настройка SVG Coder
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
