import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var viewModel: SwipeDeckViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Dark gradient background
                LinearGradient(
                    colors: [
                        Color.darkBackground,
                        Color.darkBackground.opacity(0.95)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    header
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    SwipeDeckView(queue: viewModel.queue) { decision in
                        viewModel.swipe(decision)
                    }
                    .frame(height: min(geo.size.height * 0.65, 580))
                    
                    Spacer()
                    
                    actionButtons
                        .padding(.bottom, 16)
                }
                .padding(.horizontal, 20)
            }
        }
        .task {
            if viewModel.queue.isEmpty {
                await viewModel.loadInitial()
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Discover")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.textPrimary, Color.accentPrimary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .onTapGesture(count: 5) {
                        // Secret: Tap "Discover" 5 times to reset
                        resetApp()
                    }

                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Swipe right to invest")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                }
                .foregroundStyle(Color.accentPrimary)
            }

            Spacer()
            
            // Account Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.accentPrimary, Color.accentSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .shadow(color: Color.accentPrimary.opacity(0.5), radius: 12, y: 4)
                
                Text("AV")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 22) {
            Button {
                viewModel.rewindLast()
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.textSecondary)
                    .frame(width: 52, height: 52)
                    .background(
                        Circle()
                            .fill(Color.darkCard)
                            .overlay(
                                Circle()
                                    .stroke(Color.textTertiary.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 12, y: 6)
                    )
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                viewModel.swipe(.skipped)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 62, height: 62)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.errorColor.opacity(0.9), Color.errorColor],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.errorColor.opacity(0.5), radius: 16, y: 8)
                    )
            }
            .buttonStyle(.plain)

            Button {
                viewModel.swipe(.saved)
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.accentPrimary, Color.accentSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.accentPrimary.opacity(0.6), radius: 20, y: 10)
                    )
            }
            .buttonStyle(.plain)
        }
    }
    
    private func resetApp() {
        // Clear all user data
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "userPreferences")
        UserDefaults.standard.removeObject(forKey: "userInvestments")
        
        // Force app to restart
        exit(0)
    }
}
