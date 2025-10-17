import SwiftUI

@main
struct StartupSwipeApp: App {
    @StateObject private var swipeDeckViewModel = SwipeDeckViewModel()
    @State private var hasCompletedOnboarding = false
    @State private var isCheckingOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isCheckingOnboarding {
                    // Show a simple loading state while checking
                    ZStack {
                        Color(red: 0.95, green: 0.96, blue: 0.98)
                            .ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                    .onAppear {
                        // Check if user has completed onboarding
                        if let data = UserDefaults.standard.data(forKey: "userPreferences"),
                           let prefs = try? JSONDecoder().decode(UserPreferences.self, from: data),
                           prefs.hasCompletedOnboarding {
                            hasCompletedOnboarding = true
                        } else {
                            hasCompletedOnboarding = false
                        }
                        isCheckingOnboarding = false
                    }
                } else if !hasCompletedOnboarding {
                    OnboardingView(showOnboarding: $hasCompletedOnboarding)
                } else {
                    MainTabView()
                        .environmentObject(swipeDeckViewModel)
                }
            }
        }
    }
}
