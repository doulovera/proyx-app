import Foundation

enum FoodCategory: String, CaseIterable, Codable {
    case pizza
    case sushi
    case sandwich
    case grocery
    case healthy
    case burger
    case bebidas
    case alimentos
    case cocteles
    case promociones
    case all

    var emoji: String {
        switch self {
        case .pizza: return "🍕"
        case .sushi: return "🍣"
        case .sandwich: return "🥪"
        case .grocery: return "🛒"
        case .healthy: return "🥗"
        case .burger: return "🍔"
        case .bebidas: return "🥤"
        case .alimentos: return "🍱"
        case .cocteles: return "🍸"
        case .promociones: return "💫"
        case .all: return "🍽️"
        }
    }
}

enum PriceRange: String, Codable, CaseIterable {
    case budget = "$"
    case moderate = "$$"
    case expensive = "$$$"
    case luxury = "$$$$"
}

struct StoreSummary: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
}

struct Store: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String?
    let category: FoodCategory
    let rating: Double?
    let reviewCount: Int?
    let deliveryTime: String?
    let address: String?
    let phone: String?
    let isOpen: Bool?
    let priceRange: PriceRange?
    let features: [String]?
    let imageURL: String?

    var ratingText: String {
        guard let rating else { return "-" }
        return String(format: "%.1f", rating)
    }

    var statusText: String {
        (isOpen ?? false) ? "Abierto" : "Cerrado"
    }
}
