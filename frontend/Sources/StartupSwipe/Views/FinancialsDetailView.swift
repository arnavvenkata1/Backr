import SwiftUI
import Charts

struct FinancialsDetailView: View {
    let startup: Startup
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Revenue Chart
                revenueChartSection
                
                // Financial Metrics Grid
                metricsGrid
                
                // Projections
                projectionsSection
                
                // Breakdown
                breakdownSection
            }
            .padding(20)
        }
        .background(Color.darkBackground)
        .navigationTitle("Financials")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var revenueChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Growth")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            Chart {
                ForEach(startup.monthlyGrowthData.indices, id: \.self) { index in
                    LineMark(
                        x: .value("Month", monthName(for: index)),
                        y: .value("Revenue", startup.monthlyGrowthData[index])
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.successColor, Color.accentPrimary],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    AreaMark(
                        x: .value("Month", monthName(for: index)),
                        y: .value("Revenue", startup.monthlyGrowthData[index])
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.successColor.opacity(0.3), Color.accentPrimary.opacity(0.1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Month", monthName(for: index)),
                        y: .value("Revenue", startup.monthlyGrowthData[index])
                    )
                    .foregroundStyle(Color.successColor)
                    .symbolSize(60)
                }
            }
            .frame(height: 220)
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel()
                        .foregroundStyle(Color.textSecondary)
                    AxisGridLine()
                        .foregroundStyle(Color.textTertiary.opacity(0.3))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.successColor.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.successColor.opacity(0.2), radius: 12, y: 6)
        )
    }
    
    private var metricsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Metrics")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                metricCard(title: "ARR", value: formattedCurrency(startup.revenue), icon: "dollarsign.circle.fill", color: .successColor, change: "+\(Int(startup.growthRate))%")
                metricCard(title: "Valuation", value: formattedCurrency(startup.valuation), icon: "chart.line.uptrend.xyaxis", color: .accentPrimary, change: "+18%")
                metricCard(title: "Burn Rate", value: "$2.4M/mo", icon: "flame.fill", color: .warningColor, change: "Healthy")
                metricCard(title: "Runway", value: "18 months", icon: "timer", color: .accentSecondary, change: "Good")
                metricCard(title: "Gross Margin", value: "72%", icon: "percent", color: .accentPrimary, change: "+5%")
                metricCard(title: "LTV/CAC", value: "3.2x", icon: "arrow.up.right", color: .accentSecondary, change: "Strong")
            }
        }
    }
    
    private func metricCard(title: String, value: String, icon: String, color: Color, change: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(color)
                Spacer()
                Text(change)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(color.opacity(0.2))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                Text(title)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(color.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: color.opacity(0.2), radius: 8, y: 4)
        )
    }
    
    private var projectionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("12-Month Projections")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            VStack(spacing: 14) {
                projectionRow(label: "Revenue", current: formattedCurrency(startup.revenue), projected: formattedCurrency(startup.revenue * 2.5), color: .successColor)
                projectionRow(label: "Users", current: "12K", projected: "45K", color: .accentPrimary)
                projectionRow(label: "Team Size", current: "\(startup.employees)", projected: "\(Int(Double(startup.employees) * 1.8))", color: .accentSecondary)
                projectionRow(label: "Markets", current: "3", projected: "8", color: .warningColor)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.accentPrimary.opacity(0.2), radius: 12, y: 6)
        )
    }
    
    private func projectionRow(label: String, current: String, projected: String, color: Color) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textTertiary)
                    Text(current)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Projected")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textTertiary)
                    Text(projected)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(color)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Breakdown")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            VStack(spacing: 12) {
                breakdownBar(label: "Enterprise", percentage: 62, color: .accentPrimary)
                breakdownBar(label: "SMB", percentage: 28, color: .successColor)
                breakdownBar(label: "Self-Serve", percentage: 10, color: .accentSecondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.accentPrimary.opacity(0.2), radius: 12, y: 6)
        )
    }
    
    private func breakdownBar(label: String, percentage: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text("\(percentage)%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.darkBackground.opacity(0.5))
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentage) / 100)
                }
            }
            .frame(height: 10)
        }
    }
    
    private func monthName(for index: Int) -> String {
        let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        return monthNames[min(index, monthNames.count - 1)]
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "$%.1fB", value / 1000)
        } else {
            return String(format: "$%.1fM", value)
        }
    }
}
