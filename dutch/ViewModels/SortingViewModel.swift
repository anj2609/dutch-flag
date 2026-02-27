import SwiftUI
import Combine

enum SortEvent {
    case swap(Int, Int)
    case highlight(Int)
}

// SortingViewModel.swift
@MainActor
class SortingViewModel: ObservableObject {
    @Published var state = AlgorithmState()
    @Published var currentMessage = "Tap 'Step' to begin!"
    @Published var currentMode: GameMode = .watch
    @Published var isAnimating = false
    @Published var highlightedIndex: Int?
    
    let eventSubject = PassthroughSubject<SortEvent, Never>()
    
    // Watch mode logic
    func performStep() async {
        guard state.mid <= state.high else {
            if !state.isComplete {
                await complete()
            }
            return
        }
        
        let item = state.array[state.mid]
        highlightedIndex = state.mid
        isAnimating = true
        
        // Wait a bit to show selection
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        switch item {
        case .redTShirt:
            await handleRedTShirt()
        case .whiteSocks:
            await handleWhiteSocks()
        case .blueJeans:
            await handleBlueJeans()
        }
        
        highlightedIndex = nil
        state.stepCount += 1
        isAnimating = false
        
        // Check completion after step
        if state.mid > state.high {
            await complete()
        }
    }
    
    private func handleRedTShirt() async {
        currentMessage = "Robby found a red T-shirt! Swapping to front..."
        
        // Highlight both positions
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        // Perform swap with animation
        eventSubject.send(.swap(state.low, state.mid))
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            state.array.swapAt(state.low, state.mid)
        }
        
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        state.low += 1
        state.mid += 1
        
        currentMessage = "Red zone expanded! ✅"
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
    
    private func handleWhiteSocks() async {
        currentMessage = "Whitney says: White socks stay in middle!"
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        state.mid += 1
        
        currentMessage = "Moving on... ⏭️"
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
    
    private func handleBlueJeans() async {
        currentMessage = "Barry claims blue jeans for the back!"
        
        highlightedIndex = state.mid // Ensure highlight stays
        
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        eventSubject.send(.swap(state.mid, state.high))
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            state.array.swapAt(state.mid, state.high)
        }
        
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        state.high -= 1
        
        currentMessage = "Blue zone expanded! ✅"
        try? await Task.sleep(nanoseconds: 500_000_000)
    }
    
    private func complete() async {
        state.isComplete = true
        currentMessage = "🎉 Sorted in one pass! O(n) time, O(1) space!"
    }
    
    // Predict mode
    func checkPrediction(_ prediction: MoveType) -> Bool {
        guard state.mid <= state.high else { return false }
        let item = state.array[state.mid]
        
        switch (item, prediction) {
        case (.redTShirt, .swapLeft):
            return true
        case (.whiteSocks, .stay):
            return true
        case (.blueJeans, .swapRight):
            return true
        default:
            return false
        }
    }
    
    // Sort Mode (Drag and Drop Validation)
    func validateDrop(fromIndex: Int, toZone: LaundryItem) -> Bool {
        // In Sort Mode, user drags item to a zone.
        // Rules:
        // Red Sock -> Red Zone (Low side)
        // White Shirt -> Middle (Stay)
        // Blue Jeans -> Blue Zone (High side)
        
        let item = state.array[fromIndex]
        
        // Ensure we are operating on the correct 'current' item if strict DNF
        // Usually DNF is about classifying the *current* item at Mid.
        // But for "You Sort It", maybe we allow freedom or strict DNF?
        // Let's enforce strict DNF: only the item at 'mid' is active.
        
        guard fromIndex == state.mid else { return false }
        
        switch (item, toZone) {
        case (.redTShirt, .redTShirt): return true
        case (.whiteSocks, .whiteSocks): return true
        case (.blueJeans, .blueJeans): return true
        default: return false
        }
    }
    
    func performPlayerMove(toZone: LaundryItem) async {
        // Assuming validation passed
        let item = state.array[state.mid]
        
        switch item {
        case .redTShirt:
            // Swap low, mid
            eventSubject.send(.swap(state.low, state.mid))
            withAnimation { state.array.swapAt(state.low, state.mid) }
            try? await Task.sleep(nanoseconds: 400_000_000)
            state.low += 1
            state.mid += 1
            currentMessage = "Correct! Red T-shirt sorted."
            
        case .whiteSocks:
            state.mid += 1
            currentMessage = "Correct! White socks stay."
            
        case .blueJeans:
             eventSubject.send(.swap(state.mid, state.high))
             withAnimation { state.array.swapAt(state.mid, state.high) }
             try? await Task.sleep(nanoseconds: 400_000_000)
             state.high -= 1
             currentMessage = "Correct! Blue jeans sorted."
        }
        
         if state.mid > state.high {
            await complete()
        }
    }

    // Reset
    func reset() {
        state = AlgorithmState()
        currentMessage = "Ready to sort! Tap 'Step' to begin!"
        isAnimating = false
        highlightedIndex = nil
    }
}
