import SwiftUI

struct CompletionView: View {
    @ObservedObject var vm: SortingViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            Text("🎉 Celebration! 🎉")
                .font(.largeTitle)
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Statistics:")
                    .font(.headline)
                Text("Steps Taken: \(vm.state.stepCount)")
                Text("Time Complexity: O(n)")
                Text("Space Complexity: O(1)")
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            
            Button("Try Again") {
                vm.reset()
                dismiss() // This returns to SortingArena, which should reset itself via vm.reset()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Main Menu") {
                // Navigate back to root? 
                // In simple navigation stack, usually need a binding to root.
                // For now, just Try Again or maybe re-launch.
            }
        }
        .padding()
        .background(Color(white: 0.95).edgesIgnoringSafeArea(.all))
    }
}
