import Foundation

// MARK: - Product Categories
enum ProductCategory: String, CaseIterable {
    case bebidas = "Bebidas"
    case alimentos = "Alimentos"
    case cocteles = "Cocteles"
    case promociones = "Promociones"
}

// MARK: - Product Size Options
enum ProductSize: String, CaseIterable {
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

// MARK: - Store Data Model
struct ProductStore: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let category: ProductCategory
    let rating: Double
    let reviewCount: Int
    let preparationTime: String
    let deliveryTime: String
    let minimumOrder: Double?
    let deliveryFee: Double
    let isOpen: Bool
    let distance: String
    let address: String
    let phone: String
    let specialties: [String]
    let features: [String]
    
    var statusText: String {
        return isOpen ? "Abierto" : "Cerrado"
    }
    
    var ratingText: String {
        return String(format: "%.1f (%d)", rating, reviewCount)
    }
}

// MARK: - Product Data Model
struct Product: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let fullDescription: String
    let category: ProductCategory
    let basePrice: Double
    let originalPrice: Double?
    let rating: Double
    let reviewCount: Int
    let store: ProductStore
    let preparationTime: String
    let calories: Int?
    let isOrganic: Bool
    let isVegan: Bool
    let isGlutenFree: Bool
    let isSpicy: Bool
    let isSponsored: Bool
    let discount: String?
    let ingredients: [String]
    let allergens: [String]
    let nutritionalInfo: NutritionalInfo?
    let availableSizes: [ProductSize]
    let extras: [ProductExtra]
    let tags: [String]
    let isAvailable: Bool
    let stockQuantity: Int?
    let imageName: String
    
    var priceText: String {
        return "$\(Int(basePrice))"
    }
    
    var hasDiscount: Bool {
        return originalPrice != nil && originalPrice! > basePrice
    }
    
    var discountPercentage: Int? {
        guard let original = originalPrice, original > basePrice else { return nil }
        return Int(((original - basePrice) / original) * 100)
    }
    
    var isLowPrice: Bool {
        return basePrice <= 15.0
    }
    
    var isFastPrep: Bool {
        let prepTime = Int(preparationTime.components(separatedBy: " ").first ?? "0") ?? 0
        return prepTime <= 15
    }
    
    var ratingText: String {
        return String(format: "%.1f (%d)", rating, reviewCount)
    }
    
    var caloriesText: String? {
        guard let calories = calories else { return nil }
        return "\(calories) cal"
    }
    
    var dietaryTags: [String] {
        var tags: [String] = []
        if isOrganic { tags.append("Orgánico") }
        if isVegan { tags.append("Vegano") }
        if isGlutenFree { tags.append("Sin Gluten") }
        if isSpicy { tags.append("Picante") }
        return tags
    }
}

// MARK: - Nutritional Info
struct NutritionalInfo: Hashable {
    let calories: Int
    let protein: Double  // gramos
    let carbs: Double    // gramos
    let fat: Double      // gramos
    let fiber: Double?   // gramos
    let sugar: Double?   // gramos
    let sodium: Double?  // mg
}

// MARK: - Product Extras
struct ProductExtra: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    let isAvailable: Bool
    
    var priceText: String {
        return "+$\(Int(price))"
    }
}

// MARK: - Product Store Manager
class ProductStoreManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var stores: [ProductStore] = []
    
    init() {
        loadStores()
        loadProducts()
    }
    
    var recommendedProducts: [Product] {
        return products.filter { $0.isSponsored }.prefix(4).map { $0 }
    }
    
    private func loadStores() {
        stores = ProductStoreData.stores
    }
    
    private func loadProducts() {
        products = ProductStoreData.products
    }
}

// MARK: - Sample Data
struct ProductStoreData {
    
    static let stores: [ProductStore] = [
        ProductStore(
            name: "Coffee Lab Premium",
            description: "Café artesanal de especialidad con granos de origen único",
            category: .bebidas,
            rating: 4.8,
            reviewCount: 324,
            preparationTime: "5-8 min",
            deliveryTime: "15-25 min",
            minimumOrder: 12.0,
            deliveryFee: 2.5,
            isOpen: true,
            distance: "0.3 km",
            address: "Av. Principal 123, Centro",
            phone: "+1234567890",
            specialties: ["Café de Especialidad", "Latte Art", "Cold Brew", "Pasteles Artesanales"],
            features: ["WiFi Gratis", "Terraza", "Pagos Digitales", "Café Orgánico"]
        ),
        
        ProductStore(
            name: "Green Juice Bar",
            description: "Jugos naturales y smoothies con superalimentos orgánicos",
            category: .bebidas,
            rating: 4.7,
            reviewCount: 256,
            preparationTime: "3-5 min",
            deliveryTime: "10-20 min",
            minimumOrder: 15.0,
            deliveryFee: 3.0,
            isOpen: true,
            distance: "0.8 km",
            address: "Calle Verde 45, Zona Norte",
            phone: "+1234567891",
            specialties: ["Jugos Detox", "Smoothie Bowls", "Shots de Jengibre", "Proteínas Vegetales"],
            features: ["100% Orgánico", "Sin Azúcar Añadida", "Biodegradable", "Superalimentos"]
        ),
        
        ProductStore(
            name: "Burger Station",
            description: "Hamburguesas gourmet con carne premium y ingredientes frescos",
            category: .alimentos,
            rating: 4.6,
            reviewCount: 512,
            preparationTime: "12-18 min",
            deliveryTime: "25-35 min",
            minimumOrder: 20.0,
            deliveryFee: 4.0,
            isOpen: true,
            distance: "1.2 km",
            address: "Plaza Food Court, Local 8",
            phone: "+1234567892",
            specialties: ["Wagyu Burgers", "Papas Trufadas", "Shakes Artesanales", "BBQ Ribs"],
            features: ["Carne Premium", "Pan Artesanal", "Salsas Caseras", "Opciones Veganas"]
        ),
        
        ProductStore(
            name: "Sweet Dreams Bakery",
            description: "Repostería artesanal y postres europeos hechos diariamente",
            category: .alimentos,
            rating: 4.9,
            reviewCount: 189,
            preparationTime: "2-5 min",
            deliveryTime: "20-30 min",
            minimumOrder: 10.0,
            deliveryFee: 2.0,
            isOpen: true,
            distance: "0.7 km",
            address: "Av. Dulce 78, Centro Histórico",
            phone: "+1234567893",
            specialties: ["Macarons Franceses", "Cheesecakes", "Croissants", "Tartas Estacionales"],
            features: ["Recetas Europeas", "Sin Conservantes", "Personalizable", "Catering"]
        ),
        
        ProductStore(
            name: "Morning Bliss Café",
            description: "Desayunos completos y brunch internacional todo el día",
            category: .alimentos,
            rating: 4.5,
            reviewCount: 387,
            preparationTime: "8-15 min",
            deliveryTime: "20-30 min",
            minimumOrder: 18.0,
            deliveryFee: 3.5,
            isOpen: true,
            distance: "1.0 km",
            address: "Calle Sol 156, Zona Rosa",
            phone: "+1234567894",
            specialties: ["Pancakes Gourmet", "Huevos Benedict", "Avocado Toast", "Smoothie Bowls"],
            features: ["Brunch Todo el Día", "Ingredientes Locales", "Opciones Keto", "Jugos Frescos"]
        ),
        
        ProductStore(
            name: "Snack House",
            description: "Aperitivos gourmet y snacks saludables para toda ocasión",
            category: .alimentos,
            rating: 4.4,
            reviewCount: 198,
            preparationTime: "1-3 min",
            deliveryTime: "15-25 min",
            minimumOrder: 8.0,
            deliveryFee: 2.0,
            isOpen: true,
            distance: "0.5 km",
            address: "Centro Comercial, Planta Baja",
            phone: "+1234567895",
            specialties: ["Frutos Secos Premium", "Chips Artesanales", "Trail Mix", "Barras Energéticas"],
            features: ["Sin Gluten", "Opciones Veganas", "Productos Locales", "Empaques Eco"]
        ),

        ProductStore(
            name: "Mixology Lab",
            description: "Cocteles artesanales y bebidas premium con técnicas mixology",
            category: .cocteles,
            rating: 4.8,
            reviewCount: 287,
            preparationTime: "5-8 min",
            deliveryTime: "20-30 min",
            minimumOrder: 25.0,
            deliveryFee: 4.5,
            isOpen: true,
            distance: "1.1 km",
            address: "Zona Rosa, Edificio Premium 201",
            phone: "+1234567896",
            specialties: ["Cocteles Clásicos", "Mixology Molecular", "Spirits Premium", "Cócteles Autorales"],
            features: ["Bartenders Certificados", "Ingredientes Premium", "Técnicas Avanzadas", "Servicio VIP"]
        ),

        ProductStore(
            name: "Promo Express",
            description: "Las mejores ofertas y promociones especiales de la ciudad",
            category: .promociones,
            rating: 4.3,
            reviewCount: 445,
            preparationTime: "Variable",
            deliveryTime: "15-35 min",
            minimumOrder: 0.0,
            deliveryFee: 1.5,
            isOpen: true,
            distance: "Variable",
            address: "Múltiples ubicaciones",
            phone: "+1234567897",
            specialties: ["Ofertas del Día", "Combos Especiales", "Descuentos Múltiples", "Happy Hours"],
            features: ["Ofertas Limitadas", "Precios Especiales", "Combos Exclusivos", "Promociones Diarias"]
        )
    ]
    
    static let products: [Product] = [
        // BEBIDAS
        Product(
            name: "Café Americano Premium",
            description: "Café americano con granos de especialidad de Colombia",
            fullDescription: "Café americano preparado con granos de especialidad seleccionados de las montañas de Colombia. Tostado medio para resaltar las notas de chocolate y caramelo. Servido en taza de porcelana con opción de leche vegetal.",
            category: .bebidas,
            basePrice: 8.50,
            originalPrice: nil,
            rating: 4.7,
            reviewCount: 89,
            store: stores[0],
            preparationTime: "5 min",
            calories: 5,
            isOrganic: true,
            isVegan: true,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: false,
            discount: nil,
            ingredients: ["Granos de café colombiano", "Agua filtrada"],
            allergens: [],
            nutritionalInfo: NutritionalInfo(calories: 5, protein: 0.3, carbs: 0.0, fat: 0.0, fiber: nil, sugar: nil, sodium: 2.0),
            availableSizes: [.small, .medium, .large],
            extras: [
                ProductExtra(name: "Shot extra", price: 1.5, isAvailable: true),
                ProductExtra(name: "Leche de almendra", price: 0.5, isAvailable: true),
                ProductExtra(name: "Leche de avena", price: 0.7, isAvailable: true)
            ],
            tags: ["Café de especialidad", "Origen único", "Tostado medio"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "coffee_americano"
        ),
        
        Product(
            name: "Latte de Vainilla",
            description: "Espresso cremoso con leche vaporizada y toque de vainilla",
            fullDescription: "Espresso doble combinado con leche vaporizada a la perfección y jarabe de vainilla artesanal. Decorado con arte latte y servido en taza grande. Opción de leche vegetal disponible.",
            category: .bebidas,
            basePrice: 12.00,
            originalPrice: 15.00,
            rating: 4.8,
            reviewCount: 156,
            store: stores[0],
            preparationTime: "6 min",
            calories: 190,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: true,
            discount: "20% OFF",
            ingredients: ["Espresso", "Leche entera", "Jarabe de vainilla", "Arte latte"],
            allergens: ["Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 190, protein: 9.0, carbs: 18.0, fat: 7.0, fiber: 0.0, sugar: 16.0, sodium: 105.0),
            availableSizes: [.medium, .large, .extraLarge],
            extras: [
                ProductExtra(name: "Shot extra", price: 1.5, isAvailable: true),
                ProductExtra(name: "Leche vegetal", price: 0.5, isAvailable: true),
                ProductExtra(name: "Sin azúcar", price: 0.0, isAvailable: true)
            ],
            tags: ["Bestseller", "Latte art", "Cremoso"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "latte_vanilla"
        ),
        
        Product(
            name: "Smoothie Verde Detox",
            description: "Blend de espinaca, manzana verde, apio y jengibre",
            fullDescription: "Smoothie detox preparado con espinaca baby orgánica, manzana verde, apio fresco, jengibre, limón y agua de coco. Rico en vitaminas y minerales. Perfecto para comenzar el día con energía.",
            category: .bebidas,
            basePrice: 14.50,
            originalPrice: nil,
            rating: 4.6,
            reviewCount: 78,
            store: stores[1],
            preparationTime: "4 min",
            calories: 95,
            isOrganic: true,
            isVegan: true,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: true,
            discount: nil,
            ingredients: ["Espinaca orgánica", "Manzana verde", "Apio", "Jengibre", "Limón", "Agua de coco"],
            allergens: [],
            nutritionalInfo: NutritionalInfo(calories: 95, protein: 2.5, carbs: 22.0, fat: 0.5, fiber: 4.5, sugar: 16.0, sodium: 85.0),
            availableSizes: [.medium, .large],
            extras: [
                ProductExtra(name: "Proteína vegetal", price: 3.0, isAvailable: true),
                ProductExtra(name: "Chía", price: 1.0, isAvailable: true),
                ProductExtra(name: "Espirulina", price: 2.0, isAvailable: true)
            ],
            tags: ["Detox", "Antioxidante", "Energizante"],
            isAvailable: true,
            stockQuantity: 25,
            imageName: "smoothie_green"
        ),
        
        // COMIDA
        Product(
            name: "Burger Wagyu Clásica",
            description: "Hamburguesa de carne wagyu con queso maduro y vegetales",
            fullDescription: "Hamburguesa premium con carne wagyu de 200g, queso cheddar maduro, lechuga hidropónica, tomate cherry, cebolla caramelizada y salsa especial de la casa. Pan brioche artesanal tostado.",
            category: .alimentos,
            basePrice: 32.00,
            originalPrice: 38.00,
            rating: 4.9,
            reviewCount: 234,
            store: stores[2],
            preparationTime: "15 min",
            calories: 650,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: false,
            isSpicy: false,
            isSponsored: true,
            discount: "15% OFF",
            ingredients: ["Carne wagyu", "Pan brioche", "Queso cheddar", "Lechuga", "Tomate", "Cebolla", "Salsa especial"],
            allergens: ["Gluten", "Lácteos", "Huevo"],
            nutritionalInfo: NutritionalInfo(calories: 650, protein: 35.0, carbs: 42.0, fat: 38.0, fiber: 3.0, sugar: 8.0, sodium: 1250.0),
            availableSizes: [.medium, .large],
            extras: [
                ProductExtra(name: "Tocino extra", price: 3.5, isAvailable: true),
                ProductExtra(name: "Queso extra", price: 2.0, isAvailable: true),
                ProductExtra(name: "Aguacate", price: 2.5, isAvailable: true),
                ProductExtra(name: "Papas trufadas", price: 4.0, isAvailable: true)
            ],
            tags: ["Premium", "Wagyu", "Artesanal"],
            isAvailable: true,
            stockQuantity: 12,
            imageName: "burger_wagyu"
        ),
        
        Product(
            name: "Bowl de Quinoa Mediterráneo",
            description: "Quinoa con vegetales asados, feta y aderezo de limón",
            fullDescription: "Bowl nutritivo con quinoa tricolor, vegetales mediterráneos asados (berenjena, calabacín, pimientos), queso feta, aceitunas kalamata, tomates cherry y aderezo de limón y hierbas frescas.",
            category: .alimentos,
            basePrice: 18.50,
            originalPrice: nil,
            rating: 4.7,
            reviewCount: 145,
            store: stores[1],
            preparationTime: "8 min",
            calories: 420,
            isOrganic: true,
            isVegan: false,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: false,
            discount: nil,
            ingredients: ["Quinoa tricolor", "Berenjena", "Calabacín", "Pimientos", "Queso feta", "Aceitunas", "Tomates cherry", "Aderezo de limón"],
            allergens: ["Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 420, protein: 15.0, carbs: 52.0, fat: 18.0, fiber: 8.0, sugar: 12.0, sodium: 680.0),
            availableSizes: [.medium, .large],
            extras: [
                ProductExtra(name: "Pollo a la plancha", price: 5.0, isAvailable: true),
                ProductExtra(name: "Hummus", price: 2.0, isAvailable: true),
                ProductExtra(name: "Aguacate", price: 3.0, isAvailable: true)
            ],
            tags: ["Mediterráneo", "Alto en proteína", "Superalimento"],
            isAvailable: true,
            stockQuantity: 18,
            imageName: "quinoa_bowl"
        ),
        
        // POSTRES
        Product(
            name: "Cheesecake de Frutos Rojos",
            description: "Cheesecake cremoso con compota de frutos rojos frescos",
            fullDescription: "Cheesecake artesanal preparado con queso crema Philadelphia, base de galleta graham y cobertura de compota de frutos rojos frescos (arándanos, frambuesas, fresas). Decorado con menta fresca.",
            category: .alimentos,
            basePrice: 16.00,
            originalPrice: nil,
            rating: 4.8,
            reviewCount: 92,
            store: stores[3],
            preparationTime: "3 min",
            calories: 380,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: false,
            isSpicy: false,
            isSponsored: false,
            discount: nil,
            ingredients: ["Queso crema", "Galleta graham", "Arándanos", "Frambuesas", "Fresas", "Azúcar", "Huevos", "Menta"],
            allergens: ["Gluten", "Lácteos", "Huevo"],
            nutritionalInfo: NutritionalInfo(calories: 380, protein: 7.0, carbs: 35.0, fat: 24.0, fiber: 2.0, sugar: 28.0, sodium: 320.0),
            availableSizes: [.medium],
            extras: [
                ProductExtra(name: "Frutos rojos extra", price: 3.0, isAvailable: true),
                ProductExtra(name: "Crema batida", price: 2.0, isAvailable: true)
            ],
            tags: ["Artesanal", "Fresco", "Cremoso"],
            isAvailable: true,
            stockQuantity: 8,
            imageName: "cheesecake_berries"
        ),
        
        Product(
            name: "Macarons Franceses Mix",
            description: "Selección de 6 macarons de sabores variados",
            fullDescription: "Caja con 6 macarons franceses artesanales en sabores: rosa, chocolate, vainilla, limón, pistacho y lavanda. Preparados con almendra molida y técnica tradicional francesa.",
            category: .alimentos,
            basePrice: 22.00,
            originalPrice: 28.00,
            rating: 4.9,
            reviewCount: 67,
            store: stores[3],
            preparationTime: "2 min",
            calories: 480,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: true,
            discount: "21% OFF",
            ingredients: ["Almendra molida", "Azúcar glass", "Claras de huevo", "Colorantes naturales", "Ganache variado"],
            allergens: ["Frutos secos", "Huevo", "Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 480, protein: 12.0, carbs: 58.0, fat: 22.0, fiber: 4.0, sugar: 54.0, sodium: 45.0),
            availableSizes: [.medium],
            extras: [
                ProductExtra(name: "Caja regalo", price: 3.0, isAvailable: true),
                ProductExtra(name: "Macarons extra (c/u)", price: 3.5, isAvailable: true)
            ],
            tags: ["Francés", "Artesanal", "Sin gluten"],
            isAvailable: true,
            stockQuantity: 15,
            imageName: "macarons_mix"
        ),
        
        // DESAYUNO
        Product(
            name: "Pancakes con Arándanos",
            description: "Stack de 3 pancakes esponjosos con arándanos frescos",
            fullDescription: "Tres pancakes esponjosos preparados con masa artesanal, arándanos frescos incorporados, servidos con mantequilla, miel de maple canadiense y arándanos adicionales. Incluye crema batida.",
            category: .alimentos,
            basePrice: 19.50,
            originalPrice: nil,
            rating: 4.6,
            reviewCount: 178,
            store: stores[4],
            preparationTime: "12 min",
            calories: 520,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: false,
            isSpicy: false,
            isSponsored: false,
            discount: nil,
            ingredients: ["Harina de trigo", "Huevos", "Leche", "Azúcar", "Arándanos frescos", "Miel de maple", "Mantequilla", "Crema batida"],
            allergens: ["Gluten", "Lácteos", "Huevo"],
            nutritionalInfo: NutritionalInfo(calories: 520, protein: 12.0, carbs: 78.0, fat: 18.0, fiber: 4.0, sugar: 35.0, sodium: 590.0),
            availableSizes: [.medium, .large],
            extras: [
                ProductExtra(name: "Arándanos extra", price: 2.5, isAvailable: true),
                ProductExtra(name: "Tocino", price: 4.0, isAvailable: true),
                ProductExtra(name: "Nueces", price: 2.0, isAvailable: true)
            ],
            tags: ["Clásico", "Esponjoso", "Maple"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "pancakes_blueberry"
        ),
        
        Product(
            name: "Avocado Toast Gourmet",
            description: "Pan artesanal con aguacate, huevo poché y microgreens",
            fullDescription: "Pan masa madre artesanal tostado, aguacate maduro aplastado con limón y especias, huevo poché perfecto, microgreens frescos, tomates cherry, queso feta desmenuzado y aceite de oliva extra virgen.",
            category: .alimentos,
            basePrice: 17.00,
            originalPrice: nil,
            rating: 4.7,
            reviewCount: 134,
            store: stores[4],
            preparationTime: "8 min",
            calories: 340,
            isOrganic: true,
            isVegan: false,
            isGlutenFree: false,
            isSpicy: false,
            isSponsored: true,
            discount: nil,
            ingredients: ["Pan masa madre", "Aguacate", "Huevo", "Microgreens", "Tomates cherry", "Queso feta", "Aceite de oliva", "Limón"],
            allergens: ["Gluten", "Huevo", "Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 340, protein: 16.0, carbs: 28.0, fat: 20.0, fiber: 12.0, sugar: 4.0, sodium: 420.0),
            availableSizes: [.medium],
            extras: [
                ProductExtra(name: "Salmón ahumado", price: 6.0, isAvailable: true),
                ProductExtra(name: "Aguacate extra", price: 3.0, isAvailable: true),
                ProductExtra(name: "Huevo extra", price: 2.5, isAvailable: true)
            ],
            tags: ["Instagrameable", "Saludable", "Gourmet"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "avocado_toast"
        ),
        
        // SNACKS
        Product(
            name: "Mix de Frutos Secos Premium",
            description: "Selección de nueces, almendras, pistachos y arándanos",
            fullDescription: "Mezcla premium de frutos secos tostados: nueces de California, almendras marcona, pistachos iranies, anacardos, arándanos deshidratados y semillas de calabaza. Sin sal añadida, tostado artesanal.",
            category: .alimentos,
            basePrice: 12.50,
            originalPrice: nil,
            rating: 4.5,
            reviewCount: 89,
            store: stores[5],
            preparationTime: "1 min",
            calories: 180,
            isOrganic: true,
            isVegan: true,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: false,
            discount: nil,
            ingredients: ["Nueces", "Almendras marcona", "Pistachos", "Anacardos", "Arándanos deshidratados", "Semillas de calabaza"],
            allergens: ["Frutos secos"],
            nutritionalInfo: NutritionalInfo(calories: 180, protein: 6.0, carbs: 8.0, fat: 15.0, fiber: 3.0, sugar: 4.0, sodium: 2.0),
            availableSizes: [.small, .medium, .large],
            extras: [
                ProductExtra(name: "Chocolate oscuro", price: 2.0, isAvailable: true),
                ProductExtra(name: "Coco laminado", price: 1.5, isAvailable: true)
            ],
            tags: ["Premium", "Sin sal", "Antioxidantes"],
            isAvailable: true,
            stockQuantity: 45,
            imageName: "nuts_mix"
        ),
        
        Product(
            name: "Chips de Kale Crujientes",
            description: "Chips de kale orgánico deshidratado con sal marina",
            fullDescription: "Chips de kale orgánico cuidadosamente deshidratado a baja temperatura para mantener nutrientes. Sazonado con sal marina del Himalaya y aceite de oliva extra virgen. Sin conservantes artificiales.",
            category: .alimentos,
            basePrice: 9.50,
            originalPrice: nil,
            rating: 4.3,
            reviewCount: 56,
            store: stores[5],
            preparationTime: "1 min",
            calories: 60,
            isOrganic: true,
            isVegan: true,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: false,
            discount: nil,
            ingredients: ["Kale orgánico", "Aceite de oliva extra virgen", "Sal marina del Himalaya"],
            allergens: [],
            nutritionalInfo: NutritionalInfo(calories: 60, protein: 3.0, carbs: 6.0, fat: 3.5, fiber: 2.0, sugar: 1.0, sodium: 190.0),
            availableSizes: [.small, .medium],
            extras: [],
            tags: ["Superfood", "Crujiente", "Bajo en calorías"],
            isAvailable: true,
            stockQuantity: 32,
            imageName: "kale_chips"
        ),
        
        // COCTELES
        Product(
            name: "Mojito Clásico",
            description: "Ron blanco, menta fresca, lima y agua mineral",
            fullDescription: "El mojito perfecto preparado con ron blanco premium, hojas de menta fresca, lima recién exprimida, azúcar de caña y agua mineral. Servido con hielo picado en vaso highball con decoración de menta.",
            category: .cocteles,
            basePrice: 18.00,
            originalPrice: nil,
            rating: 4.7,
            reviewCount: 142,
            store: stores[6],
            preparationTime: "5 min",
            calories: 168,
            isOrganic: false,
            isVegan: true,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: false,
            discount: nil,
            ingredients: ["Ron blanco", "Menta fresca", "Lima", "Azúcar de caña", "Agua mineral"],
            allergens: [],
            nutritionalInfo: NutritionalInfo(calories: 168, protein: 0.1, carbs: 12.0, fat: 0.0, fiber: 0.1, sugar: 11.0, sodium: 5.0),
            availableSizes: [.medium, .large],
            extras: [
                ProductExtra(name: "Ron premium", price: 4.0, isAvailable: true),
                ProductExtra(name: "Menta extra", price: 1.0, isAvailable: true)
            ],
            tags: ["Clásico", "Refrescante", "Cuban style"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "mojito"
        ),
        
        Product(
            name: "Old Fashioned Premium",
            description: "Whiskey bourbon, bitter de angostura y azúcar",
            fullDescription: "Cóctel clásico americano preparado con whiskey bourbon de alta calidad, bitter de angostura, azúcar demerara y cáscara de naranja. Servido con hielo esférico en vaso rocks.",
            category: .cocteles,
            basePrice: 24.00,
            originalPrice: nil,
            rating: 4.8,
            reviewCount: 89,
            store: stores[6],
            preparationTime: "6 min",
            calories: 155,
            isOrganic: false,
            isVegan: true,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: true,
            discount: nil,
            ingredients: ["Whiskey bourbon", "Bitter angostura", "Azúcar demerara", "Cáscara de naranja"],
            allergens: [],
            nutritionalInfo: NutritionalInfo(calories: 155, protein: 0.0, carbs: 4.0, fat: 0.0, fiber: 0.0, sugar: 4.0, sodium: 1.0),
            availableSizes: [.medium],
            extras: [
                ProductExtra(name: "Whiskey top shelf", price: 8.0, isAvailable: true),
                ProductExtra(name: "Hielo esférico XL", price: 2.0, isAvailable: true)
            ],
            tags: ["Premium", "Clásico", "Americana"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "old_fashioned"
        ),
        
        Product(
            name: "Piña Colada Tropical",
            description: "Ron blanco, crema de coco, jugo de piña y hielo",
            fullDescription: "El trópico en un vaso. Combinación perfecta de ron blanco caribeño, crema de coco natural, jugo de piña fresco y hielo triturado. Servido en copa hurricane con decoración tropical.",
            category: .cocteles,
            basePrice: 16.50,
            originalPrice: 19.00,
            rating: 4.6,
            reviewCount: 95,
            store: stores[6],
            preparationTime: "4 min",
            calories: 245,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: true,
            isSpicy: false,
            isSponsored: false,
            discount: "13% OFF",
            ingredients: ["Ron blanco", "Crema de coco", "Jugo de piña", "Hielo"],
            allergens: ["Coco"],
            nutritionalInfo: NutritionalInfo(calories: 245, protein: 1.5, carbs: 28.0, fat: 8.0, fiber: 1.0, sugar: 25.0, sodium: 15.0),
            availableSizes: [.medium, .large],
            extras: [
                ProductExtra(name: "Ron añejo", price: 3.5, isAvailable: true),
                ProductExtra(name: "Piña natural extra", price: 2.0, isAvailable: true)
            ],
            tags: ["Tropical", "Cremoso", "Refrescante"],
            isAvailable: true,
            stockQuantity: 24,
            imageName: "pina_colada"
        ),
        
        // PROMOCIONES
        Product(
            name: "Combo Happy Hour",
            description: "2x1 en bebidas seleccionadas de 5-7 PM",
            fullDescription: "¡La mejor promoción del día! Disfruta de 2x1 en todas nuestras bebidas seleccionadas incluyendo cervezas nacionales, vinos de la casa, y cócteles clásicos. Válido de lunes a viernes de 5:00 PM a 7:00 PM.",
            category: .promociones,
            basePrice: 12.00,
            originalPrice: 24.00,
            rating: 4.5,
            reviewCount: 267,
            store: stores[7],
            preparationTime: "Variable",
            calories: nil,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: false,
            isSpicy: false,
            isSponsored: true,
            discount: "50% OFF",
            ingredients: ["Bebidas seleccionadas"],
            allergens: ["Variable según selección"],
            nutritionalInfo: nil,
            availableSizes: [],
            extras: [],
            tags: ["2x1", "Happy Hour", "Oferta limitada"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "happy_hour"
        ),
        
        Product(
            name: "Mega Combo Familiar",
            description: "Pizza grande + 4 bebidas + postre por precio especial",
            fullDescription: "El combo perfecto para compartir en familia. Incluye una pizza grande de hasta 4 ingredientes, 4 bebidas a elección (refrescos o jugos), y un postre familiar. Ahorra más de $15 con este combo especial.",
            category: .promociones,
            basePrice: 35.00,
            originalPrice: 52.00,
            rating: 4.4,
            reviewCount: 198,
            store: stores[7],
            preparationTime: "25 min",
            calories: 2400,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: false,
            isSpicy: false,
            isSponsored: false,
            discount: "33% OFF",
            ingredients: ["Pizza grande", "4 bebidas", "Postre familiar"],
            allergens: ["Gluten", "Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 2400, protein: 85.0, carbs: 280.0, fat: 95.0, fiber: 15.0, sugar: 45.0, sodium: 3200.0),
            availableSizes: [],
            extras: [
                ProductExtra(name: "Ingrediente extra pizza", price: 3.0, isAvailable: true),
                ProductExtra(name: "Upgrade bebidas premium", price: 5.0, isAvailable: true)
            ],
            tags: ["Familiar", "Combo", "Ahorro"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "family_combo"
        ),
        
        Product(
            name: "Desayuno Completo Oferta",
            description: "Desayuno completo con café ilimitado a precio especial",
            fullDescription: "Comienza tu día perfecto con nuestro desayuno completo en oferta. Incluye huevos a tu elección, tocino, pan tostado, frutas frescas, jugo natural y café ilimitado durante tu estadía. Solo disponible hasta las 12:00 PM.",
            category: .promociones,
            basePrice: 14.50,
            originalPrice: 21.00,
            rating: 4.6,
            reviewCount: 178,
            store: stores[7],
            preparationTime: "15 min",
            calories: 520,
            isOrganic: false,
            isVegan: false,
            isGlutenFree: false,
            isSpicy: false,
            isSponsored: true,
            discount: "31% OFF",
            ingredients: ["Huevos", "Tocino", "Pan tostado", "Frutas", "Jugo natural", "Café"],
            allergens: ["Gluten", "Huevo", "Lácteos"],
            nutritionalInfo: NutritionalInfo(calories: 520, protein: 22.0, carbs: 48.0, fat: 28.0, fiber: 6.0, sugar: 18.0, sodium: 980.0),
            availableSizes: [],
            extras: [
                ProductExtra(name: "Huevo extra", price: 2.0, isAvailable: true),
                ProductExtra(name: "Aguacate", price: 3.0, isAvailable: true)
            ],
            tags: ["Desayuno", "Completo", "Café ilimitado"],
            isAvailable: true,
            stockQuantity: nil,
            imageName: "breakfast_special"
        )
    ]
}