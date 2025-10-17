import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var preferences = UserPreferences()
    @Published var currentStep: Int = 0
    
    private let userDefaultsKey = "userPreferences"
    
    let totalSteps = 7
    
    init() {
        loadPreferences()
    }
    
    func savePreferences() {
        if let encoded = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func loadPreferences() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode(UserPreferences.self, from: data) {
            preferences = decoded
        }
    }
    
    func completeOnboarding() {
        preferences.hasCompletedOnboarding = true
        savePreferences()
    }
    
    func nextStep() {
        if currentStep < totalSteps - 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep += 1
            }
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep -= 1
            }
        }
    }
    
    func canProceed() -> Bool {
        switch currentStep {
        case 0: return true // Welcome
        case 1: return !preferences.selectedSectors.isEmpty
        case 2: return !preferences.workField.isEmpty
        case 3: return !preferences.investmentStage.isEmpty
        case 4: return true // Investment range always has default
        case 5: return !preferences.preferredLocations.isEmpty
        case 6: return !preferences.investmentGoal.isEmpty
        default: return false
        }
    }
    
    var progressPercentage: Double {
        Double(currentStep + 1) / Double(totalSteps)
    }
}

