import SwiftUI

// AlgorithmState.swift
class AlgorithmState: ObservableObject {
    @Published var array: [LaundryItem]
    @Published var low: Int = 0
    @Published var mid: Int = 0
    @Published var high: Int
    @Published var stepCount: Int = 0
    @Published var isComplete: Bool = false
    
    init(size: Int = 12) {
        let items = (0..<size).map { _ in 
            LaundryItem.allCases.randomElement()! 
        }
        self.array = items
        self.high = size - 1
    }
}
