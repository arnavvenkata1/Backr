import Foundation
import SwiftUI

struct StartupCard: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let sector: String
    let summary: String
    let valuation: Double
    let growthRate: Double
    let revenue: Double
    let imageName: String

    static let samples: [StartupCard] = [
        .init(
            name: "LumenFlux",
            sector: "ClimateTech",
            summary: "Modular solar skins that wrap existing buildings in clean energy.",
            valuation: 62,
            growthRate: 48,
            revenue: 12,
            imageName: "card-gradient-1"
        ),
        .init(
            name: "NeuraNest",
            sector: "AI & Health",
            summary: "Adaptive mental health coach matching sentiment and therapy style.",
            valuation: 44,
            growthRate: 62,
            revenue: 9,
            imageName: "card-gradient-2"
        ),
        .init(
            name: "OrbitCart",
            sector: "Retail Infra",
            summary: "Edge-compute checkout pods powering contactless city markets.",
            valuation: 58,
            growthRate: 55,
            revenue: 14,
            imageName: "card-gradient-3"
        )
    ]
}
