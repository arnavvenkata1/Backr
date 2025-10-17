import SwiftUI
import Charts

struct StartupCardView: View {
    let startup: Startup
    var dragOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Dark card with glowing border
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [sectorColor.opacity(0.6), sectorColor.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: sectorColor.opacity(0.3), radius: 24, y: 12)

            // Content
            VStack(alignment: .leading, spacing: 14) {
                header
                
                Divider()
                    .background(Color.textTertiary.opacity(0.2))
                
                description
                
                // Mini growth chart
                growthChart
                
                statsSection
                
                Spacer()
                
                metricsGrid
            }
            .padding(22)

            // Swipe indicators
            swipeIndicator
        }
        .frame(maxWidth: .infinity)
        .frame(height: 540)
    }

    private var header: some View {
        HStack(spacing: 14) {
            // Company logo emoji
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [sectorColor.opacity(0.3), sectorColor.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Text(startup.logoEmoji)
                    .font(.system(size: 32))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(startup.name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                HStack(spacing: 6) {
                    Circle()
                        .fill(sectorColor)
                        .frame(width: 6, height: 6)
                    Text(startup.sector.uppercased())
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(0.8)
                        .foregroundStyle(sectorColor)
                }
            }

            Spacer(minLength: 4)
            
            // Similarity score badge
            VStack(spacing: 3) {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(sectorColor)
                    Text("\(startup.similarityScore)%")
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundStyle(sectorColor)
                }
                Text("MATCH")
                    .font(.system(size: 8, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textTertiary)
                    .tracking(0.5)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(sectorColor.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(sectorColor.opacity(0.4), lineWidth: 1)
                    )
            )
        }
    }

    private var description: some View {
        Text(startup.description)
            .font(.system(size: 14, weight: .regular, design: .rounded))
            .foregroundStyle(Color.textSecondary)
            .lineLimit(3)
            .lineSpacing(3)
    }
    
    private var growthChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(sectorColor)
                Text("6-Month Trend")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                Spacer()
                Text("\(startup.totalInvestors) investors")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textTertiary)
            }
            
            // Simple line chart with gradient
            GeometryReader { geo in
                ZStack(alignment: .bottom) {
                    // Grid lines
                    VStack(spacing: 0) {
                        ForEach(0..<3) { _ in
                            Divider()
                                .background(Color.textTertiary.opacity(0.1))
                            Spacer()
                        }
                    }
                    
                    // Area gradient
                    Path { path in
                        let maxValue = startup.monthlyGrowthData.max() ?? 1
                        let stepX = geo.size.width / CGFloat(startup.monthlyGrowthData.count - 1)
                        
                        path.move(to: CGPoint(x: 0, y: geo.size.height))
                        
                        for (index, value) in startup.monthlyGrowthData.enumerated() {
                            let x = CGFloat(index) * stepX
                            let y = geo.size.height - (CGFloat(value / maxValue) * geo.size.height * 0.8)
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                        
                        path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [sectorColor.opacity(0.4), sectorColor.opacity(0.05)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Line chart
                    Path { path in
                        let maxValue = startup.monthlyGrowthData.max() ?? 1
                        let stepX = geo.size.width / CGFloat(startup.monthlyGrowthData.count - 1)
                        
                        for (index, value) in startup.monthlyGrowthData.enumerated() {
                            let x = CGFloat(index) * stepX
                            let y = geo.size.height - (CGFloat(value / maxValue) * geo.size.height * 0.8)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(sectorColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    
                    // Points
                    ForEach(startup.monthlyGrowthData.indices, id: \.self) { index in
                        let maxValue = startup.monthlyGrowthData.max() ?? 1
                        let stepX = geo.size.width / CGFloat(startup.monthlyGrowthData.count - 1)
                        let x = CGFloat(index) * stepX
                        let y = geo.size.height - (CGFloat(startup.monthlyGrowthData[index] / maxValue) * geo.size.height * 0.8)
                        
                        Circle()
                            .fill(sectorColor)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)
                    }
                }
            }
            .frame(height: 70)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkBackground.opacity(0.5))
        )
    }

    private var statsSection: some View {
        HStack(spacing: 12) {
            statBadge(icon: "mappin.circle.fill", text: startup.location, color: sectorColor)
            statBadge(icon: "person.3.fill", text: "\(startup.employees) team", color: sectorColor.opacity(0.8))
        }
    }
    
    private func statBadge(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(color)
            Text(text)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(color.opacity(0.15))
        )
    }

    private var metricsGrid: some View {
        VStack(spacing: 10) {
            HStack {
                metricBox(title: "Valuation", value: formattedCurrency(startup.valuation), icon: "dollarsign.circle.fill", color: .successColor)
                metricBox(title: "Revenue", value: formattedCurrency(startup.revenue), icon: "chart.line.uptrend.xyaxis", color: .accentPrimary)
            }
            HStack {
                metricBox(title: "Growth", value: formattedGrowth(startup.growthRate), icon: "arrow.up.right.circle.fill", color: .warningColor)
                metricBox(title: "Stage", value: startup.fundingStage, icon: "lightbulb.fill", color: Color.errorColor)
            }
        }
    }

    private func metricBox(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textTertiary)
            }
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.darkBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private var swipeIndicator: some View {
        Group {
            if dragOffset.width > 50 {
                indicator(text: "INVEST", color: Color.accentPrimary, rotation: -20)
                    .opacity(min(Double(dragOffset.width) / 120, 1.0))
            } else if dragOffset.width < -50 {
                indicator(text: "SKIP", color: Color.errorColor, rotation: 20)
                    .opacity(min(Double(-dragOffset.width) / 120, 1.0))
            }
        }
    }

    private func indicator(text: String, color: Color, rotation: Double) -> some View {
        ZStack {
            // Outer stroke
            Text(text)
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundStyle(.clear)
                .overlay(
                    Text(text)
                        .font(.system(size: 42, weight: .black, design: .rounded))
                        .foregroundStyle(color)
                )
                .shadow(color: color.opacity(0.5), radius: 4, x: -2, y: -2)
                .shadow(color: color.opacity(0.5), radius: 4, x: 2, y: 2)
            
            // Inner text
            Text(text)
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundStyle(color)
                .shadow(color: color.opacity(0.8), radius: 20, y: 0)
        }
        .rotationEffect(.degrees(rotation))
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func formattedCurrency(_ value: Double) -> String {
        String(format: "$%.1fM", value)
    }

    private func formattedGrowth(_ value: Double) -> String {
        String(format: "%.0f%% YoY", value)
    }
    
    private var sectorColor: Color {
        Color.sectorColor(for: startup.sector)
    }
}

