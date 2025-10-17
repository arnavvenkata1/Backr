import SwiftUI
import Charts

struct PortfolioView: View {
    @StateObject private var portfolio = PortfolioManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                headerSection
                
                // Portfolio Summary
                portfolioSummary
                
                // Performance Chart
                if !portfolio.investments.isEmpty {
                    performanceChart
                }
                
                // Investments List
                investmentsList
            }
            .padding(20)
        }
        .background(Color.darkBackground)
        .navigationTitle("Portfolio")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Portfolio")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            Text("Track your startup investments and returns")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    private var portfolioSummary: some View {
        VStack(spacing: 16) {
            // Total Value
            VStack(spacing: 8) {
                Text("Total Portfolio Value")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                
                Text(formattedCurrency(portfolio.totalCurrentValue))
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                
                HStack(spacing: 8) {
                    Image(systemName: portfolio.totalReturn >= 0 ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 14, weight: .bold))
                    Text("\(formattedCurrency(abs(portfolio.totalReturn))) (\(String(format: "%.1f", abs(portfolio.totalReturnPercentage)))%)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundStyle(portfolio.totalReturn >= 0 ? Color.successColor : Color.errorColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill((portfolio.totalReturn >= 0 ? Color.successColor : Color.errorColor).opacity(0.2))
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            
            // Stats Grid
            HStack(spacing: 16) {
                statCard(title: "Invested", value: formattedCurrency(portfolio.totalInvested), icon: "dollarsign.circle.fill", color: .accentPrimary)
                statCard(title: "Companies", value: "\(portfolio.investments.count)", icon: "building.2.fill", color: .accentSecondary)
                statCard(title: "Avg Return", value: "\(String(format: "%.1f", portfolio.totalReturnPercentage))%", icon: "chart.line.uptrend.xyaxis", color: portfolio.totalReturn >= 0 ? .successColor : .errorColor)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.accentPrimary.opacity(0.2), radius: 16, y: 8)
        )
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var performanceChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Portfolio Performance")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            Chart {
                ForEach(Array(portfolio.investments.enumerated()), id: \.element.id) { index, investment in
                    BarMark(
                        x: .value("Company", investment.startupName),
                        y: .value("Return", investment.returnPercentage)
                    )
                    .foregroundStyle(investment.returnPercentage >= 0 ? Color.successColor : Color.errorColor)
                    .cornerRadius(6)
                }
            }
            .frame(height: 200)
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
                        .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.accentPrimary.opacity(0.2), radius: 12, y: 6)
        )
    }
    
    private var investmentsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Investments")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            if portfolio.investments.isEmpty {
                emptyState
            } else {
                ForEach(portfolio.investments) { investment in
                    InvestmentCard(investment: investment)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("📊")
                .font(.system(size: 60))
            Text("No Investments Yet")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            Text("Start swiping and investing in startups to build your portfolio!")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.textTertiary.opacity(0.3), lineWidth: 1.5)
                )
        )
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "$%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "$%.1fK", value / 1000)
        } else {
            return String(format: "$%.0f", value)
        }
    }
}

struct InvestmentCard: View {
    let investment: Investment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 16) {
                Text(investment.startupLogo)
                    .font(.system(size: 36))
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [sectorColor.opacity(0.3), sectorColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(investment.startupName)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(sectorColor)
                            .frame(width: 6, height: 6)
                        Text(investment.startupSector)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(sectorColor)
                    }
                    
                    Text("Invested \(formattedDate(investment.investmentDate))")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textTertiary)
                }
                
                Spacer()
            }
            
            Divider()
                .background(Color.textTertiary.opacity(0.3))
            
            // Investment Details
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Invested")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textTertiary)
                    Text(formattedCurrency(investment.amount))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Current Value")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textTertiary)
                    Text(formattedCurrency(investment.currentValue))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Return")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.textTertiary)
                    HStack(spacing: 4) {
                        Image(systemName: investment.returnAmount >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 10, weight: .bold))
                        Text("\(String(format: "%.1f", abs(investment.returnPercentage)))%")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(investment.returnAmount >= 0 ? Color.successColor : Color.errorColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill((investment.returnAmount >= 0 ? Color.successColor : Color.errorColor).opacity(0.2))
                    )
                }
            }
            
            // Shares Info
            HStack {
                Text("\(investment.shares) shares @ $\(String(format: "%.2f", investment.pricePerShare))")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textTertiary)
                Spacer()
            }
        }
        .padding(20)
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
    
    private var sectorColor: Color {
        switch investment.startupSector.lowercased() {
        case let s where s.contains("tech"): return .accentPrimary
        case let s where s.contains("beauty"): return Color.pink
        case let s where s.contains("food"): return .warningColor
        case let s where s.contains("health"): return .errorColor
        case let s where s.contains("finance"): return .successColor
        default: return .accentSecondary
        }
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "$%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "$%.1fK", value / 1000)
        } else {
            return String(format: "$%.0f", value)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

