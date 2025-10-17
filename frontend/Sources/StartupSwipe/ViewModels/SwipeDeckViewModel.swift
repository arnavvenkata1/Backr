import Foundation
import SwiftUI

@MainActor
final class SwipeDeckViewModel: ObservableObject {
    @Published private(set) var queue: [Startup] = []
    @Published private(set) var saved: [Startup] = []
    @Published private var history: [Startup] = []
    @Published private(set) var dismissed: [Startup] = []
    @Published var skipped: [Startup] = []

    private var isLoading = false
    private var currentOffset = 0
    private var likedSectors: [String: Int] = [:] // Track which sectors user likes
    private var userPreferences: UserPreferences?

    var activeStartup: Startup? {
        queue.first
    }

    func loadInitial() async {
        guard !isLoading, queue.isEmpty else { return }
        isLoading = true
        
        // Load user preferences
        if let data = UserDefaults.standard.data(forKey: "userPreferences"),
           let prefs = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            userPreferences = prefs
        }
        
        // Load mock data
        var startups = Startup.samples
        
        // Sort by user preferences if available
        if let prefs = userPreferences {
            startups = sortByPreferences(startups, preferences: prefs)
            print("📊 SORTED BY PREFERENCES & LEARNING")
        } else {
            startups.shuffle()
            print("🔀 RANDOM ORDER (No preferences yet)")
        }
        
        queue = startups
        
        print("🎯 QUEUE ORDER:")
        for (index, startup) in queue.prefix(5).enumerated() {
            print("\(index + 1). \(startup.name) (\(startup.sector))")
        }
        
        // Then try to load from API (uncomment when backend is ready)
        /*
        do {
            let startups = try await APIService.shared.fetchStartups(limit: 10, offset: 0)
            if !startups.isEmpty {
                queue = startups
                currentOffset = startups.count
            }
        } catch {
            print("Error loading startups: \(error)")
            // Keep using mock data
        }
        */
        
        isLoading = false
    }

    func swipe(_ decision: SwipeDecision) {
        guard let current = queue.first else { return }
        queue.removeFirst()
        history.insert(current, at: 0)

        switch decision {
        case .saved:
            saved.insert(current, at: 0)
            skipped.removeAll { $0.id == current.id }
            
            // Learn from user preferences
            likedSectors[current.sector, default: 0] += 1
            
            // Debug: Show learning in action
            print("✅ SAVED: \(current.name) (\(current.sector))")
            print("📊 Sector Preferences: \(likedSectors)")
            
            Task {
                try? await APIService.shared.saveStartup(id: current.id)
            }
        case .skipped:
            dismissed.insert(current, at: 0)
            skipped.insert(current, at: 0)
            saved.removeAll { $0.id == current.id }
            
            // Reduce score for this sector
            likedSectors[current.sector, default: 0] -= 1
            
            // Debug: Show learning in action
            print("❌ SKIPPED: \(current.name) (\(current.sector))")
            print("📊 Sector Preferences: \(likedSectors)")
        }

        if queue.count < 3 {
            Task { await replenish() }
        }
    }

    func rewindLast() {
        guard let last = history.first else { return }
        history.removeFirst()
        queue.insert(last, at: 0)
        
        // Remove from saved/skipped
        if let savedIndex = saved.firstIndex(where: { $0.id == last.id }) {
            saved.remove(at: savedIndex)
            Task {
                try? await APIService.shared.removeSavedStartup(id: last.id)
            }
        }
        dismissed.removeAll { $0.id == last.id }
        skipped.removeAll { $0.id == last.id }
    }

    func replenish() async {
        guard !isLoading else { return }
        isLoading = true
        
        // Get new startups
        var newStartups = Startup.samples
        
        // Sort by learned preferences if available
        if let prefs = userPreferences {
            newStartups = sortByPreferences(newStartups, preferences: prefs)
            print("🔄 REPLENISHING: Sorted by preferences and learned behavior")
            print("📊 Current sector scores: \(likedSectors)")
        } else {
            newStartups.shuffle()
            print("🔄 REPLENISHING: Random order")
        }
        
        queue.append(contentsOf: newStartups)
        
        // Uncomment when backend is ready
        /*
        do {
            let newStartups = try await APIService.shared.fetchStartups(limit: 10, offset: currentOffset)
            if !newStartups.isEmpty {
                queue.append(contentsOf: newStartups)
                currentOffset += newStartups.count
            } else {
                queue.append(contentsOf: Startup.samples.shuffled())
            }
        } catch {
            print("Error replenishing startups: \(error)")
            queue.append(contentsOf: Startup.samples.shuffled())
        }
        */
        
        isLoading = false
    }

    func reset() {
        Task {
            await loadInitial()
        }
        saved = []
        dismissed = []
        skipped = []
        history = []
        currentOffset = 0
    }

    func removeSaved(at offsets: IndexSet) {
        for index in offsets {
            let startup = saved[index]
            Task {
                try? await APIService.shared.removeSavedStartup(id: startup.id)
            }
        }
        saved.remove(atOffsets: offsets)
    }
    
    // MARK: - Recommendation Logic
    
    private func sortByPreferences(_ startups: [Startup], preferences: UserPreferences) -> [Startup] {
        return startups.sorted { startup1, startup2 in
            let score1 = calculateScore(for: startup1, preferences: preferences)
            let score2 = calculateScore(for: startup2, preferences: preferences)
            return score1 > score2
        }
    }
    
    private func calculateScore(for startup: Startup, preferences: UserPreferences) -> Int {
        var score = 0
        
        // Sector preference (highest weight)
        if preferences.selectedSectors.contains(startup.sector) {
            score += 50
        }
        
        // Learned preferences from swipes
        if let sectorScore = likedSectors[startup.sector] {
            score += sectorScore * 10
        }
        
        // Funding stage preference
        if preferences.investmentStage.contains(startup.fundingStage) {
            score += 30
        }
        
        // Location preference
        for prefLocation in preferences.preferredLocations {
            if startup.location.contains(prefLocation.components(separatedBy: ",").first ?? "") {
                score += 20
                break
            }
        }
        
        // Growth rate based on risk tolerance
        switch preferences.riskTolerance {
        case .aggressive:
            if startup.growthRate > 300 {
                score += 20
            }
        case .moderate:
            if startup.growthRate > 200 && startup.growthRate < 350 {
                score += 20
            }
        case .conservative:
            if startup.growthRate < 250 {
                score += 20
            }
        }
        
        return score
    }
}

enum SwipeDecision {
    case saved
    case skipped
}
