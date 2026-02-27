import SwiftUI
import SpriteKit

// MARK: - Scene2View
struct Scene2View: View {
    @EnvironmentObject var director: MovieDirector

    // Editorial Palette
    let sandColor = Color(red: 0.96, green: 0.94, blue: 0.91)
    let charcoalColor = Color(red: 0.15, green: 0.15, blue: 0.15)
    let terracottaColor = Color(red: 0.75, green: 0.35, blue: 0.25)
    let ivoryColor = Color(red: 1.0, green: 0.99, blue: 0.98)
    let mutedBlue = Color(red: 0.35, green: 0.45, blue: 0.60)
    let mutedRed = Color(red: 0.70, green: 0.30, blue: 0.30)

    // ── Dialogue ──
    struct DialogueLine {
        let speaker: String
        let text: String
        var showDirtyClothes: Bool = false
        var showDutchFlag:    Bool = false
        var showBasket:       Bool = false
    }

    let script: [DialogueLine] = [
        DialogueLine(speaker: "mother", text: "Hey sweetie! How was school today?"),
        DialogueLine(speaker: "kid",    text: "It was great, Mom! We learned about sorting algorithms!"),
        DialogueLine(speaker: "mother", text: "Sorting algorithms? That sounds fancy!"),
        DialogueLine(speaker: "kid",    text: "Yeah! The teacher showed us a really cool one."),
        DialogueLine(speaker: "mother", text: "Well, speaking of sorting... look at this laundry pile!", showDirtyClothes: true),
        DialogueLine(speaker: "kid",    text: "Whoa! Red, white, and blue clothes all mixed up!", showDirtyClothes: true),
        DialogueLine(speaker: "mother", text: "I need them sorted before the wash. It's a total mess.", showDirtyClothes: true),
        DialogueLine(speaker: "kid",    text: "Can't we just put them in separate baskets?", showBasket: true),
        DialogueLine(speaker: "mother", text: "We only have ONE basket! No room for extras.", showBasket: true),
        DialogueLine(speaker: "mother", text: "So everything has to be sorted right here, in place.", showBasket: true),
        DialogueLine(speaker: "kid",    text: "In place? That's exactly what we learned today!", showBasket: true),
        DialogueLine(speaker: "mother", text: "Really? What did you learn?", showBasket: true),
        DialogueLine(speaker: "kid",    text: "The Dutch National Flag Algorithm!", showDutchFlag: true, showBasket: true),
        DialogueLine(speaker: "mother", text: "Dutch Flag? What does a flag have to do with laundry?", showDutchFlag: true, showBasket: true),
        DialogueLine(speaker: "kid",    text: "The Dutch flag has three stripes — red, white, and blue.", showDutchFlag: true, showBasket: true),
        DialogueLine(speaker: "kid",    text: "Just like our clothes! We sort them into three groups.", showDutchFlag: true, showBasket: true),
        DialogueLine(speaker: "mother", text: "But how do you sort inside one basket?", showBasket: true),
        DialogueLine(speaker: "kid",    text: "We use three pointers: Front, Current, and Back.", showBasket: true),
        DialogueLine(speaker: "kid",    text: "Front sends red items to the left side.", showBasket: true),
        DialogueLine(speaker: "kid",    text: "Back sends blue items to the right side.", showBasket: true),
        DialogueLine(speaker: "mother", text: "And the white items?", showBasket: true),
        DialogueLine(speaker: "kid",    text: "White stays in the middle! Current just skips over them.", showBasket: true),
        DialogueLine(speaker: "kid",    text: "The best part? It only takes ONE pass through the basket!", showBasket: true),
        DialogueLine(speaker: "mother", text: "One pass? That's impressive! Show me!", showBasket: true),
        DialogueLine(speaker: "kid",    text: "Watch this, Mom! Here we go!", showBasket: true),
    ]

    // ── Conversation state ──
    @State private var dialogueStep = 0
    @State private var showTapPrompt = false
    @State private var typingDone = false

    // ── Sorting state ──
    struct ClothingItem: Identifiable {
        let id = UUID()
        let item: LaundryItem
    }

    @State private var showSorting = false
    @State private var items: [ClothingItem] = [
        ClothingItem(item: .blueJeans),
        ClothingItem(item: .redTShirt),
        ClothingItem(item: .whiteSocks),
        ClothingItem(item: .blueJeans),
        ClothingItem(item: .redTShirt),
        ClothingItem(item: .whiteSocks),
        ClothingItem(item: .redTShirt),
        ClothingItem(item: .blueJeans),
    ]
    @State private var low  = 0
    @State private var mid  = 0
    @State private var high = 7
    @State private var narration = "Select \"Continue Operation\" to begin."
    @State private var stepCount = 0
    @Namespace private var sortAnim

    // ── Drag-to-basket finale state ──
    @State private var showDragFinale = false
    @State private var droppedIDs: Set<UUID> = []
    @State private var dragOffsets: [UUID: CGSize] = [:]
    @State private var dragActive: UUID? = nil

    var body: some View {
        GeometryReader { geo in
            ZStack {
                sandColor.ignoresSafeArea()

                Image("Scene2Background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .opacity(1.0)

                // Subtle grid background for "Workshop" feel
                Path { path in
                    for i in 0...Int(geo.size.width / 40) {
                        path.move(to: CGPoint(x: CGFloat(i) * 40, y: 0))
                        path.addLine(to: CGPoint(x: CGFloat(i) * 40, y: geo.size.height))
                    }
                    for i in 0...Int(geo.size.height / 40) {
                        path.move(to: CGPoint(x: 0, y: CGFloat(i) * 40))
                        path.addLine(to: CGPoint(x: geo.size.width, y: CGFloat(i) * 40))
                    }
                }
                .stroke(charcoalColor.opacity(0.03), lineWidth: 0.5)

                // Kid
                Image("KidStanding").resizable().scaledToFit().frame(height: 140)
                    .position(x: geo.size.width * 0.18, y: geo.size.height * 0.85)
                    .opacity(showSorting ? 0.3 : 1.0)

                // Mother
                Image("Mother").resizable().scaledToFit().frame(height: 260)
                    .position(x: geo.size.width * 0.82, y: geo.size.height * 0.75)
                    .opacity(showSorting ? 0.3 : 1.0)

                // Dirty clothes pile
                if !showSorting && dialogueStep < script.count && script[dialogueStep].showDirtyClothes {
                    Image("DirtyClothes").resizable().scaledToFit().frame(width: 200)
                        .position(x: geo.size.width * 0.50, y: geo.size.height * 0.78)
                        .transition(.opacity)
                }

                // Empty basket
                if !showSorting && dialogueStep < script.count && script[dialogueStep].showBasket {
                    Image("EmptyBasket").resizable().scaledToFit().frame(height: 140)
                        .position(x: geo.size.width * 0.50, y: geo.size.height * 0.80)
                        .transition(.opacity)
                }

                // Dutch flag
                if !showSorting && dialogueStep < script.count && script[dialogueStep].showDutchFlag {
                    VStack(spacing: 20) {
                        Image("DutchFlagLogo").resizable().scaledToFit()
                            .frame(width: 160)
                            .overlay(Rectangle().stroke(charcoalColor.opacity(0.1), lineWidth: 0.5))
                        
                        if script[dialogueStep].text.contains("three stripes") {
                            HStack(spacing: 12) {
                                FlagStripeLabel(color: mutedRed, name: "RED")
                                FlagStripeLabel(color: .gray.opacity(0.8), name: "WHITE")
                                FlagStripeLabel(color: mutedBlue, name: "BLUE")
                            }
                        }
                    }
                    .position(x: geo.size.width * 0.50, y: geo.size.height * 0.50)
                    .transition(.opacity)
                }

                // Speech bubbles
                if !showSorting && dialogueStep < script.count {
                    let line = script[dialogueStep]
                    Group {
                        if line.speaker == "mother" {
                            SpeechBubble(text: line.text, isLeft: false, onTypingComplete: bubbleDone)
                                .position(x: geo.size.width * 0.70, y: geo.size.height * 0.25)
                        } else {
                            SpeechBubble(text: line.text, isLeft: true, onTypingComplete: bubbleDone)
                                .position(x: geo.size.width * 0.30, y: geo.size.height * 0.50)
                        }
                    }
                    .id("b-\(dialogueStep)")

                    if showTapPrompt {
                        VStack {
                            Spacer()
                            Text("TAP TO CONTINUE")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(2)
                                .foregroundColor(charcoalColor.opacity(0.4))
                                .padding(.bottom, 40)
                        }
                    }

                    Color.clear.contentShape(Rectangle()).onTapGesture { handleTap() }
                }

                if showSorting && !showDragFinale {
                    sortingPanel(geo: geo)
                }

                if showDragFinale {
                    dragFinale(geo: geo)
                }
            }
        }
    }

    @ViewBuilder
    func sortingPanel(geo: GeometryProxy) -> some View {
        ZStack {
            Color.black.opacity(0.15).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("ACTIVE SORT OPERATION")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(1.5)
                        .foregroundColor(charcoalColor.opacity(0.6))
                    Spacer()
                    Text("STEP \(stepCount)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(ivoryColor)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(charcoalColor)
                }
                .padding(24)

                Divider().background(charcoalColor.opacity(0.05))

                // Narration
                Text(narration.uppercased())
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundColor(charcoalColor)
                    .padding(.vertical, 32)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)

                // Items list
                HStack(spacing: 8) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { idx, ci in
                        VStack(spacing: 12) {
                            // Top Pointer
                            if idx == low {
                                pointerLabel(text: "FRONT", color: mutedRed)
                            } else {
                                Spacer().frame(height: 20)
                            }

                            Image(ci.item.imageName).resizable().scaledToFit()
                                .frame(width: 44, height: 44)
                                .padding(8)
                                .background(ivoryColor)
                                .overlay(Rectangle().stroke(charcoalColor.opacity(0.1), lineWidth: 0.5))
                                .matchedGeometryEffect(id: ci.id, in: sortAnim)

                            // Bottom Pointers
                            if idx == mid && mid <= high {
                                pointerLabel(text: "CURRENT", color: charcoalColor)
                            } else if idx == high {
                                pointerLabel(text: "BACK", color: mutedBlue)
                            } else {
                                Spacer().frame(height: 20)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)

                Divider().background(charcoalColor.opacity(0.05))

                // Actions
                HStack {
                    if mid > high {
                        Button(action: startDragFinale) {
                            Text("INITIALIZE PACKING")
                                .font(.system(size: 13, weight: .bold))
                                .tracking(1)
                                .foregroundColor(ivoryColor)
                                .padding(.horizontal, 40).padding(.vertical, 16)
                                .background(terracottaColor)
                        }
                    } else {
                        Button(action: performNextStep) {
                            Text("PERFORM NEXT STEP")
                                .font(.system(size: 13, weight: .bold))
                                .tracking(1)
                                .foregroundColor(ivoryColor)
                                .padding(.horizontal, 40).padding(.vertical, 16)
                                .background(charcoalColor)
                        }
                    }
                }
                .padding(24)
            }
            .frame(width: 680)
            .background(ivoryColor)
            .shadow(color: charcoalColor.opacity(0.05), radius: 40, x: 0, y: 20)
        }
    }

    @ViewBuilder
    func pointerLabel(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 8, weight: .bold))
            .tracking(1)
            .foregroundColor(color)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .overlay(Rectangle().stroke(color, lineWidth: 0.5))
    }

    @ViewBuilder
    func dragFinale(geo: GeometryProxy) -> some View {
        ZStack {
            ivoryColor
                .frame(width: geo.size.width, height: geo.size.height)

            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Sorted State Achieved")
                        .font(.system(size: 28, weight: .medium, design: .serif))
                        .foregroundColor(charcoalColor)
                    Text("MANUAL TRANSFER TO STORAGE BASKET REQUIRED")
                        .font(.system(size: 10, weight: .bold))
                        .tracking(1.5)
                        .foregroundColor(charcoalColor.opacity(0.4))
                }

                HStack(spacing: 12) {
                    ForEach(sortedFinaleItems) { ci in
                        if droppedIDs.contains(ci.id) {
                            Rectangle()
                                .stroke(charcoalColor.opacity(0.05), lineWidth: 0.5)
                                .frame(width: 52, height: 52)
                        } else {
                            draggableItem(ci: ci, geo: geo)
                        }
                    }
                }
                .padding(.vertical, 20)

                ZStack {
                    Image("EmptyBasket").resizable().scaledToFit().frame(height: 140)
                        .opacity(0.8)
                    
                    Rectangle()
                        .stroke(charcoalColor.opacity(0.1), style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .frame(width: 280, height: 120)
                        .overlay(
                            Text("\(droppedIDs.count) / \(items.count) TRANSFERRED")
                                .font(.system(size: 9, weight: .bold))
                                .tracking(1)
                                .foregroundColor(charcoalColor.opacity(0.4))
                                .offset(y: 70)
                        )
                }

                if droppedIDs.count == items.count {
                    Button(action: { director.transition(to: .scene3) }) {
                        Text("VIEW FINAL ANALYSIS")
                            .font(.system(size: 14, weight: .bold))
                            .tracking(1.5)
                            .foregroundColor(ivoryColor)
                            .padding(.horizontal, 60).padding(.vertical, 18)
                            .background(terracottaColor)
                    }
                    .transition(.opacity)
                }
            }
        }
    }

    @ViewBuilder
    func draggableItem(ci: ClothingItem, geo: GeometryProxy) -> some View {
        let offset = dragOffsets[ci.id] ?? .zero
        let isDragging = dragActive == ci.id
        let isNext = nextDragID == ci.id

        Image(ci.item.imageName).resizable().scaledToFit()
            .frame(width: 52, height: 52)
            .padding(4)
            .background(ivoryColor)
            .overlay(
                Rectangle()
                    .stroke(isNext ? charcoalColor : charcoalColor.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: isDragging ? charcoalColor.opacity(0.1) : .clear, radius: 10)
            .opacity(isNext ? 1.0 : 0.2)
            .offset(offset)
            .zIndex(isDragging ? 10 : 1)
            .gesture(
                isNext
                ? AnyGesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { val in
                            dragActive = ci.id
                            dragOffsets[ci.id] = val.translation
                        }
                        .onEnded { val in
                            dragActive = nil
                            if val.location.y > geo.size.height * 0.55 {
                                withAnimation(.spring(response: 0.3)) {
                                    droppedIDs.insert(ci.id)
                                    dragOffsets[ci.id] = .zero
                                }
                            } else {
                                withAnimation(.spring(response: 0.4)) {
                                    dragOffsets[ci.id] = .zero
                                }
                            }
                        }
                        .map { $0 as Any }
                )
                : AnyGesture(DragGesture(minimumDistance: 999).map { $0 as Any })
            )
    }

    private var sortedFinaleItems: [ClothingItem] {
        items.sorted { a, b in
            let order: [LaundryItem: Int] = [.redTShirt: 0, .whiteSocks: 1, .blueJeans: 2]
            return order[a.item]! < order[b.item]!
        }
    }

    private var nextDragID: UUID? {
        sortedFinaleItems.first { !droppedIDs.contains($0.id) }?.id
    }

    func performNextStep() {
        guard mid <= high else { return }
        withAnimation(.spring(response: 0.6)) {
            let cur = items[mid].item
            stepCount += 1
            switch cur {
            case .redTShirt:
                narration = "Red detected. Swapping with Front pointer."
                items.swapAt(low, mid); low += 1; mid += 1
            case .whiteSocks:
                narration = "White detected. Maintaining position."
                mid += 1
            case .blueJeans:
                narration = "Blue detected. Swapping with Back pointer."
                items.swapAt(mid, high); high -= 1
            }
        }
    }

    func startDragFinale() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showDragFinale = true
            showSorting = false
        }
    }

    func bubbleDone() {
        typingDone = true
        withAnimation { showTapPrompt = true }
    }

    func handleTap() {
        guard typingDone else { return }
        typingDone = false
        showTapPrompt = false
        dialogueStep += 1
        if dialogueStep >= script.count {
            withAnimation { showSorting = true }
        }
    }
}

struct FlagStripeLabel: View {
    let color: Color
    let name: String
    var body: some View {
        Text(name)
            .font(.system(size: 9, weight: .bold))
            .tracking(1)
            .foregroundColor(color)
            .padding(.horizontal, 10).padding(.vertical, 5)
            .overlay(Rectangle().stroke(color, lineWidth: 0.5))
    }
}

#Preview {
    Scene2View()
        .environmentObject(MovieDirector())
}
