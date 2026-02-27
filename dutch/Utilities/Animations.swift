import SwiftUI

enum AnimationConstants {
    static let swapDuration: Double = 0.6
    static let pointerMoveDuration: Double = 0.5
    static let pointerHopHeight: CGFloat = 20.0
    static let zoneAnimationDuration: Double = 0.4
}

struct ZoneColors {
    static let red = Color(red: 1.0, green: 0.7, blue: 0.7, opacity: 0.3)
    static let white = Color.white.opacity(0.1)
    static let blue = Color(red: 0.7, green: 0.8, blue: 1.0, opacity: 0.3)
}
