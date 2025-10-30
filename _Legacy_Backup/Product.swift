import Foundation

// MARK: - Product Categories
enum ProductCategory: String, CaseIterable, Codable {
    case bebidas = "Bebidas"
    case alimentos = "Alimentos"
    case cocteles = "Cocteles"
    case promociones = "Promociones"
}

// MARK: - Product Size Options
enum ProductSize: String, CaseIterable, Codable {
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

// MARK: - Price Range
enum PriceRange: String, CaseIterable, Codable {
    case budget = "budget"
    case moderate = "moderate" 
    case expensive = "expensive"
}

// MARK: - Store Data Model
struct ProductStore: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let description: String
    let category: ProductCategory
    let rating: Double
    let reviewCount: Int
    let deliveryTime: String
    let address: String
    let phone: String
    let isOpen: Bool
    let latitude: Double
    let longitude: Double
    let priceRange: PriceRange
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

// MARK: - Product Data Model
struct Product: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let description: String
    let fullDescription: String
    let category: ProductCategory
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

// MARK: - User Model for Real Backend Integration
struct User: Identifiable, Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let phone: String?
    let avatarURL: String?
    let membershipLevel: MembershipLevel
    let points: Int
    let memberSince: String
    let emailVerified: Bool
    let createdAt: String
    let updatedAt: String?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

enum MembershipLevel: String, CaseIterable, Codable {
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
