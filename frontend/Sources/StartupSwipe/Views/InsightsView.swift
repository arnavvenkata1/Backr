import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var viewModel: SwipeDeckViewModel

    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.96, blue: 0.98)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    header
                    statsGrid
                    activitySection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Insights")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(.black)

                HStack(spacing: 6) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Your investment activity")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                }
                .foregroundStyle(Color("Accent"))
            }

            Spacer()
        }
    }

    private var statsGrid: some View {
        HStack(spacing: 14) {
            statCard(
                value: "\(viewModel.saved.count)",
                label: "Saved",
                icon: "heart.fill",
                color: Color("Accent")
            )

            statCard(
                value: "\(viewModel.skipped.count)",
                label: "Skipped",
                icon: "xmark",
                color: .red
            )
        }
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(color.opacity(0.12))
                )

            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(.black)

                Text(label)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.black)

            if viewModel.saved.isEmpty && viewModel.skipped.isEmpty {
                emptyActivity
            } else {
                recentList
            }
        }
    }

    private var emptyActivity: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Color("Accent").opacity(0.4))

            Text("No activity yet")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(.gray)

            Text("Start swiping to see insights")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.gray.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private var recentList: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.saved.prefix(5)) { startup in
                activityRow(startup: startup, action: "Saved", color: Color("Accent"))
            }
        }
    }

    private func activityRow(startup: Startup, action: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 40, height: 40)

                Text(String(startup.name.prefix(1)))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(startup.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.black)

                Text(action)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(color)
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 6, y: 3)
        )
    }
}
