import SwiftUI

struct WelcomeView: View {
    @State private var navigateToIntro = false
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Laundry Sorter")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text("Master the Dutch National Flag Algorithm")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(isAnimating ? 10 : -10))
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                    
                    Spacer()
                    
                    Text("Learn how to sort red socks, white shirts, and blue jeans efficiently!")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    NavigationLink(destination: CharacterIntroView()) {
                        Text("Start Learning")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(minWidth: 200)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}
