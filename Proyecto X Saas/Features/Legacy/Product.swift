import Foundation

// MARK: - LegacyProduct Categories
enum LegacyProductCategory: String, CaseIterable, Codable {
    case bebidas = "Bebidas"
    case alimentos = "Alimentos"
    case cocteles = "Cocteles"
    case promociones = "Promociones"
}

// MARK: - LegacyProduct Size Options
enum LegacyProductSize: String, CaseIterable, Codable {
    case small = "Pequeño"
    case medium = "Mediano"
    case large = "Grande"
    case extraLarge = "Extra Grande"
    
    var priceMultiplier: Double {
        switch self {
        case .small: return 0.8
        case .medium: return 1.0
        case .large: return 1.3
        case .extraLarge: return 1.6
        }
    }
}

// MARK: - Legacy Product Price Range
enum LegacyProductPriceRange: String, CaseIterable, Codable {
    case budget = "budget"
    case moderate = "moderate"
    case expensive = "expensive"
}

// MARK: - LegacyStore Data Model
struct LegacyProductStore: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let description: String
    let category: LegacyProductCategory
    let rating: Double
    let reviewCount: Int
    let deliveryTime: String
    let address: String
    let phone: String
    let isOpen: Bool
    let latitude: Double
    let longitude: Double
    let priceRange: LegacyProductPriceRange
    let specialties: [String]
    let features: [String]
    let createdAt: String
    let updatedAt: String?
    
    var statusText: String {
        return isOpen ? "Abierto" : "Cerrado"
    }
    
    var ratingText: String {
        return String(format: "%.1f (%d)", rating, reviewCount)
    }
    
    var priceRangeText: String {
        switch priceRange {
        case .budget: return "€"
        case .moderate: return "€€"
        case .expensive: return "€€€"
        }
    }
}

// MARK: - LegacyProduct Data Model
struct LegacyProduct: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let description: String
    let fullDescription: String
    let category: LegacyProductCategory
    let basePrice: Double
    let originalPrice: Double?
    let rating: Double
    let reviewCount: Int
    let preparationTime: String
    let calories: Int?
    let isOrganic: Bool
    let isVegan: Bool
    let isGlutenFree: Bool
    let isSpicy: Bool
    let isSponsored: Bool
    let isAvailable: Bool
    let stockQuantity: Int?
    let ingredients: [String]
    let allergens: [String]
    let tags: [String]
    let imageName: String?
    let storeId: String
    let createdAt: String
    let updatedAt: String?
    
    var priceText: String {
        return String(format: "€%.2f", basePrice)
    }
    
    var hasDiscount: Bool {
        return originalPrice != nil && originalPrice! > basePrice
    }
    
    var discountPercentage: Int? {
        guard let original = originalPrice, original > basePrice else { return nil }
        return Int(((original - basePrice) / original) * 100)
    }
    
    var dietaryTags: [String] {
        var dietary: [String] = []
        if isVegan { dietary.append("Vegano") }
        if isGlutenFree { dietary.append("Sin Gluten") }
        if isOrganic { dietary.append("Orgánico") }
        if isSpicy { dietary.append("Picante") }
        return dietary
    }
    
    var caloriesText: String? {
        guard let calories = calories else { return nil }
        return "\(calories) cal"
    }
    
}

// MARK: - Legacy LegacyUser Model (kept local to avoid collisions)
struct LegacyUser: Identifiable, Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let phone: String?
    let avatarURL: String?
    let membershipLevel: LegacyMembershipLevel
    let points: Int
    let memberSince: String
    let emailVerified: Bool
    let createdAt: String
    let updatedAt: String?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

enum LegacyMembershipLevel: String, CaseIterable, Codable {
    case silver = "silver"
    case gold = "gold" 
    case platinum = "platinum"
    
    var displayName: String {
        switch self {
        case .silver: return "Silver"
        case .gold: return "Gold"
        case .platinum: return "Platinum"
        }
    }
    
    var color: String {
        switch self {
        case .silver: return "gray"
        case .gold: return "yellow"
        case .platinum: return "purple"
        }
    }
    
    var benefits: [String] {
        switch self {
        case .silver:
            return ["Descuentos del 10%", "Puntos dobles", "Soporte prioritario", "Entrega gratuita"]
        case .gold:
            return ["Descuentos del 15%", "Puntos triples", "Soporte VIP", "Entrega gratuita", "Acceso temprano"]
        case .platinum:
            return ["Descuentos del 20%", "Puntos cuádruples", "Concierge personal", "Entrega gratuita", "Acceso exclusivo", "Eventos VIP"]
        }
    }
}
