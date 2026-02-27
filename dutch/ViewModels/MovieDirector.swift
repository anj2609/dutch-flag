import SwiftUI
import Combine

class MovieDirector: ObservableObject {
    enum SceneType {
        case launch
        case scene1
        case scene2
        case scene3
        // Future scenes can be added here
    }
    
    @Published var currentScene: SceneType = .launch
    @Published var fadeOpacity: Double = 0.0 // 0.0 = Transparent, 1.0 = Black
    
    func transition(to scene: SceneType) {
        // Fade out
        withAnimation(.easeOut(duration: 1.0)) {
            fadeOpacity = 1.0
        }
        
        // Switch scene after fade
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentScene = scene
            
            // Fade in
            withAnimation(.easeIn(duration: 1.0)) {
                self.fadeOpacity = 0.0
            }
        }
    }
}
