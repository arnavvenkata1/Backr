import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "flame.fill")
                }
                .tag(0)

            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "heart.fill")
                }
                .tag(1)
            
            PortfolioView()
                .tabItem {
                    Label("Portfolio", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)
        }
        .accentColor(Color.accentPrimary)
        .onAppear {
            // Dark theme tab bar styling
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.18, alpha: 1.0) // Dark card color
            
            // Add subtle top border
            appearance.shadowColor = UIColor(red: 0.267, green: 0.839, blue: 0.996, alpha: 0.2)
            appearance.shadowImage = UIImage()
            
            // Unselected item appearance
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.5, green: 0.5, blue: 0.55, alpha: 1.0)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.55, alpha: 1.0)
            ]

            // Selected item appearance (Electric Cyan)
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.267, green: 0.839, blue: 0.996, alpha: 1.0)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(red: 0.267, green: 0.839, blue: 0.996, alpha: 1.0)
            ]

            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}
