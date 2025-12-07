import Foundation
import Combine

@MainActor
class LegacyProductStoreManager: ObservableObject {
    @Published var products: [LegacyProduct] = []

    var recommendedProducts: [LegacyProduct] {
        Array(products.prefix(5))
    }

    var sponsoredProducts: [LegacyProduct] {
        products.filter { $0.isSponsored }
    }

    init() {
        loadSampleProducts()
    }

    private func loadSampleProducts() {
        // Minimal sample data; reuse categories and a few hard-coded items
        products = [
            LegacyProduct(
                id: UUID().uuidString,
                name: "Cold Brew Premium",
                description: "Café de especialidad infusionado en frío por 18 horas",
                fullDescription: "Notas de chocolate y caramelo, servido con hielo.",
                category: .bebidas,
                basePrice: 4.5,
                originalPrice: 5.5,
                rating: 4.8,
                reviewCount: 132,
                preparationTime: "5-7 min",
                calories: 25,
                isOrganic: true,
                isVegan: true,
                isGlutenFree: true,
                isSpicy: false,
                isSponsored: true,
                isAvailable: true,
                stockQuantity: 42,
                ingredients: ["Café de especialidad", "Agua filtrada"],
                allergens: [],
                tags: ["Frío", "Especialidad", "Verano"],
                imageName: "cup.and.saucer",
                storeId: "legacy-store-1",
                createdAt: ISO8601DateFormatter().string(from: Date()),
                updatedAt: nil
            ),
            LegacyProduct(
                id: UUID().uuidString,
                name: "Pizza Margherita",
                description: "Clásica margherita con mozzarella y albahaca",
                fullDescription: "Masa madre, salsa de tomate San Marzano, mozzarella fior di latte y albahaca fresca.",
                category: .alimentos,
                basePrice: 12.5,
                originalPrice: 14.0,
                rating: 4.7,
                reviewCount: 210,
                preparationTime: "18-22 min",
                calories: 680,
                isOrganic: false,
                isVegan: false,
                isGlutenFree: false,
                isSpicy: false,
                isSponsored: false,
                isAvailable: true,
                stockQuantity: 15,
                ingredients: ["Harina", "Tomate", "Queso", "Albahaca"],
                allergens: ["Gluten", "Lácteos"],
                tags: ["Italiana", "Clásica"],
                imageName: "pizza",
                storeId: "legacy-store-2",
                createdAt: ISO8601DateFormatter().string(from: Date()),
                updatedAt: nil
            ),
            LegacyProduct(
                id: UUID().uuidString,
                name: "Bowl Vegano Protein",
                description: "Quinoa, tofu marinado y vegetales asados",
                fullDescription: "Alto en proteína vegetal, con aderezo de tahini y limón.",
                category: .alimentos,
                basePrice: 10.9,
                originalPrice: nil,
                rating: 4.6,
                reviewCount: 164,
                preparationTime: "12-15 min",
                calories: 520,
                isOrganic: true,
                isVegan: true,
                isGlutenFree: true,
                isSpicy: false,
                isSponsored: false,
                isAvailable: true,
                stockQuantity: 30,
                ingredients: ["Quinoa", "Tofu", "Brócoli", "Zanahoria", "Tahini"],
                allergens: ["Soya", "Sésamo"],
                tags: ["Vegano", "Sin Gluten", "Proteico"],
                imageName: "leaf",
                storeId: "legacy-store-3",
                createdAt: ISO8601DateFormatter().string(from: Date()),
                updatedAt: nil
            )
        ]
    }
}
