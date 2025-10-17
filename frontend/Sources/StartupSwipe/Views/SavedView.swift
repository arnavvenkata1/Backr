import SwiftUI

struct SavedView: View {
    @EnvironmentObject private var viewModel: SwipeDeckViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // Dark Background
                Color.darkBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 20)

                    if viewModel.saved.isEmpty {
                        emptyState
                    } else {
                        savedList
                    }
                }
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Saved")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.textPrimary, Color.errorColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.errorColor)
                    Text("\(viewModel.saved.count) companies")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.errorColor)
                }
            }

            Spacer()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.errorColor.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: "heart.slash")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundStyle(Color.errorColor)
            }

            Text("No saved startups yet")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)

            Text("Swipe right on companies you love")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(.horizontal, 40)
    }

    private var savedList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.saved) { startup in
                    NavigationLink(destination: StartupDetailView(startup: startup)) {
                        SavedCardRow(startup: startup)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct SavedCardRow: View {
    let startup: Startup
    @EnvironmentObject private var viewModel: SwipeDeckViewModel

    var body: some View {
        HStack(spacing: 14) {
            // Logo emoji
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [sectorColor.opacity(0.3), sectorColor.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)

                Text(startup.logoEmoji)
                    .font(.system(size: 26))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(startup.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Circle()
                        .fill(sectorColor)
                        .frame(width: 5, height: 5)
                    Text(startup.sector)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(sectorColor)
                }

                HStack(spacing: 10) {
                    statLabel(icon: "dollarsign.circle.fill", text: formattedCurrency(startup.valuation), color: .successColor)
                    statLabel(icon: "chart.line.uptrend.xyaxis", text: formattedGrowth(startup.growthRate), color: .warningColor)
                }
            }

            Spacer()

            VStack(spacing: 8) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if let index = viewModel.saved.firstIndex(where: { $0.id == startup.id }) {
                            viewModel.removeSaved(at: IndexSet(integer: index))
                        }
                    }
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.errorColor)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.errorColor.opacity(0.15))
                        )
                }
                .buttonStyle(.plain)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(sectorColor.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: sectorColor.opacity(0.2), radius: 12, y: 6)
        )
    }
    
    private func statLabel(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(color)
            Text(text)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    private var sectorColor: Color {
        Color.sectorColor(for: startup.sector)
    }

    private func formattedCurrency(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "$%.1fB", value / 1000)
        } else {
            return String(format: "$%.0fM", value)
        }
    }

    private func formattedGrowth(_ value: Double) -> String {
        String(format: "%.0f%%", value)
    }
}
