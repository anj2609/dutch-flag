import SwiftUI

// Character.swift
struct Character: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let color: Color
    let catchphrase: String
    let iconName: String // Added for SF Symbol reference
    
    static let robby = Character(
        name: "Robby",
        role: "Red Zone Guardian (Low Pointer)",
        color: Color(red: 0.95, green: 0.3, blue: 0.3),
        catchphrase: "Red Rush to the Front!",
        iconName: "arrowtriangle.right.fill"
    )
    
    static let whitney = Character(
        name: "Whitney", 
        role: "Current Explorer (Mid Pointer)",
        color: Color(white: 0.9), // Whitney White? Prompt says white: 0.9
        catchphrase: "Middle Ground is My Ground!",
        iconName: "arrowtriangle.right.fill"
    )
    
    static let barry = Character(
        name: "Barry",
        role: "Blue Zone Guardian (High Pointer)", 
        color: Color(red: 0.2, green: 0.5, blue: 0.95),
        catchphrase: "Blues to the Back Bay!",
        iconName: "arrowtriangle.left.fill"
    )
    
    static let allCharacters = [robby, whitney, barry]
}
