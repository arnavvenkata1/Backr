import SwiftUI

struct StartupDetailView: View {
    let startup: Startup
    @Environment(\.dismiss) private var dismiss
    @State private var showInvestSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    missionVisionSection
                    quickStats
                    descriptionSection
                    
                    // Quick Action Buttons
                    quickActionButtons
                    
                    // Sections
                    financialMetrics
                    aiAnalysisSection
                    teamSection
                    marketSection
                    
                    // Add spacing for invest button
                    Color.clear.frame(height: 100)
                }
                .padding(20)
            }
            
            // Floating Invest Button
            investButton
        }
        .background(Color.darkBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .sheet(isPresented: $showInvestSheet) {
            InvestSheetView(startup: startup)
        }
    }
    
    private var quickActionButtons: some View {
        VStack(spacing: 12) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                NavigationLink(destination: FinancialsDetailView(startup: startup)) {
                    actionButton(icon: "chart.bar.fill", title: "View Financials", color: .successColor)
                }
                
                NavigationLink(destination: FoundersDetailView(startup: startup)) {
                    actionButton(icon: "person.3.fill", title: "Meet the Team", color: .accentPrimary)
                }
            }
        }
    }
    
    private func actionButton(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(color)
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(color.opacity(0.5), lineWidth: 2)
                )
        )
        .shadow(color: color.opacity(0.3), radius: 12, y: 6)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [sectorColor, sectorColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: sectorColor.opacity(0.3), radius: 12, y: 6)
                    
                    Text(startup.logoEmoji)
                        .font(.system(size: 40))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(startup.name)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(sectorColor)
                            .frame(width: 6, height: 6)
                        Text(startup.sector)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(sectorColor)
                        
                        Circle()
                            .fill(Color.textTertiary)
                            .frame(width: 4, height: 4)
                        
                        Text(startup.location)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                
                Spacer()
            }
            
            // Similarity score banner
            HStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(sectorColor)
                Text("\(startup.similarityScore)% Match")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text(startup.momentum)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(sectorColor)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.darkCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(sectorColor.opacity(0.5), lineWidth: 2)
                    )
            )
            .shadow(color: sectorColor.opacity(0.3), radius: 12, y: 6)
        }
    }
    
    private var missionVisionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Mission & Vision", icon: "target")
            
            VStack(alignment: .leading, spacing: 16) {
                missionCard(
                    title: "Our Mission",
                    icon: "flag.fill",
                    text: startup.mission,
                    color: sectorColor
                )
                
                missionCard(
                    title: "5-Year Vision",
                    icon: "eye.fill",
                    text: startup.vision5Year,
                    color: sectorColor.opacity(0.8)
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func missionCard(title: String, icon: String, text: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
            }
            
            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(4)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkBackground.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var quickStats: some View {
        HStack(spacing: 12) {
            quickStatCard(icon: "person.3.fill", value: "\(startup.employees)", label: "Team", color: .blue)
            quickStatCard(icon: "flag.fill", value: startup.fundingStage, label: "Stage", color: .purple)
            if let website = startup.website {
                quickStatCard(icon: "globe", value: "Visit", label: website, color: sectorColor)
            }
        }
    }
    
    private func quickStatCard(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textTertiary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(color.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: color.opacity(0.2), radius: 12, y: 6)
        )
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "About", icon: "info.circle.fill")
            
            Text(startup.description)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(5)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private var financialMetrics: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Financials", icon: "chart.bar.fill")
            
            VStack(spacing: 12) {
                metricRow(label: "Valuation", value: formattedCurrency(startup.valuation), trend: "+18%", trendUp: true, color: .successColor)
                metricRow(label: "Annual Revenue", value: formattedCurrency(startup.revenue), trend: "+\(Int(startup.growthRate))%", trendUp: true, color: .accentPrimary)
                metricRow(label: "Growth Rate", value: "\(Int(startup.growthRate))% YoY", trend: "Strong", trendUp: true, color: .warningColor)
                metricRow(label: "Burn Rate", value: "$2.4M/mo", trend: "Healthy", trendUp: true, color: .accentSecondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .shadow(color: Color.black.opacity(0.3), radius: 12, y: 6)
        )
    }
    
    private func metricRow(label: String, value: String, trend: String, trendUp: Bool, color: Color) -> some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(label)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                
                HStack(spacing: 4) {
                    Image(systemName: trendUp ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10, weight: .bold))
                    Text(trend)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(trendUp ? Color.successColor : Color.errorColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill((trendUp ? Color.successColor : Color.errorColor).opacity(0.2))
                )
            }
        }
    }
    
    private var aiAnalysisSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "AI Analysis", icon: "brain.head.profile")
            
            VStack(spacing: 12) {
                analysisCard(
                    title: "Investment Score",
                    score: "8.5/10",
                    color: Color.green,
                    description: "Strong fundamentals with excellent growth trajectory and market positioning."
                )
                
                analysisCard(
                    title: "Risk Level",
                    score: "Medium",
                    color: Color.orange,
                    description: "Market competition is high but team execution is solid with proven track record."
                )
                
                analysisCard(
                    title: "Exit Potential",
                    score: "High",
                    color: sectorColor,
                    description: "Multiple acquisition targets identified and strong IPO viability within 3-5 years."
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func analysisCard(title: String, score: String, color: Color, description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                Spacer()
                Text(score)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color.opacity(0.2))
                    )
            }
            
            Text(description)
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(3)
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
    
    private var teamSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                sectionHeader(title: "Team & Culture", icon: "person.3.fill")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("Accent"))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                infoRow(icon: "graduationcap.fill", text: "Average 8+ years experience", color: .blue)
                infoRow(icon: "star.fill", text: "4.8/5 Glassdoor rating", color: .yellow)
                infoRow(icon: "building.2.fill", text: "Hybrid work culture", color: .purple)
                infoRow(icon: "gift.fill", text: "Competitive equity packages", color: .green)
            }
            
            Text("Tap to view founders & team details")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.accentPrimary)
                .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private var marketSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Market Insights", icon: "chart.line.uptrend.xyaxis")
            
            VStack(alignment: .leading, spacing: 12) {
                insightRow(title: "Market Size", value: "$48B TAM", color: .accentPrimary)
                insightRow(title: "Competition", value: "15 direct competitors", color: .warningColor)
                insightRow(title: "Market Growth", value: "22% CAGR", color: .successColor)
                insightRow(title: "Customer Retention", value: "94% annually", color: .accentSecondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(sectorColor)
            Text(title)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
        }
    }
    
    private func infoRow(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
        }
    }
    
    private func insightRow(title: String, value: String, color: Color) -> some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
            }
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
        }
    }
    
    private var sectorColor: Color {
        switch startup.sector.lowercased() {
        case let s where s.contains("fintech") || s.contains("finance"):
            return Color.green
        case let s where s.contains("health") || s.contains("medical"):
            return Color.red
        case let s where s.contains("ai") || s.contains("ml"):
            return Color.purple
        case let s where s.contains("green") || s.contains("climate") || s.contains("sustainable"):
            return Color.green.opacity(0.8)
        case let s where s.contains("fashion") || s.contains("beauty"):
            return Color.pink
        case let s where s.contains("food") || s.contains("fitness"):
            return Color.orange
        case let s where s.contains("edu") || s.contains("learning"):
            return Color.blue
        case let s where s.contains("gaming") || s.contains("game"):
            return Color.purple.opacity(0.8)
        case let s where s.contains("travel"):
            return Color.cyan
        case let s where s.contains("real estate") || s.contains("prop"):
            return Color.brown
        case let s where s.contains("tech") || s.contains("consumer"):
            return Color("Accent")
        case let s where s.contains("mobility") || s.contains("ride"):
            return Color.indigo
        case let s where s.contains("pet"):
            return Color.brown.opacity(0.7)
        case let s where s.contains("security") || s.contains("cyber"):
            return Color.red.opacity(0.8)
        case let s where s.contains("dev") || s.contains("cloud"):
            return Color.blue.opacity(0.8)
        default:
            return Color("Accent")
        }
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "$%.1fB", value / 1000)
        } else {
            return String(format: "$%.0fM", value)
        }
    }
    
    private var investButton: some View {
        VStack(spacing: 0) {
            // Gradient fade
            LinearGradient(
                colors: [Color.darkBackground.opacity(0), Color.darkBackground],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 30)
            
            Button(action: {
                showInvestSheet = true
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                    Text("Invest Now")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.successColor, Color.successColor.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
                .shadow(color: Color.successColor.opacity(0.5), radius: 16, y: 8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .background(Color.darkBackground)
        }
    }
}

// MARK: - Invest Sheet
struct InvestSheetView: View {
    let startup: Startup
    @Environment(\.dismiss) private var dismiss
    @State private var investmentAmount: String = ""
    @State private var selectedAmount: Int? = nil
    @State private var showSuccessAlert = false
    @StateObject private var portfolio = PortfolioManager.shared
    
    let quickAmounts = [50, 100, 500, 1000, 5000]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header
                    VStack(alignment: .center, spacing: 12) {
                        Text(startup.logoEmoji)
                            .font(.system(size: 60))
                        Text("Invest in \(startup.name)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                        Text(startup.sector)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.accentPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    
                    // Quick Select Amounts
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Quick Select")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(quickAmounts, id: \.self) { amount in
                                Button(action: {
                                    selectedAmount = amount
                                    investmentAmount = "\(amount)"
                                }) {
                                    Text("$\(amount)")
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundStyle(selectedAmount == amount ? Color.darkBackground : Color.accentPrimary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedAmount == amount ? Color.accentPrimary : Color.darkCard)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                                                )
                                        )
                                }
                            }
                        }
                    }
                    
                    // Custom Amount
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Custom Amount")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                        
                        HStack(spacing: 12) {
                            Text("$")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.textSecondary)
                            TextField("Enter amount", text: $investmentAmount)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundStyle(Color.textPrimary)
                                .keyboardType(.numberPad)
                                .onChange(of: investmentAmount) { oldValue, newValue in
                                    selectedAmount = nil
                                }
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.darkCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                                )
                                .shadow(color: Color.accentPrimary.opacity(0.2), radius: 12, y: 6)
                        )
                    }
                    
                    // Investment Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Investment Details")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.textPrimary)
                        
                        detailRow(label: "Valuation", value: "$\(Int(startup.valuation))M")
                        detailRow(label: "Minimum Investment", value: "$10")
                        detailRow(label: "Your Ownership", value: calculateOwnership())
                        detailRow(label: "Share Price", value: "$12.50")
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.darkCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.accentPrimary.opacity(0.3), lineWidth: 1.5)
                            )
                            .shadow(color: Color.accentPrimary.opacity(0.2), radius: 12, y: 6)
                    )
                    
                    // Disclaimer
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.warningColor)
                            Text("Investment Risk")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.textPrimary)
                        }
                        Text("Investing in startups carries significant risk. Only invest what you can afford to lose. Past performance does not guarantee future results.")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundStyle(Color.textSecondary)
                            .lineSpacing(3)
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.darkCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.warningColor.opacity(0.3), lineWidth: 1.5)
                            )
                    )
                    
                    // Confirm Button
                    Button(action: {
                        // Add investment to portfolio
                        if let amount = Double(investmentAmount), amount >= 10 {
                            portfolio.addInvestment(startup: startup, amount: amount)
                            showSuccessAlert = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                dismiss()
                            }
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .bold))
                            Text("Confirm Investment")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [Color.accentPrimary, Color.accentPrimary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: Color.accentPrimary.opacity(0.3), radius: 10, y: 5)
                    }
                    .disabled(investmentAmount.isEmpty || Int(investmentAmount) ?? 0 < 10)
                    .opacity((investmentAmount.isEmpty || Int(investmentAmount) ?? 0 < 10) ? 0.5 : 1.0)
                }
                .padding(20)
            }
            .background(Color.darkBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
            .overlay(
                Group {
                    if showSuccessAlert {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundStyle(Color.successColor)
                            Text("Investment Confirmed!")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.textPrimary)
                            Text("Added to your portfolio")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.textSecondary)
                        }
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.darkCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.successColor.opacity(0.5), lineWidth: 2)
                                )
                                .shadow(color: Color.successColor.opacity(0.3), radius: 20, y: 10)
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showSuccessAlert)
            )
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
        }
    }
    
    private func calculateOwnership() -> String {
        guard let amount = Double(investmentAmount), amount > 0 else {
            return "0.00%"
        }
        let ownership = (amount / (startup.valuation * 1_000_000)) * 100
        return String(format: "%.4f%%", ownership)
    }
}
