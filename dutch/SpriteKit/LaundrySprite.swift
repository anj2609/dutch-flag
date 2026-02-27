import SpriteKit
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

class LaundrySprite: SKSpriteNode {
    let item: LaundryItem
    
    init(item: LaundryItem) {
        self.item = item
        // Generate texture from SF Symbol
        let texture = LaundrySprite.texture(for: item)
        super.init(texture: texture, color: .clear, size: CGSize(width: 60, height: 60))
        
        self.name = "laundry_\(item.rawValue)"
        
        // Accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = "\(item.name)"
        self.accessibilityTraits = .button // Treat as button/interactable
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Helper to generic texture from SF Symbol
    static func texture(for item: LaundryItem) -> SKTexture {
        let symbolName: String
        switch item {
        case .redTShirt: symbolName = "tshirt.fill"
        case .whiteSocks: symbolName = "oval.fill" // Approximation for socks
        case .blueJeans: symbolName = "rectangle.fill"
        }
        
        #if canImport(UIKit)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        if let image = UIImage(systemName: symbolName, withConfiguration: config)?.withTintColor(UIColor(item.color), renderingMode: .alwaysOriginal) {
             return SKTexture(image: image)
        }
        #endif
        
        return SKTexture() // Fallback
    }
    
    func addGlowEffect() {
        if self.childNode(withName: "glow") == nil {
            let glow = SKShapeNode(circleOfRadius: 35)
            glow.fillColor = .white
            glow.alpha = 0.0
            glow.name = "glow"
            glow.zPosition = -1
            self.addChild(glow)
            
            let pulse = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.5, duration: 0.4),
                SKAction.fadeAlpha(to: 0.2, duration: 0.4)
            ])
            glow.run(SKAction.repeatForever(pulse))
        }
    }
    
    func removeGlowEffect() {
        self.childNode(withName: "glow")?.removeFromParent()
    }
}
