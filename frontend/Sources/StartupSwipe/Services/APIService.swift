import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:8000/api"
    
    private init() {}
    
    // MARK: - Startups
    
    func fetchStartups(limit: Int = 10, offset: Int = 0) async throws -> [Startup] {
        let url = URL(string: "\(baseURL)/startups?limit=\(limit)&offset=\(offset)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Startup].self, from: data)
    }
    
    func getStartup(id: Int) async throws -> Startup {
        let url = URL(string: "\(baseURL)/startup/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Startup.self, from: data)
    }
    
    func saveStartup(id: Int) async throws -> Bool {
        var request = URLRequest(url: URL(string: "\(baseURL)/save/\(id)")!)
        request.httpMethod = "POST"
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    func removeSavedStartup(id: Int) async throws -> Bool {
        var request = URLRequest(url: URL(string: "\(baseURL)/save/\(id)")!)
        request.httpMethod = "DELETE"
        let (_, response) = try await URLSession.shared.data(for: request)
        return (response as? HTTPURLResponse)?.statusCode == 200
    }
    
    func getSavedStartups() async throws -> [Startup] {
        let url = URL(string: "\(baseURL)/saved")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Startup].self, from: data)
    }
    
    // MARK: - Analytics
    
    func getAnalytics() async throws -> Analytics {
        let url = URL(string: "\(baseURL)/analytics")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Analytics.self, from: data)
    }
    
    // MARK: - AI
    
    func getAIAnalysis(id: Int) async throws -> AIAnalysis {
        let url = URL(string: "\(baseURL)/ai-analysis/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(AIAnalysis.self, from: data)
    }
    
    func getSimilarStartups(id: Int) async throws -> [SimilarStartup] {
        let url = URL(string: "\(baseURL)/similar/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([SimilarStartup].self, from: data)
    }
}

// MARK: - Models

struct Analytics: Codable {
    let sectorDistribution: [String: Int]
    let avgGrowthBySector: [String: Double]
    let fundingStageCounts: [String: Int]
    let totalSaved: Int
    let totalViewed: Int
    
    enum CodingKeys: String, CodingKey {
        case sectorDistribution = "sector_distribution"
        case avgGrowthBySector = "avg_growth_by_sector"
        case fundingStageCounts = "funding_stage_counts"
        case totalSaved = "total_saved"
        case totalViewed = "total_viewed"
    }
}

struct AIAnalysis: Codable {
    let strengths: [String]
    let risks: [String]
    let marketOpportunity: String
    let recommendation: String
    let confidenceScore: Double
    
    enum CodingKeys: String, CodingKey {
        case strengths
        case risks
        case marketOpportunity = "market_opportunity"
        case recommendation
        case confidenceScore = "confidence_score"
    }
}

struct SimilarStartup: Codable, Identifiable {
    let id: Int
    let name: String
    let sector: String
    let similarityScore: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sector
        case similarityScore = "similarity_score"
    }
}

