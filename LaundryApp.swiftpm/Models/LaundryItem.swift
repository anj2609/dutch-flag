import SwiftUI

// LaundryItem.swift
enum LaundryItem: Int, CaseIterable, Identifiable {
    case redTShirt = 0
    case whiteSocks = 1
    case blueJeans = 2
    
    var id: Int { self.rawValue }
    
    var color: Color {
        switch self {
        case .redTShirt: return .red
        case .whiteSocks: return .white
        case .blueJeans: return .blue
        }
    }
    
    // Using Asset Names
    var imageName: String {
        switch self {
        case .redTShirt: return "RedTShirt"
        case .whiteSocks: return "WhiteSocks"
        case .blueJeans: return "BlueJeans"
        }
    }
    
    var name: String {
        switch self {
        case .redTShirt: return "Red T-Shirt"
        case .whiteSocks: return "White Socks"
        case .blueJeans: return "Blue Jeans"
        }
    }
}
