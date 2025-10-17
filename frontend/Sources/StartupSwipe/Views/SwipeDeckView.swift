import SwiftUI

struct SwipeDeckView: View {
    let queue: [Startup]
    let onDecision: (SwipeDecision) -> Void

    @State private var dragOffset: CGSize = .zero
    private let threshold: CGFloat = 120

    var body: some View {
        ZStack {
            if queue.isEmpty {
                emptyState
            } else if let topCard = queue.first {
                // Show ONLY the top card
                StartupCardView(startup: topCard, dragOffset: dragOffset)
                    .padding(.horizontal, 16)
                    .offset(x: dragOffset.width, y: dragOffset.height * 0.2)
                    .rotationEffect(.degrees(Double(dragOffset.width / 25)))
                    .gesture(dragGesture)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .offset(x: dragOffset.width > 0 ? 500 : -500, y: 0)
                            .combined(with: .opacity)
                    ))
                    .animation(.spring(response: 0.35, dampingFraction: 0.75), value: queue.count)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(Color("Accent"))
            Text("All caught up!")
                .font(.title2.bold())
                .foregroundStyle(.black)
            Text("New startups coming soon")
                .font(.callout)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                if value.translation.width > threshold {
                    swipe(.saved)
                } else if value.translation.width < -threshold {
                    swipe(.skipped)
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dragOffset = .zero
                    }
                }
            }
    }

    private func swipe(_ decision: SwipeDecision) {
        let horizontal: CGFloat = decision == .saved ? 600 : -600
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            dragOffset = CGSize(width: horizontal, height: 0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            dragOffset = .zero
            onDecision(decision)
        }
    }
}
