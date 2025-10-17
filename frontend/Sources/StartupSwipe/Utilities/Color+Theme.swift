import SwiftUI

extension Color {
    // Dark Theme Colors
    static let darkBackground = Color(red: 0.08, green: 0.08, blue: 0.12) // #141419
    static let darkCard = Color(red: 0.12, green: 0.12, blue: 0.18) // #1E1E2D
    static let darkCardHover = Color(red: 0.16, green: 0.16, blue: 0.22) // #282838
    
    // Accent Colors (Electric Blue/Cyan)
    static let accentPrimary = Color(red: 0.267, green: 0.839, blue: 0.996) // #44D6FE (Electric Cyan)
    static let accentSecondary = Color(red: 0.4, green: 0.5, blue: 1.0) // #6680FF (Electric Blue)
    static let accentGradientStart = Color(red: 0.267, green: 0.839, blue: 0.996)
    static let accentGradientEnd = Color(red: 0.4, green: 0.5, blue: 1.0)
    
    // Text Colors
    static let textPrimary = Color.white
    static let textSecondary = Color(red: 0.7, green: 0.7, blue: 0.75)
    static let textTertiary = Color(red: 0.5, green: 0.5, blue: 0.55)
    
    // Status Colors (Vibrant for dark theme)
    static let successColor = Color(red: 0.0, green: 0.9, blue: 0.5) // Bright Green
    static let errorColor = Color(red: 1.0, green: 0.3, blue: 0.4) // Bright Red
    static let warningColor = Color(red: 1.0, green: 0.7, blue: 0.0) // Bright Orange
    
    // Sector Colors (Enhanced for dark theme)
    static func sectorColor(for sector: String) -> Color {
        switch sector.lowercased() {
        case let s where s.contains("web3") || s.contains("crypto"):
            return Color(red: 0.5, green: 0.8, blue: 1.0) // Bright Blue
        case let s where s.contains("mental") || s.contains("health"):
            return Color(red: 1.0, green: 0.4, blue: 0.6) // Bright Pink
        case let s where s.contains("food") || s.contains("chef"):
            return Color(red: 1.0, green: 0.6, blue: 0.2) // Bright Orange
        case let s where s.contains("space"):
            return Color(red: 0.6, green: 0.4, blue: 1.0) // Purple
        case let s where s.contains("bio") || s.contains("neuro"):
            return Color(red: 0.4, green: 1.0, blue: 0.6) // Bright Green
        case let s where s.contains("fashion") || s.contains("style"):
            return Color(red: 1.0, green: 0.5, blue: 0.8) // Hot Pink
        case let s where s.contains("cyber") || s.contains("security"):
            return Color(red: 1.0, green: 0.3, blue: 0.3) // Bright Red
        case let s where s.contains("agri") || s.contains("ocean"):
            return Color(red: 0.3, green: 0.9, blue: 0.7) // Teal
        case let s where s.contains("remote") || s.contains("virtual"):
            return Color(red: 0.7, green: 0.5, blue: 1.0) // Lavender
        case let s where s.contains("sleep") || s.contains("wellness"):
            return Color(red: 0.5, green: 0.7, blue: 1.0) // Sky Blue
        case let s where s.contains("drone") || s.contains("logistics"):
            return Color(red: 1.0, green: 0.7, blue: 0.3) // Amber
        case let s where s.contains("edu") || s.contains("learning"):
            return Color(red: 0.4, green: 0.8, blue: 1.0) // Blue
        case let s where s.contains("pet"):
            return Color(red: 0.9, green: 0.6, blue: 0.4) // Tan
        case let s where s.contains("climate") || s.contains("clean"):
            return Color(red: 0.4, green: 1.0, blue: 0.5) // Lime
        case let s where s.contains("gaming") || s.contains("game"):
            return Color(red: 0.8, green: 0.4, blue: 1.0) // Purple
        case let s where s.contains("elder") || s.contains("senior"):
            return Color(red: 1.0, green: 0.6, blue: 0.7) // Rose
        case let s where s.contains("farm") || s.contains("vertical"):
            return Color(red: 0.5, green: 1.0, blue: 0.4) // Green
        case let s where s.contains("voice") || s.contains("ai"):
            return Color(red: 0.6, green: 0.8, blue: 1.0) // Light Blue
        case let s where s.contains("legal"):
            return Color(red: 1.0, green: 0.8, blue: 0.4) // Gold
        case let s where s.contains("energy") || s.contains("fusion"):
            return Color(red: 1.0, green: 0.9, blue: 0.3) // Yellow
        default:
            return accentPrimary
        }
    }
}

