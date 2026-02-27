import SpriteKit
import SwiftUI

class LaundryScene: SKScene {
    var laundrySprites: [LaundrySprite] = []
    var pointers: [PointerSprite] = []
    
    // Pointers
    var robby: PointerSprite!
    var whitney: PointerSprite!
    var barry: PointerSprite!
    
    // Zones
    var redZone: SKShapeNode!
    var whiteZone: SKShapeNode!
    var blueZone: SKShapeNode!
    
    // Layout constants
    let spriteSpacing: CGFloat = 70
    let startX: CGFloat = -350
    let floorY: CGFloat = 0
    let pointerY: CGFloat = -60
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupZones()
    }
    
    func setupZones() {
        // Create 3 rectangles. Initial sizes will be updated.
        // We'll just create them here and resize in updateZones
        
        redZone = SKShapeNode(rectOf: CGSize(width: 100, height: 200))
        redZone.fillColor = UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 0.3)
        redZone.strokeColor = .clear
        redZone.zPosition = -10
        addChild(redZone)
        
        whiteZone = SKShapeNode(rectOf: CGSize(width: 100, height: 200))
        whiteZone.fillColor = UIColor(white: 0.9, alpha: 0.1)
        whiteZone.strokeColor = .clear
        whiteZone.zPosition = -10
        addChild(whiteZone)
        
        blueZone = SKShapeNode(rectOf: CGSize(width: 100, height: 200))
        blueZone.fillColor = UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 0.3)
        blueZone.strokeColor = .clear
        blueZone.zPosition = -10
        addChild(blueZone)
    }
    
    func updateZones(low: Int, mid: Int, high: Int) {
        let totalCount = laundrySprites.count
        guard totalCount > 0 else { return }
        
        
        let totalWidth = CGFloat(totalCount) * spriteSpacing
        let originX = -(totalWidth / 2) + (spriteSpacing / 2)
        
        // Red Zone: 0 to low (exclusive of low? No, low is the boundary. 0..<low)
        // Wait, standard DNF:
        // [0, low-1] = Red
        // [low, mid-1] = White
        // [mid, high] = Unknown
        // [high+1, end] = Blue
        
        // My code in VM:
        // Case Red: swap(low, mid), low++, mid++
        // Case White: mid++
        // Case Blue: swap(mid, high), high--
        
        // So:
        // Red is 0 ..< low
        // White is low ..< mid
        // Unknown is mid ... high
        // Blue is high+1 ..< count
        
        let redCount = low
        let whiteCount = mid - low
        // let unknownCount = high - mid + 1
        let blueCount = totalCount - (high + 1)
        
        // Calculate Frames via Actions for animation?
        // SKShapeNode rect cannot be easily animated without recreating path or scaling.
        // Scaling is easier.
        
        animateZone(redZone, count: redCount, startIndex: 0, originX: originX, color: UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 0.3))
        animateZone(whiteZone, count: whiteCount, startIndex: low, originX: originX, color: UIColor(white: 0.9, alpha: 0.1))
        animateZone(blueZone, count: blueCount, startIndex: high + 1, originX: originX, color: UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 0.3))
    }
    
    func animateZone(_ zone: SKShapeNode, count: Int, startIndex: Int, originX: CGFloat, color: UIColor) {
        let width = max(CGFloat(count) * spriteSpacing, 0)
        
        // Exact left edge of index 0 is originX - spriteSpacing/2
        let leftEdge = originX + (CGFloat(startIndex) * spriteSpacing) - (spriteSpacing / 2)
        let finalCenterX = leftEdge + (width / 2)
        
        // If count is 0, width is 0.
        
        let newPath = CGPath(rect: CGRect(x: -width/2, y: -100, width: width, height: 200), transform: nil)
        
        let updatePath = SKAction.run {
            zone.path = newPath
        }
        let move = SKAction.moveTo(x: finalCenterX, duration: 0.4)
        move.timingMode = .easeInEaseOut
        
        // Run parallel
        zone.run(SKAction.group([updatePath, move]))
    }
    
    func setupItems(_ items: [LaundryItem]) {
        // Clear existing
        laundrySprites.forEach { $0.removeFromParent() }
        laundrySprites.removeAll()
        pointers.forEach { $0.removeFromParent() }
        pointers.removeAll()
        
        // Calculate startX to center based on count
        let totalWidth = CGFloat(items.count) * spriteSpacing
        let currentStartX = -(totalWidth / 2) + (spriteSpacing / 2)
        
        // Setup Sprites
        for (index, item) in items.enumerated() {
            let sprite = LaundrySprite(item: item)
            sprite.position = CGPoint(x: currentStartX + CGFloat(index) * spriteSpacing, y: floorY)
            addChild(sprite)
            laundrySprites.append(sprite)
        }
        
        // Setup Pointers
        setupPointers(startX: currentStartX)
    }
    
    func setupPointers(startX: CGFloat) {
        robby = PointerSprite(character: Character.robby)
        whitney = PointerSprite(character: Character.whitney)
        barry = PointerSprite(character: Character.barry)
        
        // Initial positions (conceptually)
        // We will update their physical positions via updatePointers
        
        addChild(robby)
        addChild(whitney)
        addChild(barry)
        
        pointers = [robby, whitney, barry]
        
        updatePointers(low: 0, mid: 0, high: laundrySprites.count - 1)
    }
    
    func updatePointers(low: Int, mid: Int, high: Int) {
         let totalWidth = CGFloat(laundrySprites.count) * spriteSpacing
         let currentStartX = -(totalWidth / 2) + (spriteSpacing / 2)
         
         let lowX = currentStartX + CGFloat(low) * spriteSpacing
         let midX = currentStartX + CGFloat(mid) * spriteSpacing
         let highX = currentStartX + CGFloat(high) * spriteSpacing
         
         animatePointerMove(robby, toX: lowX - 20) // Robby sits slightly left of Low index or At Low?
         // DNF: Low points to first element of White (start of unsorted/white/mid is usually Mid, Low is first unclassified? No.)
         // Algorithm:
         // 0..<Low : Red
         // Low..<Mid : White
         // Mid..<High : Unclassified
         // High+1... : Blue
         
         // So Robby (Low) is the boundary for Red. Initially 0.
         // Whitney (Mid) is current item.
         // Barry (High) is boundary for Blue.
         
         // Let's position them exactly under the index they represent
         let robbyX = currentStartX + CGFloat(low) * spriteSpacing
         let whitneyX = currentStartX + CGFloat(mid) * spriteSpacing
         let barryX = currentStartX + CGFloat(high) * spriteSpacing
         
         // Animate to these positions
         animatePointerMove(robby, toX: robbyX)
         animatePointerMove(whitney, toX: whitneyX)
         animatePointerMove(barry, toX: barryX)
         
         updateZones(low: low, mid: mid, high: high)
    }
    
    func animatePointerMove(_ pointer: PointerSprite, toX: CGFloat) {
        if abs(pointer.position.x - toX) < 1 { return } // Optimization
        
        let move = SKAction.moveTo(x: toX, duration: 0.5)
        move.timingMode = .easeInEaseOut
        pointer.run(move)
    }
    
    func animSwap(from: Int, to: Int, completion: @escaping () -> Void) {
        guard from < laundrySprites.count, to < laundrySprites.count else {
            completion()
            return
        }
        
        let sprite1 = laundrySprites[from]
        let sprite2 = laundrySprites[to]
        
        let pos1 = sprite1.position
        let pos2 = sprite2.position
        
        // Arc path
        let path = UIBezierPath()
        path.move(to: pos1)
        path.addQuadCurve(to: pos2, controlPoint: CGPoint(x: (pos1.x + pos2.x)/2, y: pos1.y + 100))
        
        let path2 = UIBezierPath()
        path2.move(to: pos2)
        path2.addQuadCurve(to: pos1, controlPoint: CGPoint(x: (pos1.x + pos2.x)/2, y: pos1.y - 50)) // Different arc usually looks better or same
        
        // Actually, for a clean swap, maybe just easeMove
        // Prompt asked for Bezier curve.
        
        let move1 = SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, duration: 0.6)
        let move2 = SKAction.follow(path2.cgPath, asOffset: false, orientToPath: false, duration: 0.6)
        
        move1.timingMode = .easeInEaseOut
        move2.timingMode = .easeInEaseOut
        
        sprite1.run(move1)
        sprite2.run(move2) {
            completion()
        }
        
        // Swap locally
        laundrySprites.swapAt(from, to)
    }
    
    func movePointer(_ pointer: PointerSprite, to position: Int) {
         let totalWidth = CGFloat(laundrySprites.count) * spriteSpacing
         let currentStartX = -(totalWidth / 2) + (spriteSpacing / 2)
         let x = currentStartX + CGFloat(position) * spriteSpacing
         
         animatePointerMove(pointer, toX: x)
    }
    // Interaction for Sort Mode
    var selectedSprite: LaundrySprite?
    var originalPosition: CGPoint?
    var dragCompletion: ((Int, LaundryItem) -> Void)? // Index, ZoneType
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = nodes(at: location)
        if let sprite = nodes.first(where: { $0 is LaundrySprite }) as? LaundrySprite {
            selectedSprite = sprite
            originalPosition = sprite.position
            sprite.addGlowEffect()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let sprite = selectedSprite else { return }
        let location = touch.location(in: self)
        sprite.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let sprite = selectedSprite else { return }
        
        // Determine Drop Zone
        let location = touch.location(in: self)
        var droppedZone: LaundryItem?
        
        if redZone.contains(location) { droppedZone = .redTShirt }
        else if whiteZone.contains(location) { droppedZone = .whiteSocks } // Middle
        else if blueZone.contains(location) { droppedZone = .blueJeans }
        
        // Find index of sprite
        if let index = laundrySprites.firstIndex(of: sprite), let zone = droppedZone {
            dragCompletion?(index, zone)
        } else {
            // Cancel return
            returnSprite(sprite)
        }
        
        selectedSprite = nil
    }
    
    func returnSprite(_ sprite: LaundrySprite) {
        if let originalPosition = originalPosition {
            let move = SKAction.move(to: originalPosition, duration: 0.2)
            move.timingMode = .easeOut
            sprite.run(move)
        }
        sprite.removeGlowEffect()
    }
}
