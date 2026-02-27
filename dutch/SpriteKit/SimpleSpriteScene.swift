import SpriteKit
import SwiftUI

class SimpleSpriteScene: SKScene {
    let imageName: String
    let rows: Int
    let cols: Int
    
    let animate: Bool
    
    init(size: CGSize, imageName: String, rows: Int, cols: Int, animate: Bool = true) {
        self.imageName = imageName
        self.rows = rows
        self.cols = cols
        self.animate = animate
        super.init(size: size)
        self.backgroundColor = .clear // Transparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupCharacter()
    }
    
    func setupCharacter() {
        let texture = SKTexture(imageNamed: imageName)
        
        // Split texture
        var frames: [SKTexture] = []
        let w = 1.0 / CGFloat(cols)
        let h = 1.0 / CGFloat(rows)
        
        // Assuming sprite sheet starts top-left to right, then down
        // SpriteKit (0,0) is BOTTOM-Left.
        // Row 0 (Top) is Y = 1.0 - h
        
        for r in 0..<rows {
            for c in 0..<cols {
                // Calculate rect in unit coordinates
                // Top row (r=0) -> y = 1 - 1*h
                let y = 1.0 - (CGFloat(r + 1) * h)
                let x = CGFloat(c) * w
                
                let rect = CGRect(x: x, y: y, width: w, height: h)
                let frameToken = SKTexture(rect: rect, in: texture)
                frames.append(frameToken)
            }
        }
        
        // Create Sprite using the first frame
        let sprite = SKSpriteNode(texture: frames.first)
        
        // Scale to fit scene exactly
        sprite.size = self.size
        
        sprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(sprite)
        
        // Animate if requested
        if animate {
            let animateAction = SKAction.animate(with: frames, timePerFrame: 0.1) // 0.1s per frame
            sprite.run(SKAction.repeatForever(animateAction))
        }
    }
}
