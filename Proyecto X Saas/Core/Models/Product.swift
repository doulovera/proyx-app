import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String?
    let category: FoodCategory
    let basePrice: Double
    let originalPrice: Double?
    let rating: Double?
    let reviewCount: Int?
    let store: StoreSummary?
    let preparationTime: String?
    let calories: Int?
    let isOrganic: Bool?
    let isVegan: Bool?
    let isGlutenFree: Bool?
    let isSpicy: Bool?
    let isSponsored: Bool?
    let isAvailable: Bool?
    let imageURL: String?

    var displayPrice: String {
        if basePrice == 0 {
            return "Gratis"
        }
        return "S/ \(Int(basePrice))"
    }

    var discountPercentage: Int? {
        guard let original = originalPrice, original > basePrice else { return nil }
        return Int(((original - basePrice) / original) * 100)
    }

    var dietaryTags: [String] {
        var tags: [String] = []
        if isOrganic == true { tags.append("Orgánico") }
        if isVegan == true { tags.append("Vegano") }
        if isGlutenFree == true { tags.append("Sin Gluten") }
        if isSpicy == true { tags.append("Picante") }
        return tags
    }
}
