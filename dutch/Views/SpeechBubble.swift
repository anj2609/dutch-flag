import SwiftUI

struct SpeechBubble: View {
    var text: String
    var isLeft: Bool
    var typingSpeed: Double = 0.018
    var onTypingComplete: (() -> Void)? = nil

    @State private var displayedCount: Int = 0
    @State private var typingTimer: Timer? = nil

    private var displayedText: String { String(text.prefix(displayedCount)) }
    private var isTyping: Bool { displayedCount < text.count }

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Text(displayedText)
                    .font(.system(size: 15, weight: .regular, design: .serif))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(maxWidth: 320, alignment: .leading)
                    .background(Color(red: 0.99, green: 0.98, blue: 0.97))
                    .overlay(
                        Rectangle()
                            .stroke(Color(red: 0.15, green: 0.15, blue: 0.15).opacity(0.1), lineWidth: 0.5)
                    )
                    .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 5)
                
                if isTyping {
                    Button(action: skipToEnd) {
                        Text("SKIP")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(1)
                            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15).opacity(0.4))
                            .padding(10)
                    }
                    .transition(.opacity)
                }
            }
        }
        .onAppear { startTyping() }
        .onDisappear { typingTimer?.invalidate(); typingTimer = nil }
    }

    private func startTyping() {
        displayedCount = 0
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if displayedCount < text.count {
                displayedCount += 1
            } else {
                timer.invalidate()
                typingTimer = nil
                onTypingComplete?()
            }
        }
    }

    private func skipToEnd() {
        typingTimer?.invalidate()
        typingTimer = nil
        displayedCount = text.count
        onTypingComplete?()
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.1).ignoresSafeArea()
        SpeechBubble(text: "Hello! This is a test of the speech bubble with typing animation.", isLeft: true)
    }
}
