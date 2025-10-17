import Foundation

struct Investment: Identifiable, Codable {
    let id: UUID
    let startupId: Int
    let startupName: String
    let startupLogo: String
    let startupSector: String
    let amount: Double
    let shares: Int
    let pricePerShare: Double
    let investmentDate: Date
    var currentValue: Double
    var returnAmount: Double {
        currentValue - amount
    }
    var returnPercentage: Double {
        ((currentValue - amount) / amount) * 100
    }
    
    init(id: UUID = UUID(), startupId: Int, startupName: String, startupLogo: String, startupSector: String, amount: Double, shares: Int, pricePerShare: Double, investmentDate: Date = Date(), currentValue: Double? = nil) {
        self.id = id
        self.startupId = startupId
        self.startupName = startupName
        self.startupLogo = startupLogo
        self.startupSector = startupSector
        self.amount = amount
        self.shares = shares
        self.pricePerShare = pricePerShare
        self.investmentDate = investmentDate
        // Simulate appreciation with random gains between -10% and +50%
        if let cv = currentValue {
            self.currentValue = cv
        } else {
            let randomGain = Double.random(in: -0.1...0.5)
            self.currentValue = amount * (1 + randomGain)
        }
    }
}

class PortfolioManager: ObservableObject {
    static let shared = PortfolioManager()
    
    @Published var investments: [Investment] = []
    
    private let investmentsKey = "userInvestments"
    
    init() {
        loadInvestments()
    }
    
    var totalInvested: Double {
        investments.reduce(0) { $0 + $1.amount }
    }
    
    var totalCurrentValue: Double {
        investments.reduce(0) { $0 + $1.currentValue }
    }
    
    var totalReturn: Double {
        totalCurrentValue - totalInvested
    }
    
    var totalReturnPercentage: Double {
        guard totalInvested > 0 else { return 0 }
        return ((totalCurrentValue - totalInvested) / totalInvested) * 100
    }
    
    func addInvestment(startup: Startup, amount: Double) {
        let pricePerShare = 12.50
        let shares = Int(amount / pricePerShare)
        
        let investment = Investment(
            startupId: startup.id,
            startupName: startup.name,
            startupLogo: startup.logoEmoji,
            startupSector: startup.sector,
            amount: amount,
            shares: shares,
            pricePerShare: pricePerShare
        )
        
        investments.append(investment)
        saveInvestments()
    }
    
    func removeInvestment(_ investment: Investment) {
        investments.removeAll { $0.id == investment.id }
        saveInvestments()
    }
    
    func updateReturns() {
        // Simulate market changes: update all investments with small random changes
        for index in investments.indices {
            let change = Double.random(in: -0.05...0.08) // -5% to +8% change
            investments[index].currentValue *= (1 + change)
        }
        saveInvestments()
    }
    
    private func saveInvestments() {
        if let encoded = try? JSONEncoder().encode(investments) {
            UserDefaults.standard.set(encoded, forKey: investmentsKey)
        }
    }
    
    private func loadInvestments() {
        if let data = UserDefaults.standard.data(forKey: investmentsKey),
           let decoded = try? JSONDecoder().decode([Investment].self, from: data) {
            investments = decoded
        }
    }
}

