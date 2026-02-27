import SwiftUI
import SpriteKit

struct Scene1View: View {
    @EnvironmentObject var director: MovieDirector
    
    // Editorial Palette
    let sandColor = Color(red: 0.96, green: 0.94, blue: 0.91)
    let charcoalColor = Color(red: 0.15, green: 0.15, blue: 0.15)

    @State private var xPos: CGFloat = -100
    @State private var isWalking = true
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                sandColor.ignoresSafeArea()

                Image("Scene1Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(1.0)

                // Subtle grid background
                Path { path in
                    for i in 0...Int(geo.size.width / 40) {
                        path.move(to: CGPoint(x: CGFloat(i) * 40, y: 0))
                        path.addLine(to: CGPoint(x: CGFloat(i) * 40, y: geo.size.height))
                    }
                    for i in 0...Int(geo.size.height / 40) {
                        path.move(to: CGPoint(x: 0, y: CGFloat(i) * 40))
                        path.addLine(to: CGPoint(x: geo.size.width, y: CGFloat(i) * 40))
                    }
                }
                .stroke(charcoalColor.opacity(0.03), lineWidth: 0.5)

                // Character
                if isWalking {
                    SpriteView(scene: SimpleSpriteScene(
                        size: CGSize(width: 100, height: 133),
                        imageName: "KidWalk",
                        rows: 4,
                        cols: 3
                    ), options: [.allowsTransparency])
                    .frame(width: 100, height: 133)
                    .position(x: xPos, y: geo.size.height * 0.85)
                } else {
                    Image("KidStanding")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .position(x: xPos, y: geo.size.height * 0.85)
                }
            }
            .onAppear {
                let targetX = geo.size.width * 0.25
                let duration = 2.5
                
                withAnimation(.easeInOut(duration: duration)) {
                    xPos = targetX
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation { isWalking = false }
                    
                    // Brief pause in standing pose before scene change
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        director.transition(to: .scene2)
                    }
                }
            }
        }
    }
}

#Preview {
    Scene1View()
        .environmentObject(MovieDirector())
}
