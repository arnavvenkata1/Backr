import Foundation

struct UserPreferences: Codable {
    var selectedSectors: [String] = []
    var workField: String = ""
    var investmentStage: [String] = []
    var investmentRange: InvestmentRange = .under100
    var riskTolerance: RiskTolerance = .moderate
    var investmentGoal: String = ""
    var experienceLevel: ExperienceLevel = .beginner
    var preferredLocations: [String] = []
    var hasCompletedOnboarding: Bool = false
    
    enum InvestmentRange: String, Codable, CaseIterable {
        case under100 = "$10 - $100"
        case range100To1k = "$100 - $1,000"
        case range1kTo10k = "$1,000 - $10,000"
        case range10kTo50k = "$10,000 - $50,000"
        case over50k = "Over $50,000"
    }
    
    enum RiskTolerance: String, Codable, CaseIterable {
        case conservative = "Conservative"
        case moderate = "Moderate"
        case aggressive = "Aggressive"
    }
    
    enum ExperienceLevel: String, Codable, CaseIterable {
        case beginner = "First-time Investor"
        case intermediate = "Some Experience"
        case expert = "Experienced Investor"
    }
    
    // Convert to prompt for OpenAI
    func toPromptContext() -> String {
        var context = "User Investment Profile:\n"
        context += "- Interested Sectors: \(selectedSectors.joined(separator: ", "))\n"
        context += "- Work Field: \(workField)\n"
        context += "- Investment Stage Preference: \(investmentStage.joined(separator: ", "))\n"
        context += "- Investment Range: \(investmentRange.rawValue)\n"
        context += "- Risk Tolerance: \(riskTolerance.rawValue)\n"
        context += "- Experience Level: \(experienceLevel.rawValue)\n"
        context += "- Preferred Locations: \(preferredLocations.joined(separator: ", "))\n"
        context += "- Investment Goal: \(investmentGoal)\n"
        return context
    }
}

// Available options for the survey
struct OnboardingOptions {
    static let sectors = [
        "FinTech", "HealthTech", "AI & ML", "GreenTech", "Consumer Tech",
        "Fashion", "Beauty", "Food Tech", "Fitness", "EdTech",
        "Smart Home", "Travel", "Pet Tech", "Gaming", "DevOps",
        "Cybersecurity", "Analytics", "Sustainable Fashion", "Mobility", "Real Estate"
    ]
    
    static let workFields = [
        "Technology", "Finance", "Healthcare", "Education", "Retail",
        "Manufacturing", "Consulting", "Legal", "Marketing", "Other"
    ]
    
    static let fundingStages = [
        "Pre-Seed", "Seed", "Series A", "Series B", "Series C", "Series D+"
    ]
    
    static let locations = [
        "San Francisco, CA", "New York, NY", "Los Angeles, CA", "Austin, TX",
        "Boston, MA", "Seattle, WA", "Chicago, IL", "Miami, FL",
        "Denver, CO", "Remote/Distributed"
    ]
    
    static let investmentGoals = [
        "High Growth Potential", "Steady Returns", "Social Impact",
        "Technology Innovation", "Market Disruption", "Long-term Value"
    ]
}

