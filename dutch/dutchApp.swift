import SwiftUI

@main
struct dutchApp: App {
    @StateObject private var director = MovieDirector()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Scene Switcher
                Group {
                    switch director.currentScene {
                    case .launch:
                        LaunchView()
                    case .scene1:
                        Scene1View()
                    case .scene2:
                        Scene2View()
                    case .scene3:
                        Scene3View()
                    }
                }
                .transition(.identity) // Disable default transitions
                .environmentObject(director)
                
                // Black Fade Overlay
                Color.black
                    .opacity(director.fadeOpacity)
                    .ignoresSafeArea()
                    .allowsHitTesting(false) // Let touches pass through if transparent
            }
            .onAppear {
                // Force Landscape if possible via UIDevice (though deprecated, it triggers rotation)
                // The real enforcement is in Info.plist
            }
        }
    }
}
