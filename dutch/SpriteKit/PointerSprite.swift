import SpriteKit
import SwiftUI

class PointerSprite: SKSpriteNode {
    let character: Character
    
    init(character: Character) {
        self.character = character
        let texture = PointerSprite.texture(for: character)
        super.init(texture: texture, color: .clear, size: CGSize(width: 40, height: 40))
        self.name = "pointer_\(character.name)"
        
        // Add Label
        let label = SKLabelNode(text: character.name.prefix(1).uppercased())
        label.fontName = "Arial-BoldMT"
        label.fontSize = 20
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: -2)
        label.zPosition = 1
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func texture(for character: Character) -> SKTexture {
        #if canImport(UIKit)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        if let image = UIImage(systemName: character.iconName, withConfiguration: config)?.withTintColor(UIColor(character.color), renderingMode: .alwaysOriginal) {
            return SKTexture(image: image)
        }
        #endif
        return SKTexture()
    }
}
