import SwiftUI

struct SpriteSheetView: View {
    let image: String
    let rows: Int
    let columns: Int
    let duration: Double
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    
    @State private var frameIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            Image(image)
                .resizable()
                // .scaledToFill() removed to ensure exact stretch to the calculated frame
                .frame(
                    width: geometry.size.width * CGFloat(columns),
                    height: geometry.size.height * CGFloat(rows)
                )
                .offset(
                    x: (-geometry.size.width * CGFloat(frameIndex % columns)) + xOffset,
                    y: (-geometry.size.height * CGFloat(frameIndex / columns)) + yOffset
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: duration / Double(rows * columns), repeats: true) { _ in
                        frameIndex = (frameIndex + 1) % (rows * columns)
                    }
                }
        }
    }
}
