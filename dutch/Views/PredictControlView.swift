import SwiftUI

struct PredictControlView: View {
    @ObservedObject var vm: SortingViewModel
    
    var body: some View {
        VStack {
            Text("What should happen next?")
                .font(.headline)
            
            HStack(spacing: 20) {
                Button(action: { check(.swapLeft) }) {
                    VStack {
                        Image(systemName: "arrow.left.circle.fill")
                        Text("Swap w/ Red")
                    }
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: { check(.stay) }) {
                    VStack {
                        Image(systemName: "pause.circle.fill")
                        Text("Stay Here")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
                
                Button(action: { check(.swapRight) }) {
                    VStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Swap w/ Blue")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    func check(_ prediction: MoveType) {
        if vm.checkPrediction(prediction) {
            // Correct!
            vm.currentMessage = "Correct! ✅"
            // Auto advance
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000)
                await vm.performStep()
            }
        } else {
            // Incorrect
            vm.currentMessage = "Not quite! Try again. 🤔"
        }
    }
}
