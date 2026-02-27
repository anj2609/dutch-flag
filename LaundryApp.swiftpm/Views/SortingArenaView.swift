import SwiftUI
import SpriteKit

struct SortingArenaView: View {
    @StateObject private var vm = SortingViewModel()
    @State private var scene: LaundryScene = {
        let scene = LaundryScene()
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.97).ignoresSafeArea()
            
            VStack {
                // Header (Progress & Message)
                VStack(spacing: 10) {
                    HStack {
                        Text("Step: \(vm.state.stepCount)")
                        Spacer()
                        if vm.state.isComplete {
                            Text("COMPLETE!")
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                        }
                    }
                    .font(.headline)
                    .padding(.horizontal)
                    
                    Text(vm.currentMessage)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .padding()
                
                // SpriteKit Scene
                SpriteView(scene: scene)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                    .padding()
                    .onAppear {
                        scene.setupItems(vm.state.array)
                    }
                    .onChange(of: vm.state.low) { _ in updatePointers() }
                    .onChange(of: vm.state.mid) { _ in updatePointers() }
                    .onChange(of: vm.state.high) { _ in updatePointers() }
                    // We need to trigger swaps. 
                    // Since specific swap event is tricky with pure SwiftUI state observation of array,
                    // we might need a workaround or just rely on re-setup?
                    // Re-setup is bad for animation.
                    // For now, let's just make sure pointers update.
                    // Ideally we hook vm.onSwap.
                
                // Mode Switcher
                Picker("Mode", selection: $vm.currentMode) {
                    Text("Watch").tag(GameMode.watch)
                    Text("Predict").tag(GameMode.predict)
                    Text("Sort").tag(GameMode.sort)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: vm.currentMode) { _ in vm.reset(); scene.setupItems(vm.state.array) }

                // Controls
                VStack {
                    if vm.currentMode == .predict {
                        PredictControlView(vm: vm)
                            .disabled(vm.isAnimating || vm.state.isComplete)
                    } else if vm.currentMode == .sort {
                        Text("Drag the item at the Middle Pointer to its correct zone!")
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        Button("Reset") {
                             vm.reset()
                             scene.setupItems(vm.state.array)
                        }
                        .padding()
                        .foregroundColor(.red)
                    } else {
                        HStack {
                             Button(action: {
                                 Task { await vm.performStep() }
                             }) {
                                 Text("Step Forward")
                                     .bold()
                                     .padding()
                                     .background(vm.state.isComplete ? Color.gray : Color.blue)
                                     .foregroundColor(.white)
                                     .cornerRadius(10)
                             }
                             .disabled(vm.isAnimating || vm.state.isComplete)
                             
                             Button(action: {
                                 // Auto play logic could go here
                             }) {
                                 Image(systemName: "play.circle")
                                     .font(.title)
                             }
                             
                             Spacer()
                             
                             Button("Reset") {
                                 vm.reset()
                                 scene.setupItems(vm.state.array)
                             }
                             .padding()
                             .foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }
        }
         .onAppear {
             scene.dragCompletion = { index, zone in
                 // Validate in VM
                 if vm.currentMode == .sort {
                     if vm.validateDrop(fromIndex: index, toZone: zone) {
                         Task { await vm.performPlayerMove(toZone: zone) }
                     } else {
                         // Invalid Move visual feedback could be triggered here?
                         // Scene handles return already if we don't confirm?
                         // Actually scene currently just drops it? 
                         // We need scene to snap back if invalid.
                         // But scene touchesEnded calls this, then finishes.
                         // We should maybe let scene wait?
                         // For simplicity: Scene calls this. If valid, VM updates state -> Scene re-renders via onChange logic (swaps/pointers).
                         // If invalid, VM does nothing. Scene needs to know to snap back.
                         // But touchesEnded is synchronous.
                         // Let's updated `touchesEnded` to snap back ALWAYS visually, 
                         // and if valid, the VM update will animate the swap from the original position 
                         // (because VM touches update the array -> scene updates).
                         // Wait, if scene snaps back, then VM animates swap, that works.
                     }
                     
                     // Force snap back visually for consistency, then let VM logic override if valid
                     if let sprite = scene.laundrySprites[safe: index] {
                         scene.returnSprite(sprite)
                     }
                 }
             }
        }
        .onReceive(vm.eventSubject) { event in
            switch event {
            case .swap(let from, let to):
                scene.animSwap(from: from, to: to) {}
            case .highlight(let index):
                // scene.highlight(index) // Need to implement if we want visual highlight in SK
                break
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $vm.state.isComplete) {
            CompletionView(vm: vm)
        }
    }
    
    func updatePointers() {
        scene.updatePointers(low: vm.state.low, mid: vm.state.mid, high: vm.state.high)
    }
}
