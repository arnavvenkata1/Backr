import SwiftUI

struct FoundersDetailView: View {
    let startup: Startup
    @Environment(\.dismiss) private var dismiss
    
    // Mock founder data based on sector
    private var founders: [Founder] {
        [
            Founder(
                name: "Sarah Chen",
                role: "CEO & Co-Founder",
                avatar: "👩‍💼",
                bio: "Former VP at Google. 15+ years in \(startup.sector). Stanford MBA.",
                linkedin: "linkedin.com/in/sarahchen",
                previousCompanies: ["Google", "Meta", "Stripe"],
                achievements: ["Forbes 30 Under 30", "TechCrunch Disrupt Winner"]
            ),
            Founder(
                name: "Marcus Johnson",
                role: "CTO & Co-Founder",
                avatar: "👨‍💻",
                bio: "Ex-Tesla engineer. Built infrastructure for 10M+ users. MIT CS.",
                linkedin: "linkedin.com/in/marcusj",
                previousCompanies: ["Tesla", "SpaceX", "AWS"],
                achievements: ["40 Patents", "Tech Leader of the Year"]
            ),
            Founder(
                name: "Priya Patel",
                role: "CPO & Co-Founder",
                avatar: "👩‍🎨",
                bio: "Led product at Airbnb. 12 years product design. UC Berkeley.",
                linkedin: "linkedin.com/in/priyap",
                previousCompanies: ["Airbnb", "Uber", "Figma"],
                achievements: ["Product Design Award", "UX Pioneer"]
            )
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Team Overview
                teamOverviewSection
                
                // Founders
                ForEach(founders) { founder in
                    founderCard(founder)
                }
                
                // Advisory Board
                advisorySection
                
                // Team Culture
                cultureSection
            }
            .padding(20)
        }
        .background(Color.darkBackground)
        .navigationTitle("Team")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var teamOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Leadership Team")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            HStack(spacing: 16) {
                statBox(icon: "person.3.fill", value: "\(startup.employees)", label: "Team Size", color: .accentPrimary)
                statBox(icon: "star.fill", value: "4.8", label: "Rating", color: .warningColor)
                statBox(icon: "chart.bar.fill", value: "15+", label: "Avg Years", color: .accentSecondary)
            }
        }
    }
    
    private func statBox(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
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
    
    private func founderCard(_ founder: Founder) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 16) {
                Text(founder.avatar)
                    .font(.system(size: 48))
                    .frame(width: 70, height: 70)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.accentPrimary.opacity(0.3), Color.accentSecondary.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(founder.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.textPrimary)
                    Text(founder.role)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.accentPrimary)
                    
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "link")
                                .font(.system(size: 10, weight: .semibold))
                            Text(founder.linkedin)
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(Color.textTertiary)
                    }
                }
                Spacer()
            }
            
            // Bio
            Text(founder.bio)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(4)
            
            // Previous Companies
            VStack(alignment: .leading, spacing: 10) {
                Text("Previous Experience")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textTertiary)
                
                HStack(spacing: 8) {
                    ForEach(founder.previousCompanies, id: \.self) { company in
                        Text(company)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.accentPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.accentPrimary.opacity(0.2))
                            )
                    }
                }
            }
            
            // Achievements
            VStack(alignment: .leading, spacing: 10) {
                Text("Achievements")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textTertiary)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(founder.achievements, id: \.self) { achievement in
                        HStack(spacing: 8) {
                            Image(systemName: "trophy.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.warningColor)
                            Text(achievement)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
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
    
    private var advisorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Advisory Board")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            VStack(spacing: 12) {
                advisorRow(name: "Dr. James Wilson", role: "Industry Expert", company: "MIT", avatar: "👨‍🔬")
                advisorRow(name: "Lisa Rodriguez", role: "Finance Advisor", company: "Goldman Sachs", avatar: "👩‍💼")
                advisorRow(name: "Alex Kim", role: "Growth Advisor", company: "Y Combinator", avatar: "👨‍💼")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.accentSecondary.opacity(0.3), lineWidth: 1.5)
                )
                .shadow(color: Color.accentSecondary.opacity(0.2), radius: 12, y: 6)
        )
    }
    
    private func advisorRow(name: String, role: String, company: String, avatar: String) -> some View {
        HStack(spacing: 14) {
            Text(avatar)
                .font(.system(size: 32))
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color.accentSecondary.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                Text(role)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                Text(company)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.accentPrimary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.textTertiary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkBackground.opacity(0.5))
        )
    }
    
    private var cultureSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Team Culture")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
            
            VStack(spacing: 12) {
                cultureItem(icon: "building.2.fill", title: "Hybrid Work", description: "3 days in office, 2 days remote", color: .accentPrimary)
                cultureItem(icon: "gift.fill", title: "Equity Packages", description: "Competitive stock options for all employees", color: .accentSecondary)
                cultureItem(icon: "heart.fill", title: "Health & Wellness", description: "Full health coverage + mental health support", color: .errorColor)
                cultureItem(icon: "graduationcap.fill", title: "Learning Budget", description: "$5K annually for professional development", color: .successColor)
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
    
    private func cultureItem(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.textPrimary)
                Text(description)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

struct Founder: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let avatar: String
    let bio: String
    let linkedin: String
    let previousCompanies: [String]
    let achievements: [String]
}
