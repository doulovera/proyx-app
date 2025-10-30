import Foundation

// MARK: - Food Category Model
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

// MARK: - Promotion Model
struct Promotion: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let discount: String
    let description: String
    let storeName: String
    let category: FoodCategory
    let originalPrice: Double
    let discountedPrice: Double
    let validUntil: Date
    let isExclusive: Bool
    let minOrder: Double?
    let terms: [String]
    let imageName: String
    
    var discountPercentage: Int {
        return Int(((originalPrice - discountedPrice) / originalPrice) * 100)
    }
    
    var isValid: Bool {
        return Date() <= validUntil
    }
    
    var validUntilText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: validUntil)
    }
}

// MARK: - Store Model
struct Store: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let category: FoodCategory
    let rating: Double
    let deliveryTime: String
    let address: String
    let phone: String
    let isOpen: Bool
    let specialties: [String]
    let priceRange: PriceRange
    let features: [String]
    let imageName: String
    let backgroundColor: String
    
    var ratingText: String {
        return String(format: "%.1f", rating)
    }
    
    var statusText: String {
        return isOpen ? "Abierto" : "Cerrado"
    }
}

enum PriceRange: String, CaseIterable {
    case budget = "$"
    case moderate = "$$"
    case expensive = "$$$"
    case luxury = "$$$$"
}

// MARK: - Data Store
class PromotionStoreData: ObservableObject {
    @Published var promotions: [Promotion] = []
    @Published var stores: [Store] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        let calendar = Calendar.current
        let today = Date()
        
        // Sample Promotions
        promotions = [
            Promotion(
                title: "2x1 en Pizzas Familiares",
                discount: "50% OFF",
                description: "Lleva 2 pizzas familiares al precio de 1. Válido para todas las variedades.",
                storeName: "Pizza Palace",
                category: .pizza,
                originalPrice: 60.0,
                discountedPrice: 30.0,
                validUntil: calendar.date(byAdding: .day, value: 7, to: today) ?? today,
                isExclusive: true,
                minOrder: 30.0,
                terms: ["Válido solo para pizzas familiares", "No acumulable con otras ofertas", "Válido hasta agotar stock"],
                imageName: "pizza"
            ),
            
            Promotion(
                title: "Combo Sushi Premium",
                discount: "30% OFF",
                description: "Descuento especial en nuestro combo premium de 40 piezas de sushi.",
                storeName: "Sakura Sushi",
                category: .sushi,
                originalPrice: 120.0,
                discountedPrice: 84.0,
                validUntil: calendar.date(byAdding: .day, value: 3, to: today) ?? today,
                isExclusive: false,
                minOrder: 80.0,
                terms: ["Solo para combo premium", "Incluye wasabi y salsa de soya", "Preparación en 25 minutos"],
                imageName: "sushi"
            ),
            
            Promotion(
                title: "Happy Hour Burgers",
                discount: "25% OFF",
                description: "Todas las hamburgers gourmet con 25% de descuento de 3-6 PM.",
                storeName: "Burger Station",
                category: .burger,
                originalPrice: 40.0,
                discountedPrice: 30.0,
                validUntil: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                isExclusive: true,
                minOrder: nil,
                terms: ["Válido de 3:00 PM a 6:00 PM", "Solo hamburgers gourmet", "No válido en combos"],
                imageName: "burger"
            ),
            
            Promotion(
                title: "Sandwich + Bebida",
                discount: "Gratis",
                description: "Bebida gratis con la compra de cualquier sandwich artesanal.",
                storeName: "Deli Corner",
                category: .sandwich,
                originalPrice: 25.0,
                discountedPrice: 25.0,
                validUntil: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
                isExclusive: false,
                minOrder: 20.0,
                terms: ["Bebida de hasta $8", "Solo sandwiches artesanales", "Una bebida por sandwich"],
                imageName: "sandwich"
            ),
            
            Promotion(
                title: "Bowl Saludable del Día",
                discount: "20% OFF",
                description: "Descuento especial en nuestros bowls saludables con quinoa y vegetales frescos.",
                storeName: "Green Life",
                category: .healthy,
                originalPrice: 35.0,
                discountedPrice: 28.0,
                validUntil: calendar.date(byAdding: .day, value: 2, to: today) ?? today,
                isExclusive: true,
                minOrder: nil,
                terms: ["Solo bowls saludables", "Ingredientes orgánicos", "Opción vegana disponible"],
                imageName: "healthy"
            ),
            
            Promotion(
                title: "Mercado Fresh - 15% OFF",
                discount: "15% OFF",
                description: "Descuento en toda la compra de productos frescos y orgánicos.",
                storeName: "Fresh Market",
                category: .grocery,
                originalPrice: 100.0,
                discountedPrice: 85.0,
                validUntil: calendar.date(byAdding: .day, value: 10, to: today) ?? today,
                isExclusive: false,
                minOrder: 50.0,
                terms: ["Compra mínima $50", "Solo productos frescos", "Válido de lunes a viernes"],
                imageName: "grocery"
            ),
            
            Promotion(
                title: "3 Pizzas Medianas",
                discount: "40% OFF",
                description: "Promoción especial en 3 pizzas medianas de cualquier sabor.",
                storeName: "Pizza Express",
                category: .pizza,
                originalPrice: 90.0,
                discountedPrice: 54.0,
                validUntil: calendar.date(byAdding: .day, value: 4, to: today) ?? today,
                isExclusive: true,
                minOrder: nil,
                terms: ["Solo pizzas medianas", "Máximo 3 pizzas por orden", "Entrega gratis"],
                imageName: "pizza"
            ),
            
            Promotion(
                title: "Doble Sushi Roll",
                discount: "Buy 1 Get 1",
                description: "Compra 1 roll especial y llévate otro gratis del mismo valor o menor.",
                storeName: "Tokyo Kitchen",
                category: .sushi,
                originalPrice: 45.0,
                discountedPrice: 45.0,
                validUntil: calendar.date(byAdding: .day, value: 6, to: today) ?? today,
                isExclusive: false,
                minOrder: nil,
                terms: ["Solo rolls especiales", "El gratis debe ser de igual o menor valor", "Preparación en 20 min"],
                imageName: "sushi"
            ),
            
            Promotion(
                title: "Wrap Fit + Jugo Verde",
                discount: "Combo",
                description: "Combo especial: wrap fitness + jugo verde detox por precio especial.",
                storeName: "Fit Food",
                category: .healthy,
                originalPrice: 32.0,
                discountedPrice: 25.0,
                validUntil: calendar.date(byAdding: .day, value: 8, to: today) ?? today,
                isExclusive: true,
                minOrder: nil,
                terms: ["Solo wraps fitness", "Jugo verde de 500ml", "Ingredientes orgánicos"],
                imageName: "healthy"
            ),
            
            Promotion(
                title: "Mega Burger Combo",
                discount: "35% OFF",
                description: "Hamburguesa doble + papas grandes + bebida 500ml con descuentazo.",
                storeName: "Mega Burgers",
                category: .burger,
                originalPrice: 55.0,
                discountedPrice: 36.0,
                validUntil: calendar.date(byAdding: .day, value: 9, to: today) ?? today,
                isExclusive: false,
                minOrder: nil,
                terms: ["Solo combo mega", "Papas recién hechas", "Bebida a elegir"],
                imageName: "burger"
            )
        ]
        
        // Sample Stores
        stores = [
            Store(
                name: "Pizza Palace",
                description: "Las mejores pizzas artesanales de la ciudad con ingredientes frescos y masa hecha en casa.",
                category: .pizza,
                rating: 4.8,
                deliveryTime: "25-35 min",
                address: "Av. Italia 123, Centro",
                phone: "+1 234-567-8901",
                isOpen: true,
                specialties: ["Pizza Margherita", "Quattro Stagioni", "Prosciutto", "Vegana Especial"],
                priceRange: .moderate,
                features: ["Entrega gratis", "Masa artesanal", "Ingredientes frescos", "Opciones veganas"],
                imageName: "pizza",
                backgroundColor: "red"
            ),
            
            Store(
                name: "Sakura Sushi",
                description: "Auténtica cocina japonesa con chef especializado y pescado fresco diario.",
                category: .sushi,
                rating: 4.9,
                deliveryTime: "20-30 min",
                address: "Calle Japón 45, Zona Rosa",
                phone: "+1 234-567-8902",
                isOpen: true,
                specialties: ["Nigiri Premium", "Sashimi Variado", "California Roll", "Dragon Roll"],
                priceRange: .expensive,
                features: ["Pescado fresco diario", "Chef japonés", "Wasabi real", "Presentación especial"],
                imageName: "sushi",
                backgroundColor: "green"
            ),
            
            Store(
                name: "Burger Station",
                description: "Hamburguesas gourmet con carne 100% angus y panes artesanales horneados diariamente.",
                category: .burger,
                rating: 4.7,
                deliveryTime: "15-25 min",
                address: "Plaza Comercial 78, Local 12",
                phone: "+1 234-567-8903",
                isOpen: true,
                specialties: ["Angus Classic", "BBQ Bacon", "Mushroom Swiss", "Veggie Burger"],
                priceRange: .moderate,
                features: ["Carne 100% Angus", "Panes artesanales", "Papas caseras", "Salsas especiales"],
                imageName: "burger",
                backgroundColor: "orange"
            ),
            
            Store(
                name: "Green Life",
                description: "Restaurante saludable especializado en comida orgánica, bowls nutritivos y jugos naturales.",
                category: .healthy,
                rating: 4.6,
                deliveryTime: "20-30 min",
                address: "Eco Plaza 34, Piso 2",
                phone: "+1 234-567-8904",
                isOpen: true,
                specialties: ["Buddha Bowl", "Quinoa Power", "Green Smoothie", "Açaí Bowl"],
                priceRange: .moderate,
                features: ["Ingredientes orgánicos", "Opciones veganas", "Sin gluten", "Superfoods"],
                imageName: "healthy",
                backgroundColor: "green"
            ),
            
            Store(
                name: "Deli Corner",
                description: "Sandwiches artesanales y deli gourmet con ingredientes importados y pan recién horneado.",
                category: .sandwich,
                rating: 4.5,
                deliveryTime: "10-20 min",
                address: "Esquina Gourmet, Calle 5",
                phone: "+1 234-567-8905",
                isOpen: false,
                specialties: ["Club Sandwich", "Pastrami Rye", "Italian Sub", "Caprese Fresh"],
                priceRange: .moderate,
                features: ["Pan recién horneado", "Ingredientes importados", "Ensaladas frescas", "Café specialty"],
                imageName: "sandwich",
                backgroundColor: "brown"
            ),
            
            Store(
                name: "Fresh Market",
                description: "Supermercado gourmet con productos frescos, orgánicos y especialidades internacionales.",
                category: .grocery,
                rating: 4.4,
                deliveryTime: "30-45 min",
                address: "Av. Central 156, Mercado Norte",
                phone: "+1 234-567-8906",
                isOpen: true,
                specialties: ["Productos orgánicos", "Carnes premium", "Quesos artesanales", "Vinos selectos"],
                priceRange: .expensive,
                features: ["Productos orgánicos", "Carnicería premium", "Panadería propia", "Entrega refrigerada"],
                imageName: "grocery",
                backgroundColor: "blue"
            ),
            
            Store(
                name: "Tokyo Kitchen",
                description: "Cocina japonesa moderna con ambiente tradicional y técnicas culinarias auténticas.",
                category: .sushi,
                rating: 4.8,
                deliveryTime: "25-35 min",
                address: "Distrito Asiático 89, Torre A",
                phone: "+1 234-567-8907",
                isOpen: true,
                specialties: ["Omakase", "Tempura", "Ramen Tradicional", "Mochi Casero"],
                priceRange: .expensive,
                features: ["Ambiente tradicional", "Sake premium", "Chef con certificación", "Ingredientes japoneses"],
                imageName: "sushi",
                backgroundColor: "black"
            ),
            
            Store(
                name: "Pizza Express",
                description: "Pizzería familiar con recetas tradicionales italianas y servicio rápido de calidad.",
                category: .pizza,
                rating: 4.3,
                deliveryTime: "20-30 min",
                address: "Zona Familiar 23, Local B",
                phone: "+1 234-567-8908",
                isOpen: true,
                specialties: ["Napolitana", "Pepperoni Clásica", "Hawaiana", "Quattro Formaggi"],
                priceRange: .budget,
                features: ["Recetas tradicionales", "Precio familiar", "Entrega rápida", "Promociones diarias"],
                imageName: "pizza",
                backgroundColor: "red"
            ),
            
            Store(
                name: "Fit Food",
                description: "Comida saludable y nutritiva diseñada para un estilo de vida activo y balanceado.",
                category: .healthy,
                rating: 4.7,
                deliveryTime: "15-25 min",
                address: "Gym Plaza 67, Nivel 1",
                phone: "+1 234-567-8909",
                isOpen: true,
                specialties: ["Protein Bowl", "Post-Workout", "Detox Juice", "Energy Bars"],
                priceRange: .moderate,
                features: ["Alto en proteína", "Bajo en carbohidratos", "Sin azúcar añadida", "Para deportistas"],
                imageName: "healthy",
                backgroundColor: "green"
            ),
            
            Store(
                name: "Mega Burgers",
                description: "Hamburguesas XXL para los más hambrientos, con porciones generosas y sabores intensos.",
                category: .burger,
                rating: 4.2,
                deliveryTime: "20-35 min",
                address: "Food Court Mall, Sector C",
                phone: "+1 234-567-8910",
                isOpen: true,
                specialties: ["Triple Meat", "Bacon Explosion", "Onion Rings Tower", "Milkshake XXL"],
                priceRange: .budget,
                features: ["Porciones XXL", "Precios accesibles", "Ambiente casual", "Para compartir"],
                imageName: "burger",
                backgroundColor: "orange"
            )
        ]
    }
    
    func filteredPromotions(by category: FoodCategory) -> [Promotion] {
        if category == .all {
            return promotions
        }
        return promotions.filter { $0.category == category }
    }
    
    func filteredStores(by category: FoodCategory) -> [Store] {
        if category == .all {
            return stores
        }
        return stores.filter { $0.category == category }
    }
}