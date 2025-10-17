import Foundation

struct Startup: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let sector: String
    let description: String
    let valuation: Double
    let revenue: Double
    let growthRate: Double
    let fundingStage: String
    let employees: Int
    let website: String?
    let location: String
    let logoEmoji: String
    let mission: String
    let vision5Year: String
    let totalInvestors: Int
    let monthlyGrowthData: [Double]
    let similarityScore: Int
    
    var matchScore: Int {
        return similarityScore
    }
    var momentum: String {
        if growthRate > 300 { return "🚀 Explosive" }
        if growthRate > 200 { return "📈 High Growth" }
        return "📊 Steady"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, sector, description, valuation, revenue
        case growthRate = "growth_rate"
        case fundingStage = "funding_stage"
        case employees, website, location, logoEmoji, mission, vision5Year, totalInvestors
        case monthlyGrowthData, similarityScore
    }

    static let samples: [Startup] = [
        .init(
            id: 1, name: "Sole", sector: "Footwear",
            description: "Custom 3D-printed sneakers designed from your foot scan in 48 hours.",
            valuation: 8.2, revenue: 1.1, growthRate: 385.0, fundingStage: "Series A",
            employees: 42, website: "sole.shoes", location: "Portland, OR", logoEmoji: "👟",
            mission: "Perfect fit for every foot", vision5Year: "1M custom pairs sold",
            totalInvestors: 287,
            monthlyGrowthData: [0.7, 1.0, 1.4, 1.9, 2.6, 3.5],
            similarityScore: 89
        ),
        .init(
            id: 2, name: "Glow", sector: "Beauty",
            description: "AI skin analysis app that creates custom serums delivered monthly.",
            valuation: 6.5, revenue: 0.9, growthRate: 420.0, fundingStage: "Series A",
            employees: 35, website: "glow.beauty", location: "LA, CA", logoEmoji: "✨",
            mission: "Your skin's personal scientist", vision5Year: "10M users worldwide",
            totalInvestors: 198,
            monthlyGrowthData: [0.5, 0.8, 1.2, 1.7, 2.4, 3.3],
            similarityScore: 94
        ),
        .init(
            id: 3, name: "Vibe", sector: "Music Tech",
            description: "Live concert platform bringing artists directly into your living room via hologram.",
            valuation: 12.8, revenue: 1.7, growthRate: 295.0, fundingStage: "Series B",
            employees: 68, website: "vibe.live", location: "Nashville, TN", logoEmoji: "🎵",
            mission: "Front row from your couch", vision5Year: "500 artists streaming",
            totalInvestors: 412,
            monthlyGrowthData: [1.0, 1.4, 1.8, 2.4, 3.1, 4.0],
            similarityScore: 83
        ),
        .init(
            id: 4, name: "Forge", sector: "Manufacturing",
            description: "Desktop metal 3D printer making titanium parts for $5K instead of $500K.",
            valuation: 15.3, revenue: 2.2, growthRate: 245.0, fundingStage: "Series B",
            employees: 78, website: "forge.tech", location: "Detroit, MI", logoEmoji: "🔧",
            mission: "Manufacturing for everyone", vision5Year: "Every shop has one",
            totalInvestors: 467,
            monthlyGrowthData: [1.5, 1.9, 2.4, 3.0, 3.7, 4.6],
            similarityScore: 78
        ),
        .init(
            id: 5, name: "Bloom", sector: "Indoor Farming",
            description: "Countertop garden growing fresh herbs and veggies year-round automatically.",
            valuation: 7.1, revenue: 1.0, growthRate: 355.0, fundingStage: "Series A",
            employees: 45, website: "bloom.farm", location: "Seattle, WA", logoEmoji: "🌱",
            mission: "Farm-fresh in every home", vision5Year: "2M kitchens growing food",
            totalInvestors: 234,
            monthlyGrowthData: [0.6, 0.9, 1.3, 1.8, 2.5, 3.4],
            similarityScore: 91
        ),
        .init(
            id: 6, name: "Dash", sector: "Delivery",
            description: "15-minute grocery delivery using neighborhood micro-warehouses.",
            valuation: 22.5, revenue: 3.4, growthRate: 215.0, fundingStage: "Series C",
            employees: 124, website: "dash.delivery", location: "NYC, NY", logoEmoji: "🛒",
            mission: "Groceries faster than takeout", vision5Year: "50 cities covered",
            totalInvestors: 589,
            monthlyGrowthData: [2.2, 2.7, 3.3, 4.0, 4.9, 5.9],
            similarityScore: 85
        ),
        .init(
            id: 7, name: "Peak", sector: "Fitness",
            description: "AI personal trainer in your AirPods tracking form and coaching in real-time.",
            valuation: 9.7, revenue: 1.3, growthRate: 340.0, fundingStage: "Series A",
            employees: 52, website: "peak.fit", location: "Austin, TX", logoEmoji: "💪",
            mission: "Elite coaching for everyone", vision5Year: "5M active users",
            totalInvestors: 312,
            monthlyGrowthData: [0.8, 1.1, 1.5, 2.1, 2.9, 3.9],
            similarityScore: 88
        ),
        .init(
            id: 8, name: "Brew", sector: "Coffee Tech",
            description: "Smart coffee roaster learning your perfect blend and auto-ordering beans.",
            valuation: 5.8, revenue: 0.8, growthRate: 410.0, fundingStage: "Seed",
            employees: 28, website: "brew.coffee", location: "Portland, OR", logoEmoji: "☕",
            mission: "Cafe-quality at home", vision5Year: "500K smart roasters sold",
            totalInvestors: 167,
            monthlyGrowthData: [0.4, 0.7, 1.1, 1.6, 2.3, 3.2],
            similarityScore: 92
        ),
        .init(
            id: 9, name: "Flux", sector: "Energy Storage",
            description: "Home battery storing solar power for 1/3 the price of competitors.",
            valuation: 18.2, revenue: 2.5, growthRate: 265.0, fundingStage: "Series B",
            employees: 89, website: "flux.energy", location: "San Diego, CA", logoEmoji: "🔋",
            mission: "Store sunshine, use anytime", vision5Year: "1M homes energy independent",
            totalInvestors: 478,
            monthlyGrowthData: [1.6, 2.0, 2.5, 3.1, 3.8, 4.7],
            similarityScore: 80
        ),
        .init(
            id: 10, name: "Pulse", sector: "Health Wearables",
            description: "Ring detecting heart attacks 3 days early and calling 911 automatically.",
            valuation: 14.5, revenue: 2.0, growthRate: 285.0, fundingStage: "Series B",
            employees: 72, website: "pulse.health", location: "Boston, MA", logoEmoji: "💍",
            mission: "Save lives before symptoms", vision5Year: "FDA approved device",
            totalInvestors: 423,
            monthlyGrowthData: [1.3, 1.7, 2.2, 2.8, 3.5, 4.3],
            similarityScore: 86
        ),
        .init(
            id: 11, name: "Drift", sector: "Travel",
            description: "Mystery trips where you pick vibes, we pick destination revealed at airport.",
            valuation: 8.9, revenue: 1.2, growthRate: 365.0, fundingStage: "Series A",
            employees: 48, website: "drift.travel", location: "Miami, FL", logoEmoji: "✈️",
            mission: "Adventure without planning", vision5Year: "100K trips booked",
            totalInvestors: 245,
            monthlyGrowthData: [0.7, 1.0, 1.5, 2.1, 2.9, 4.0],
            similarityScore: 90
        ),
        .init(
            id: 12, name: "Snap", sector: "Photography",
            description: "AI photographer bot following you around events capturing perfect moments.",
            valuation: 6.2, revenue: 0.8, growthRate: 445.0, fundingStage: "Seed",
            employees: 32, website: "snap.photos", location: "LA, CA", logoEmoji: "📸",
            mission: "Never miss a moment", vision5Year: "Every event has Snap",
            totalInvestors: 189,
            monthlyGrowthData: [0.4, 0.6, 1.0, 1.5, 2.2, 3.1],
            similarityScore: 95
        ),
        .init(
            id: 13, name: "Luna", sector: "Sleep Tech",
            description: "Smart mattress pad adjusting temperature and firmness during each sleep cycle.",
            valuation: 11.3, revenue: 1.5, growthRate: 315.0, fundingStage: "Series B",
            employees: 62, website: "luna.sleep", location: "Denver, CO", logoEmoji: "🌙",
            mission: "Perfect sleep every night", vision5Year: "Top hotel partner",
            totalInvestors: 356,
            monthlyGrowthData: [1.0, 1.3, 1.7, 2.2, 2.9, 3.7],
            similarityScore: 87
        ),
        .init(
            id: 14, name: "Nexus", sector: "Co-Working",
            description: "Private office pods in parking lots near your home for remote work.",
            valuation: 9.4, revenue: 1.3, growthRate: 325.0, fundingStage: "Series A",
            employees: 54, website: "nexus.work", location: "SF, CA", logoEmoji: "🏢",
            mission: "Office in your neighborhood", vision5Year: "1000 cities served",
            totalInvestors: 298,
            monthlyGrowthData: [0.8, 1.1, 1.5, 2.0, 2.7, 3.5],
            similarityScore: 82
        ),
        .init(
            id: 15, name: "Bolt", sector: "EV Charging",
            description: "Mobile EV charging van coming to your car like AAA roadside service.",
            valuation: 16.8, revenue: 2.3, growthRate: 275.0, fundingStage: "Series B",
            employees: 95, website: "bolt.charge", location: "Austin, TX", logoEmoji: "⚡",
            mission: "Charge anywhere, anytime", vision5Year: "Every city has Bolt vans",
            totalInvestors: 445,
            monthlyGrowthData: [1.5, 1.9, 2.4, 3.0, 3.7, 4.6],
            similarityScore: 84
        ),
        .init(
            id: 16, name: "Echo", sector: "Voice AI",
            description: "Clone your voice for audiobooks and podcasts while you sleep.",
            valuation: 7.6, revenue: 1.0, growthRate: 390.0, fundingStage: "Series A",
            employees: 41, website: "echo.voice", location: "Seattle, WA", logoEmoji: "🎙️",
            mission: "Your voice everywhere", vision5Year: "1M voice clones",
            totalInvestors: 267,
            monthlyGrowthData: [0.6, 0.9, 1.3, 1.9, 2.7, 3.8],
            similarityScore: 93
        ),
        .init(
            id: 17, name: "Haven", sector: "Pet Care",
            description: "Luxury pet hotels with webcams, spa, and gourmet meals for $50/night.",
            valuation: 12.1, revenue: 1.6, growthRate: 305.0, fundingStage: "Series B",
            employees: 78, website: "haven.pet", location: "Dallas, TX", logoEmoji: "🐾",
            mission: "5-star stays for pets", vision5Year: "100 locations nationwide",
            totalInvestors: 378,
            monthlyGrowthData: [1.0, 1.3, 1.7, 2.3, 3.0, 3.9],
            similarityScore: 88
        ),
        .init(
            id: 18, name: "Spark", sector: "EdTech",
            description: "Kids learn coding by building actual robots that do homework.",
            valuation: 10.5, revenue: 1.4, growthRate: 335.0, fundingStage: "Series A",
            employees: 58, website: "spark.edu", location: "Boston, MA", logoEmoji: "🤖",
            mission: "Make learning addictive", vision5Year: "5K schools using Spark",
            totalInvestors: 312,
            monthlyGrowthData: [0.9, 1.2, 1.6, 2.1, 2.8, 3.7],
            similarityScore: 86
        ),
        .init(
            id: 19, name: "Slice", sector: "Food Tech",
            description: "Ghost kitchen making 5-star restaurant meals for $12 using AI chefs.",
            valuation: 19.2, revenue: 2.7, growthRate: 255.0, fundingStage: "Series C",
            employees: 108, website: "slice.food", location: "Chicago, IL", logoEmoji: "🍕",
            mission: "Michelin quality, fast food price", vision5Year: "50 city launch",
            totalInvestors: 523,
            monthlyGrowthData: [1.8, 2.3, 2.9, 3.6, 4.4, 5.4],
            similarityScore: 81
        ),
        .init(
            id: 20, name: "Vault", sector: "Crypto",
            description: "Family crypto wallet that's as easy as Venmo with built-in inheritance.",
            valuation: 13.7, revenue: 1.8, growthRate: 295.0, fundingStage: "Series B",
            employees: 65, website: "vault.crypto", location: "Miami, FL", logoEmoji: "🔐",
            mission: "Crypto without the confusion", vision5Year: "10M family wallets",
            totalInvestors: 401,
            monthlyGrowthData: [1.2, 1.5, 1.9, 2.5, 3.2, 4.1],
            similarityScore: 79
        )
    ]
}
