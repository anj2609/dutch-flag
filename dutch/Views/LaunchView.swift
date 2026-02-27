import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var director: MovieDirector
    @State private var appeared = false
    @State private var isPressed = false

    // Editorial Palette
    let sandColor = Color(red: 0.96, green: 0.94, blue: 0.91)
    let charcoalColor = Color(red: 0.15, green: 0.15, blue: 0.15)
    let terracottaColor = Color(red: 0.75, green: 0.35, blue: 0.25)
    let ivoryColor = Color(red: 1.0, green: 0.99, blue: 0.98)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                sandColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 32) {
                        // Minimalist Header
                        VStack(spacing: 16) {
                            Text("Dutch Sort")
                                .font(.system(size: 54, weight: .medium, design: .serif))
                                .foregroundColor(charcoalColor)
                                .tracking(-1.5)
                            
                            Rectangle()
                                .fill(terracottaColor.opacity(0.3))
                                .frame(width: 40, height: 1)
                            
                            Text("An interactive study of the\nDutch National Flag Algorithm")
                                .font(.system(size: 14, weight: .regular, design: .serif))
                                .italic()
                                .foregroundColor(charcoalColor.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        
                        // Refined Flag Representation
                        HStack(spacing: 4) {
                            Rectangle().fill(Color(red: 0.68, green: 0.10, blue: 0.10)).frame(width: 30, height: 2)
                            Rectangle().fill(Color(red: 0.9, green: 0.9, blue: 0.9)).frame(width: 30, height: 2)
                            Rectangle().fill(Color(red: 0.08, green: 0.25, blue: 0.55)).frame(width: 30, height: 2)
                        }
                        .padding(.top, 8)

                        // Action
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                director.transition(to: .scene1)
                            }
                        }) {
                            Text("Begin Exploration")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(ivoryColor)
                                .padding(.horizontal, 48)
                                .padding(.vertical, 16)
                                .background(terracottaColor)
                                .cornerRadius(2)
                                .shadow(color: terracottaColor.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(isPressed ? 0.97 : 1.0)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in isPressed = true }
                                .onEnded { _ in isPressed = false }
                        )
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 60)
                    .background(ivoryColor)
                    .overlay(
                        Rectangle()
                            .stroke(charcoalColor.opacity(0.05), lineWidth: 1)
                    )
                    .shadow(color: charcoalColor.opacity(0.03), radius: 40, x: 0, y: 20)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    
                    Spacer()
                    
                    // Footer details
                    Text("PUBLISHED BY SWIFT-ANJALI • MMXXVI")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(2)
                        .foregroundColor(charcoalColor.opacity(0.3))
                        .padding(.bottom, 32)
                        .opacity(appeared ? 1 : 0)
                }
                .frame(width: geo.size.width)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                appeared = true
            }
        }
    }
}
#Preview {
    LaunchView()
        .environmentObject(MovieDirector())
}
