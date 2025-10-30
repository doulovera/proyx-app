import SwiftUI
import Foundation

// MARK: - User Authentication Models
struct User: Identifiable, Codable {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let membershipLevel: MembershipLevel
    let points: Int
    let memberSince: String
    let profileImage: String?
    
    var name: String {
        let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
        return fullName.isEmpty ? email : fullName
    }
    
    var joinDate: String {
        memberSince
    }
    
    var membershipDescription: String {
        membershipLevel.rawValue.capitalized
    }
    
    var membershipProgress: Double {
        switch membershipLevel {
        case .bronze: return 0.25
        case .silver: return 0.50
        case .gold: return 0.75
        case .platinum: return 1.0
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName
        case lastName
        case membershipLevel
        case points
        case memberSince
        case profileImage
        case name
        case joinDate
    }
    
    init(id: UUID,
         email: String,
         firstName: String,
         lastName: String,
         membershipLevel: MembershipLevel,
         points: Int,
         memberSince: String,
         profileImage: String? = nil) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.membershipLevel = membershipLevel
        self.points = points
        self.memberSince = memberSince
        self.profileImage = profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        membershipLevel = try container.decodeIfPresent(MembershipLevel.self, forKey: .membershipLevel) ?? .bronze
        points = try container.decodeIfPresent(Int.self, forKey: .points) ?? 0
        memberSince = try container.decodeIfPresent(String.self, forKey: .memberSince)
            ?? (try container.decodeIfPresent(String.self, forKey: .joinDate) ?? "")
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        
        let legacyName = try container.decodeIfPresent(String.self, forKey: .name)
        let nameComponents: [String]
        if let legacyName, !legacyName.isEmpty {
            nameComponents = legacyName
                .split(separator: " ", maxSplits: 1)
                .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        } else {
            nameComponents = []
        }
        let decodedFirstName = try container.decodeIfPresent(String.self, forKey: .firstName)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let decodedLastName = try container.decodeIfPresent(String.self, forKey: .lastName)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        firstName = decodedFirstName ?? nameComponents.first ?? legacyName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        lastName = decodedLastName ?? (nameComponents.count > 1 ? nameComponents[1] : "")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(membershipLevel, forKey: .membershipLevel)
        try container.encode(points, forKey: .points)
        try container.encode(memberSince, forKey: .memberSince)
        try container.encodeIfPresent(profileImage, forKey: .profileImage)
    }
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let confirmPassword: String
    let firstName: String
    let lastName: String
    let phone: String?
    
    init(email: String, password: String, confirmPassword: String, firstName: String, lastName: String, phone: String? = nil) {
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}

struct AuthResponse: Codable {
    let user: User
    let token: String
}

// For backwards compatibility with NetworkManager
typealias LoginResponse = AuthResponse

// MARK: - Backend Store Models
struct BackendStore: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let category: BackendFoodCategory
    let address: String
    let latitude: Double
    let longitude: Double
    let phone: String?
    let email: String?
    let website: String?
    let rating: Double
    let reviewCount: Int
    let priceRange: PriceRange
    let isOpen: Bool
    let deliveryTime: String
    let deliveryFee: Double
    let minimumOrder: Double
    let tags: [String]
    let imageURL: String?
    
    var formattedRating: String {
        String(format: "%.1f", rating)
    }
    
    var priceSymbols: String {
        String(repeating: "€", count: priceRange.symbolCount)
    }
    
    var distanceText: String {
        // Mock distance calculation - in real app would use user location
        String(format: "%.1f km", Double.random(in: 0.5...5.0))
    }
}

// MARK: - Backend Product Models
struct BackendProduct: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let category: BackendFoodCategory
    let storeID: UUID
    let storeName: String
    let imageURL: String?
    let isAvailable: Bool
    let preparationTime: String
    let allergens: [String]
    let nutritionalInfo: NutritionalInfo?
    let tags: [String]
    let customizations: [String]
    let rating: Double?
    let reviewCount: Int
    
    var formattedPrice: String {
        String(format: "€%.2f", price)
    }
    
    var isVegan: Bool {
        tags.contains("Vegano") || tags.contains("Vegan")
    }
    
    var isGlutenFree: Bool {
        tags.contains("Sin Gluten") || tags.contains("Gluten Free")
    }
    
    var isOrganic: Bool {
        tags.contains("Orgánico") || tags.contains("Organic")
    }
}

struct NutritionalInfo: Codable {
    let calories: Int
    let protein: Double
    let carbs: Double
    let fat: Double
    let fiber: Double?
    let sugar: Double?
}

// MARK: - Backend Event Models
struct BackendEvent: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: BackendEventCategory
    let storeID: UUID?
    let storeName: String?
    let organizerName: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let location: String
    let address: String
    let price: Double
    let maxAttendees: Int
    let currentAttendees: Int
    let imageURL: String?
    let tags: [String]
    let requirements: [String]
    let includes: [String]
    
    var formattedPrice: String {
        price == 0 ? "Gratis" : String(format: "€%.2f", price)
    }
    
    var availableSpots: Int {
        maxAttendees - currentAttendees
    }
    
    var isAvailable: Bool {
        availableSpots > 0
    }
    
    var occupancyPercentage: Double {
        guard maxAttendees > 0 else { return 0 }
        return Double(currentAttendees) / Double(maxAttendees)
    }
    
    var formattedDate: String {
        // Format: "15 Nov 2024"
        if let date = parseDate(startDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            formatter.locale = Locale(identifier: "es_ES")
            return formatter.string(from: date)
        }
        return startDate
    }
    
    var formattedTimeRange: String {
        "\(startTime) - \(endTime)"
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}

// MARK: - Enums
enum MembershipLevel: String, Codable, CaseIterable {
    case bronze = "bronze"
    case silver = "silver"
    case gold = "gold"
    case platinum = "platinum"
    
    var color: Color {
        switch self {
        case .bronze: return .brown
        case .silver: return .gray
        case .gold: return .yellow
        case .platinum: return .purple
        }
    }
    
    var benefits: [String] {
        switch self {
        case .bronze:
            return ["5% descuento", "Envío gratis > €25"]
        case .silver:
            return ["10% descuento", "Envío gratis > €20", "Soporte prioritario"]
        case .gold:
            return ["15% descuento", "Envío gratis > €15", "Eventos exclusivos", "Devoluciones extendidas"]
        case .platinum:
            return ["20% descuento", "Envío gratis", "Eventos VIP", "Concierge personal", "Acceso anticipado"]
        }
    }
}

enum BackendFoodCategory: String, Codable, CaseIterable {
    case pizza = "pizza"
    case sushi = "sushi"
    case hamburguesa = "hamburguesa"
    case saludable = "saludable"
    case gourmet = "gourmet"
    case bebidas = "bebidas"
    case postre = "postre"
    case all = "todos"
    
    var displayName: String {
        switch self {
        case .pizza: return "Pizza"
        case .sushi: return "Sushi"
        case .hamburguesa: return "Hamburguesas"
        case .saludable: return "Saludable"
        case .gourmet: return "Gourmet"
        case .bebidas: return "Bebidas"
        case .postre: return "Postres"
        case .all: return "Todos"
        }
    }
    
    var icon: String {
        switch self {
        case .pizza: return "🍕"
        case .sushi: return "🍣"
        case .hamburguesa: return "🍔"
        case .saludable: return "🥗"
        case .gourmet: return "🍽️"
        case .bebidas: return "🥤"
        case .postre: return "🧁"
        case .all: return "📱"
        }
    }
    
    var themeColor: Color {
        switch self {
        case .pizza: return .red
        case .sushi: return .orange
        case .hamburguesa: return .brown
        case .saludable: return .green
        case .gourmet: return .purple
        case .bebidas: return .blue
        case .postre: return .pink
        case .all: return AppTheme.Colors.brandPrimary
        }
    }
}

enum BackendEventCategory: String, Codable, CaseIterable {
    case gastronomico = "gastronomico"
    case bebidas = "bebidas"
    case educativo = "educativo"
    
    var displayName: String {
        switch self {
        case .gastronomico: return "Gastronómico"
        case .bebidas: return "Bebidas"
        case .educativo: return "Educativo"
        }
    }
    
    var icon: String {
        switch self {
        case .gastronomico: return "👨‍🍳"
        case .bebidas: return "🍹"
        case .educativo: return "📚"
        }
    }
    
    var themeColor: Color {
        switch self {
        case .gastronomico: return .orange
        case .bebidas: return .blue
        case .educativo: return .green
        }
    }
}

enum PriceRange: String, Codable, CaseIterable {
    case budget = "budget"          // €
    case moderate = "moderate"      // €€
    case expensive = "expensive"    // €€€
    case luxury = "luxury"          // €€€€
    
    var displayName: String {
        switch self {
        case .budget: return "Económico"
        case .moderate: return "Moderado"
        case .expensive: return "Caro"
        case .luxury: return "Lujo"
        }
    }
    
    var symbolCount: Int {
        switch self {
        case .budget: return 1
        case .moderate: return 2
        case .expensive: return 3
        case .luxury: return 4
        }
    }
    
    var priceRange: String {
        switch self {
        case .budget: return "€5-15"
        case .moderate: return "€15-30"
        case .expensive: return "€30-50"
        case .luxury: return "€50+"
        }
    }
}

// MARK: - API Response Models
struct StoresResponse: Codable {
    let stores: [BackendStore]
    let total: Int
    let page: Int
    let limit: Int
}

struct ProductsResponse: Codable {
    let products: [BackendProduct]
    let total: Int
    let page: Int
    let limit: Int
}

struct EventsResponse: Codable {
    let events: [BackendEvent]
    let total: Int
    let page: Int
    let limit: Int
}

// MARK: - Search and Filter Models
struct SearchFilters: Codable {
    let query: String?
    let category: String?
    let priceRange: PriceRange?
    let isVegan: Bool?
    let isGlutenFree: Bool?
    let isOrganic: Bool?
    let rating: Double?
    let deliveryTime: String?
    let latitude: Double?
    let longitude: Double?
    let radius: Double?
}

// MARK: - Legacy Food Category (for AppTheme compatibility)
enum FoodCategory: String, CaseIterable {
    case pizza = "Pizza"
    case sushi = "Sushi"
    case sandwich = "Sandwich"
    case grocery = "Grocery"
    case healthy = "Healthy"
    case burger = "Burger"
    case all = "Todos"
    
    var emoji: String {
        switch self {
        case .pizza: return "🍕"
        case .sushi: return "🍣"
        case .sandwich: return "🥪"
        case .grocery: return "🛒"
        case .healthy: return "🥗"
        case .burger: return "🍔"
        case .all: return "🍽️"
        }
    }
}

// MARK: - Sample Data for Development
struct SampleBackendData {
    static let sampleStores: [BackendStore] = [
        BackendStore(
            id: UUID(),
            name: "Pizzería Roma",
            description: "Auténtica pizza italiana en el corazón de Madrid",
            category: .pizza,
            address: "Calle Gran Vía 45, Madrid",
            latitude: 40.4197,
            longitude: -3.7039,
            phone: "+34 91 123 4567",
            email: "hola@pizzeriaroma.es",
            website: "www.pizzeriaroma.es",
            rating: 4.7,
            reviewCount: 342,
            priceRange: .moderate,
            isOpen: true,
            deliveryTime: "25-35 min",
            deliveryFee: 2.50,
            minimumOrder: 15.00,
            tags: ["Italiana", "Familiar", "Vegetariano"],
            imageURL: nil
        ),
        BackendStore(
            id: UUID(),
            name: "Sushi Zen",
            description: "Sushi fresco preparado por chef japonés",
            category: .sushi,
            address: "Calle Serrano 123, Madrid",
            latitude: 40.4251,
            longitude: -3.6897,
            phone: "+34 91 234 5678",
            email: "info@sushizen.es",
            website: "www.sushizen.es",
            rating: 4.9,
            reviewCount: 267,
            priceRange: .expensive,
            isOpen: true,
            deliveryTime: "30-40 min",
            deliveryFee: 3.00,
            minimumOrder: 25.00,
            tags: ["Japonés", "Sin Gluten", "Premium"],
            imageURL: nil
        ),
        BackendStore(
            id: UUID(),
            name: "Burger Station",
            description: "Las mejores hamburguesas artesanales de Madrid",
            category: .hamburguesa,
            address: "Plaza Mayor 8, Madrid",
            latitude: 40.4155,
            longitude: -3.7074,
            phone: "+34 91 345 6789",
            email: "pedidos@burgerstation.es",
            website: nil,
            rating: 4.5,
            reviewCount: 189,
            priceRange: .moderate,
            isOpen: true,
            deliveryTime: "20-30 min",
            deliveryFee: 2.00,
            minimumOrder: 12.00,
            tags: ["Artesanal", "Carne Premium", "Vegano"],
            imageURL: nil
        ),
        BackendStore(
            id: UUID(),
            name: "Healthy Corner",
            description: "Comida sana y nutritiva para tu bienestar",
            category: .saludable,
            address: "Calle Alcalá 200, Madrid",
            latitude: 40.4267,
            longitude: -3.6778,
            phone: "+34 91 456 7890",
            email: "healthy@corner.es",
            website: "www.healthycorner.es",
            rating: 4.6,
            reviewCount: 156,
            priceRange: .moderate,
            isOpen: false,
            deliveryTime: "15-25 min",
            deliveryFee: 1.50,
            minimumOrder: 10.00,
            tags: ["Vegano", "Sin Gluten", "Orgánico", "Bajo en calorías"],
            imageURL: nil
        ),
        BackendStore(
            id: UUID(),
            name: "Mercado Gourmet",
            description: "Productos gourmet y delicatessen selectos",
            category: .gourmet,
            address: "Calle Fuencarral 78, Madrid",
            latitude: 40.4254,
            longitude: -3.7044,
            phone: "+34 91 567 8901",
            email: "gourmet@mercado.es",
            website: "www.mercadogourmet.es",
            rating: 4.4,
            reviewCount: 98,
            priceRange: .luxury,
            isOpen: true,
            deliveryTime: "45-60 min",
            deliveryFee: 5.00,
            minimumOrder: 50.00,
            tags: ["Premium", "Importado", "Artesanal"],
            imageURL: nil
        )
    ]
    
    static let sampleEvents: [BackendEvent] = [
        BackendEvent(
            id: UUID(),
            title: "Masterclass de Sushi con Chef Hiroshi",
            description: "Aprende los secretos del sushi tradicional japonés con el Chef Hiroshi, directamente desde Tokio.",
            category: .gastronomico,
            storeID: UUID(),
            storeName: "Sushi Zen",
            organizerName: "Chef Hiroshi Tanaka",
            startDate: "2025-08-25",
            endDate: "2025-08-25",
            startTime: "19:00",
            endTime: "21:30",
            location: "Sushi Zen",
            address: "Calle Serrano 123, Madrid",
            price: 60.00,
            maxAttendees: 12,
            currentAttendees: 8,
            imageURL: nil,
            tags: ["Japonés", "Masterclass", "Premium"],
            requirements: ["Nivel básico de cocina", "Edad mínima 16 años"],
            includes: ["Ingredientes", "Herramientas", "Certificado", "Cena incluida"]
        ),
        BackendEvent(
            id: UUID(),
            title: "Taller de Cocina Italiana",
            description: "Descubre los secretos de la auténtica cocina italiana con pasta fresca y salsas tradicionales.",
            category: .gastronomico,
            storeID: UUID(),
            storeName: "Pizzería Roma",
            organizerName: "Chef Marco Rossi",
            startDate: "2025-08-28",
            endDate: "2025-08-28",
            startTime: "18:00",
            endTime: "20:00",
            location: "Pizzería Roma",
            address: "Calle Gran Vía 45, Madrid",
            price: 35.00,
            maxAttendees: 16,
            currentAttendees: 12,
            imageURL: nil,
            tags: ["Italiana", "Pasta", "Familiar"],
            requirements: ["Sin experiencia necesaria"],
            includes: ["Ingredientes", "Recetas", "Degustación"]
        ),
        BackendEvent(
            id: UUID(),
            title: "Festival de Cócteles de Autor",
            description: "Una noche única con los mejores bartenders de Madrid creando cócteles exclusivos.",
            category: .bebidas,
            storeID: nil,
            storeName: nil,
            organizerName: "Asociación Bartenders Madrid",
            startDate: "2025-09-05",
            endDate: "2025-09-05",
            startTime: "20:00",
            endTime: "02:00",
            location: "Sky Bar Rooftop",
            address: "Plaza de España 1, Madrid",
            price: 25.00,
            maxAttendees: 80,
            currentAttendees: 45,
            imageURL: nil,
            tags: ["Cócteles", "Nocturno", "Premium"],
            requirements: ["Edad mínima 18 años", "Identificación requerida"],
            includes: ["3 cócteles", "Aperitivos", "Música en vivo"]
        ),
        BackendEvent(
            id: UUID(),
            title: "Curso de Repostería Francesa",
            description: "Aprende las técnicas clásicas de la repostería francesa: macarons, éclairs y tartas.",
            category: .educativo,
            storeID: nil,
            storeName: nil,
            organizerName: "Chef Marie Dubois",
            startDate: "2025-09-10",
            endDate: "2025-09-10",
            startTime: "16:00",
            endTime: "19:00",
            location: "Escuela de Cocina Madrid",
            address: "Calle Hermosilla 88, Madrid",
            price: 50.00,
            maxAttendees: 10,
            currentAttendees: 7,
            imageURL: nil,
            tags: ["Repostería", "Francesa", "Técnicas avanzadas"],
            requirements: ["Experiencia básica en repostería", "Traer delantal"],
            includes: ["Ingredientes premium", "Moldes profesionales", "Recetario", "Certificado"]
        ),
        BackendEvent(
            id: UUID(),
            title: "Cata de Vinos de La Rioja",
            description: "Descubre los mejores vinos de La Rioja con sommelier experto y maridajes gourmet.",
            category: .bebidas,
            storeID: UUID(),
            storeName: "Mercado Gourmet",
            organizerName: "Sommelier Ana García",
            startDate: "2025-09-15",
            endDate: "2025-09-15",
            startTime: "19:30",
            endTime: "21:30",
            location: "Mercado Gourmet",
            address: "Calle Fuencarral 78, Madrid",
            price: 45.00,
            maxAttendees: 15,
            currentAttendees: 11,
            imageURL: nil,
            tags: ["Vinos", "Rioja", "Cata"],
            requirements: ["Edad mínima 18 años"],
            includes: ["6 vinos premium", "Maridajes gourmet", "Material informativo", "Certificado de participación"]
        )
    ]
    
    static let sampleProducts: [BackendProduct] = [
        BackendProduct(
            id: UUID(),
            name: "Pizza Margherita",
            description: "Pizza clásica con tomate, mozzarella fresca y albahaca",
            price: 12.50,
            category: .pizza,
            storeID: UUID(),
            storeName: "Pizzería Roma",
            imageURL: nil,
            isAvailable: true,
            preparationTime: "15-20 min",
            allergens: ["Gluten", "Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 680, protein: 28.5, carbs: 85.2, fat: 24.1, fiber: 4.2, sugar: 6.8),
            tags: ["Vegetariano", "Clásica"],
            customizations: ["Masa fina", "Masa integral", "Extra queso", "Sin cebolla"],
            rating: 4.8,
            reviewCount: 156
        ),
        BackendProduct(
            id: UUID(),
            name: "Sashimi de Salmón Premium",
            description: "Salmón noruego fresco cortado por chef japonés",
            price: 18.90,
            category: .sushi,
            storeID: UUID(),
            storeName: "Sushi Zen",
            imageURL: nil,
            isAvailable: true,
            preparationTime: "10 min",
            allergens: ["Pescado"],
            nutritionalInfo: NutritionalInfo(calories: 230, protein: 45.2, carbs: 0.0, fat: 8.7, fiber: 0.0, sugar: 0.0),
            tags: ["Sin Gluten", "Premium", "Japonés"],
            customizations: ["Con wasabi", "Sin jengibre", "Corte grueso"],
            rating: 4.9,
            reviewCount: 89
        ),
        BackendProduct(
            id: UUID(),
            name: "Hamburguesa Angus Classic",
            description: "Carne Angus 200g, queso cheddar, lechuga, tomate, cebolla",
            price: 14.90,
            category: .hamburguesa,
            storeID: UUID(),
            storeName: "Burger Station",
            imageURL: nil,
            isAvailable: true,
            preparationTime: "12-18 min",
            allergens: ["Gluten", "Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 750, protein: 42.1, carbs: 45.6, fat: 38.2, fiber: 3.8, sugar: 8.1),
            tags: ["Carne Premium", "Artesanal"],
            customizations: ["Sin cebolla", "Extra bacon", "Pan integral", "Sin queso"],
            rating: 4.6,
            reviewCount: 234
        ),
        BackendProduct(
            id: UUID(),
            name: "Buddha Bowl Energía",
            description: "Quinoa, aguacate, tofu, verduras de temporada, salsa tahini",
            price: 11.50,
            category: .saludable,
            storeID: UUID(),
            storeName: "Healthy Corner",
            imageURL: nil,
            isAvailable: true,
            preparationTime: "8-12 min",
            allergens: ["Sésamo", "Soja"],
            nutritionalInfo: NutritionalInfo(calories: 485, protein: 18.7, carbs: 52.3, fat: 22.8, fiber: 12.4, sugar: 8.9),
            tags: ["Vegano", "Sin Gluten", "Orgánico", "Proteína vegetal"],
            customizations: ["Sin aguacate", "Extra tofu", "Salsa aparte", "Sin frutos secos"],
            rating: 4.7,
            reviewCount: 167
        ),
        BackendProduct(
            id: UUID(),
            name: "Jamón Ibérico de Bellota 100g",
            description: "Jamón ibérico de bellota 36 meses de curación, cortado a mano",
            price: 65.00,
            category: .gourmet,
            storeID: UUID(),
            storeName: "Mercado Gourmet",
            imageURL: nil,
            isAvailable: true,
            preparationTime: "5 min",
            allergens: [],
            nutritionalInfo: NutritionalInfo(calories: 375, protein: 43.2, carbs: 0.0, fat: 22.1, fiber: 0.0, sugar: 0.0),
            tags: ["Premium", "Artesanal", "D.O. Guijuelo", "36 meses"],
            customizations: ["Loncheado fino", "Loncheado grueso", "Con pan tostado"],
            rating: 5.0,
            reviewCount: 43
        )
    ]
    
    static let sampleUser = User(
        id: UUID(),
        email: "admin@proyectox.com",
        firstName: "Admin",
        lastName: "Usuario",
        membershipLevel: .platinum,
        points: 2500,
        memberSince: "2024-01-15",
        profileImage: nil
    )
}

// MARK: - Legacy Compatibility Models (from Legacy folder)
// These types are needed by Backend views until full migration is complete

// MARK: - Event Models
struct Event: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let description: String
    let fullDescription: String
    let date: String // ISO8601 string from API
    let time: String
    let duration: String
    let location: String
    let address: String
    let category: EventCategory
    let price: Double
    let capacity: Int
    let availableTickets: Int
    let organizer: String
    let isSponsored: Bool
    let requirements: [String]
    let includes: [String]
    let tags: [String]
    let imageName: String?
    let createdAt: String
    let updatedAt: String?
    
    // Computed properties for UI
    var parsedDate: Date {
        return ISO8601DateFormatter().date(from: date) ?? Date()
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(parsedDate)
    }
    
    var isThisWeek: Bool {
        let calendar = Calendar.current
        return calendar.isDate(parsedDate, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    var isFree: Bool {
        return price == 0
    }
    
    var priceText: String {
        return isFree ? "Gratis" : "$\(Int(price))"
    }
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: parsedDate)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: parsedDate).capitalized
    }
}

enum EventCategory: String, CaseIterable, Codable {
    case gastronomico = "Gastronómico"
    case bebidas = "Bebidas"
    case educativo = "Educativo"
    case cultural = "Cultural"
    case networking = "Networking"
    case entretenimiento = "Entretenimiento"
    
    var icon: String {
        switch self {
        case .gastronomico:
            return "fork.knife"
        case .bebidas:
            return "cup.and.saucer"
        case .educativo:
            return "book"
        case .cultural:
            return "theatermasks"
        case .networking:
            return "person.3"
        case .entretenimiento:
            return "music.note"
        }
    }
    
    var color: String {
        switch self {
        case .gastronomico:
            return "orange"
        case .bebidas:
            return "brown"
        case .educativo:
            return "blue"
        case .cultural:
            return "purple"
        case .networking:
            return "green"
        case .entretenimiento:
            return "pink"
        }
    }
}

// MARK: - Product Models
enum ProductCategory: String, CaseIterable, Codable {
    case bebidas = "Bebidas"
    case alimentos = "Alimentos"
    case cocteles = "Cocteles"
    case promociones = "Promociones"
    
    var icon: String {
        switch self {
        case .bebidas:
            return "cup.and.saucer.fill"
        case .alimentos:
            return "fork.knife"
        case .cocteles:
            return "wineglass.fill"
        case .promociones:
            return "tag.fill"
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
}

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
        case .luxury: return "€€€€"
        }
    }
}

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
