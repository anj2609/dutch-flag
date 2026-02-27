import SwiftUI

struct Scene3View: View {
    @EnvironmentObject var director: MovieDirector

    // Editorial Palette
    let sandColor = Color(red: 0.96, green: 0.94, blue: 0.91)
    let charcoalColor = Color(red: 0.15, green: 0.15, blue: 0.15)
    let terracottaColor = Color(red: 0.75, green: 0.35, blue: 0.25)
    let ivoryColor = Color(red: 1.0, green: 0.99, blue: 0.98)

    @State private var showTitle   = false
    @State private var showBasket  = false
    @State private var showStats   = false
    @State private var showHow     = false
    @State private var showButtons = false

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ZStack(alignment: .top) {
                    sandColor.ignoresSafeArea()

                    VStack(spacing: 48) {
                        // Header
                        if showTitle {
                            VStack(spacing: 20) {
                                Text("Operation Complete")
                                    .font(.system(size: 12, weight: .bold))
                                    .tracking(2.5)
                                    .foregroundColor(charcoalColor.opacity(0.4))
                                
                                Text("Laundry Sorted")
                                    .font(.system(size: 48, weight: .medium, design: .serif))
                                    .foregroundColor(charcoalColor)
                                    .tracking(-1)
                                
                                Rectangle()
                                    .fill(terracottaColor.opacity(0.3))
                                    .frame(width: 40, height: 1)
                            }
                            .transition(.opacity)
                        }

                        // Visualization
                        if showBasket {
                            ZStack {
                                Image("EmptyBasket").resizable().scaledToFit().frame(height: 120)
                                    .opacity(0.6)
                                
                                HStack(spacing: 4) {
                                    ForEach(0..<8) { i in
                                        let color = i < 3 ? Color(red: 0.7, green: 0.3, blue: 0.3) : (i < 5 ? Color.gray : Color(red: 0.3, green: 0.4, blue: 0.6))
                                        Rectangle()
                                            .fill(color)
                                            .frame(width: 12, height: 2)
                                    }
                                }
                                .offset(y: -10)
                            }
                            .transition(.opacity)
                        }

                        // Analysis Grid
                        if showStats {
                            VStack(spacing: 32) {
                                Text("COMPLEXITY ANALYSIS")
                                    .font(.system(size: 10, weight: .bold))
                                    .tracking(2)
                                    .foregroundColor(charcoalColor.opacity(0.4))

                                HStack(alignment: .top, spacing: 0) {
                                    statBlock(title: "TIME", value: "O(N)", desc: "Linear scan, single pass.")
                                    divider()
                                    statBlock(title: "SPACE", value: "O(1)", desc: "Constant memory usage.")
                                    divider()
                                    statBlock(title: "PASSES", value: "1", desc: "No redundant iterations.")
                                }
                                .padding(.horizontal, 20)
                            }
                            .transition(.opacity)
                        }

                        // Logic Review
                        if showHow {
                            VStack(spacing: 32) {
                                Text("MECHANICAL OVERVIEW")
                                    .font(.system(size: 10, weight: .bold))
                                    .tracking(2)
                                    .foregroundColor(charcoalColor.opacity(0.4))

                                VStack(spacing: 0) {
                                    howRow(title: "FRONT POINTER", desc: "Maintains the boundary of red elements via strategic swaps.")
                                    Divider().background(charcoalColor.opacity(0.05))
                                    howRow(title: "CURRENT POINTER", desc: "The primary explorer, scanning and validating each element.")
                                    Divider().background(charcoalColor.opacity(0.05))
                                    howRow(title: "BACK POINTER", desc: "Secures the boundary of blue elements from the end of the set.")
                                }
                                .background(ivoryColor)
                                .overlay(Rectangle().stroke(charcoalColor.opacity(0.05), lineWidth: 0.5))
                            }
                            .transition(.opacity)
                        }

                        // Action
                        if showButtons {
                            Button(action: {
                                withAnimation { director.transition(to: .launch) }
                            }) {
                                Text("RETURN TO PORTFOLIO")
                                    .font(.system(size: 12, weight: .bold))
                                    .tracking(1.5)
                                    .foregroundColor(ivoryColor)
                                    .padding(.horizontal, 48)
                                    .padding(.vertical, 16)
                                    .background(charcoalColor)
                            }
                            .transition(.opacity)
                        }
                        
                        Spacer(minLength: 60)
                    }
                    .padding(.top, 80)
                    .padding(.horizontal, 60)
                }
            }
        }
        .onAppear { animate() }
    }

    func statBlock(title: String, value: String, desc: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 9, weight: .bold))
                .tracking(1)
                .foregroundColor(charcoalColor.opacity(0.5))
            Text(value)
                .font(.system(size: 24, weight: .medium, design: .serif))
                .foregroundColor(terracottaColor)
            Text(desc)
                .font(.system(size: 10, weight: .regular, design: .serif))
                .italic()
                .foregroundColor(charcoalColor.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    func howRow(title: String, desc: String) -> some View {
        HStack(alignment: .center, spacing: 20) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(1)
                .foregroundColor(charcoalColor)
                .frame(width: 120, alignment: .leading)
            
            Text(desc)
                .font(.system(size: 12, weight: .regular, design: .serif))
                .foregroundColor(charcoalColor.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
    }

    func divider() -> some View {
        Rectangle()
            .fill(charcoalColor.opacity(0.05))
            .frame(width: 0.5, height: 40)
            .padding(.horizontal, 20)
    }

    func animate() {
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) { showTitle = true }
        withAnimation(.easeOut(duration: 0.8).delay(0.6)) { showBasket = true }
        withAnimation(.easeOut(duration: 0.8).delay(1.0)) { showStats = true }
        withAnimation(.easeOut(duration: 0.8).delay(1.4)) { showHow = true }
        withAnimation(.easeOut(duration: 0.8).delay(1.8)) { showButtons = true }
    }
}

#Preview {
    Scene3View()
        .environmentObject(MovieDirector())
}
