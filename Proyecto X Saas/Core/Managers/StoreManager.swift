import Foundation
import Combine

@MainActor
class StoreManager: ObservableObject {
    @Published var stores: [ProductStore] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Computed properties for filtering
    var openStores: [ProductStore] {
        stores.filter { $0.isOpen }
    }
    
    var topRatedStores: [ProductStore] {
        stores.filter { $0.rating >= 4.5 }
    }
    
    func loadStores() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedStores = try await networkManager.fetchStores()
            self.stores = fetchedStores
            self.isLoading = false
        } catch let DecodingError.keyNotFound(key, context) {
            self.errorMessage = "Error de decodificación: Falta la clave '\(key.stringValue)'"
            self.isLoading = false
            print("❌ Decoding Error - Missing key: '\(key.stringValue)'")
            print("   Context: \(context.debugDescription)")
            print("   CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch let DecodingError.typeMismatch(type, context) {
            self.errorMessage = "Error de decodificación: Tipo incorrecto para '\(type)'"
            self.isLoading = false
            print("❌ Decoding Error - Type mismatch for: '\(type)'")
            print("   Context: \(context.debugDescription)")
            print("   CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch let DecodingError.valueNotFound(type, context) {
            self.errorMessage = "Error de decodificación: Valor no encontrado para '\(type)'"
            self.isLoading = false
            print("❌ Decoding Error - Value not found for: '\(type)'")
            print("   Context: \(context.debugDescription)")
            print("   CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch let DecodingError.dataCorrupted(context) {
            self.errorMessage = "Error de decodificación: Datos corruptos"
            self.isLoading = false
            print("❌ Decoding Error - Data corrupted")
            print("   Context: \(context.debugDescription)")
            print("   CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            print("❌ Error loading stores: \(error)")
        }
    }
    
    func searchStores(category: ProductCategory? = nil, isOpen: Bool? = nil) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedStores = try await networkManager.searchStores(
                    category: category?.rawValue,
                    isOpen: isOpen
                )
                self.stores = fetchedStores
                self.isLoading = false
            } catch let DecodingError.keyNotFound(key, context) {
                self.errorMessage = "Error: Falta la clave '\(key.stringValue)'"
                self.isLoading = false
                print("❌ Search Stores - Missing key: '\(key.stringValue)' at path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("❌ Error searching stores: \(error)")
            }
        }
    }
    
    func getStore(id: String) async -> ProductStore? {
        do {
            return try await networkManager.fetchStore(id: id)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return nil
        }
    }
    
    var allOpenStores: [ProductStore] {
        return stores.filter { $0.isOpen }
    }
    
    var storesByCategory: [ProductCategory: [ProductStore]] {
        return Dictionary(grouping: stores, by: { $0.category })
    }
    
    func stores(for category: ProductCategory) -> [ProductStore] {
        return stores.filter { $0.category == category }
    }
    
    var featuredStores: [ProductStore] {
        return stores.filter { $0.rating >= 4.5 }.prefix(3).map { $0 }
    }
}

@MainActor
class ProductManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    
    // Computed properties for filtering
    var veganProducts: [Product] {
        products.filter { $0.isVegan }
    }
    
    var glutenFreeProducts: [Product] {
        products.filter { $0.isGlutenFree }
    }
    
    var organicProducts: [Product] {
        products.filter { $0.isOrganic }
    }
    
    var quickProducts: [Product] {
        products.filter { product in
            let time = product.preparationTime.lowercased()
            return time.contains("5") || time.contains("10") || time.contains("inmediato")
        }
    }
    
    var discountedProducts: [Product] {
        products.filter { $0.hasDiscount }
    }
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedProducts = try await networkManager.fetchProducts()
            self.products = fetchedProducts
            self.isLoading = false
        } catch let DecodingError.keyNotFound(key, context) {
            self.errorMessage = "Error: Falta la clave '\(key.stringValue)'"
            self.isLoading = false
            print("❌ Products - Missing key: '\(key.stringValue)' at path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            print("❌ Error loading products: \(error)")
        }
    }
    
    func loadProducts(for storeId: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedProducts = try await networkManager.fetchProductsByStore(storeId: storeId)
                self.products = fetchedProducts
                self.isLoading = false
            } catch let DecodingError.keyNotFound(key, context) {
                self.errorMessage = "Error: Falta la clave '\(key.stringValue)'"
                self.isLoading = false
                print("❌ Products by Store - Missing key: '\(key.stringValue)' at path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("❌ Error loading products for store: \(error)")
            }
        }
    }
    
    func searchProducts(
        category: ProductCategory? = nil,
        isVegan: Bool? = nil,
        isGlutenFree: Bool? = nil,
        isOrganic: Bool? = nil
    ) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedProducts = try await networkManager.searchProducts(
                    category: category?.rawValue,
                    isVegan: isVegan,
                    isGlutenFree: isGlutenFree,
                    isOrganic: isOrganic
                )
                self.products = fetchedProducts
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error searching products: \(error)")
            }
        }
    }
    
    func getProduct(id: String) async -> Product? {
        do {
            return try await networkManager.fetchProduct(id: id)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return nil
        }
    }
    
    var recommendedProducts: [Product] {
        return products.filter { $0.isSponsored }.prefix(4).map { $0 }
    }
    
    var availableProducts: [Product] {
        return products.filter { $0.isAvailable }
    }
    
    func products(for category: ProductCategory) -> [Product] {
        return products.filter { $0.category == category }
    }
    
    var productsByCategory: [ProductCategory: [Product]] {
        return Dictionary(grouping: products, by: { $0.category })
    }
}

@MainActor
class EventManager: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager.shared
    
    // Computed properties for filtering
    var upcomingEvents: [Event] {
        events.filter { event in
            return event.parsedDate > Date()
        }
    }
    
    var todayEvents: [Event] {
        events.filter { event in
            return Calendar.current.isDateInToday(event.parsedDate)
        }
    }
    
    var thisWeekEvents: [Event] {
        events.filter { event in
            return Calendar.current.isDate(event.parsedDate, equalTo: Date(), toGranularity: .weekOfYear)
        }
    }
    
    var freeEvents: [Event] {
        events.filter { $0.price == 0 }
    }
    
    func loadEvents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedEvents = try await networkManager.fetchEvents()
            self.events = fetchedEvents
            self.isLoading = false
        } catch let DecodingError.keyNotFound(key, context) {
            self.errorMessage = "Error: Falta la clave '\(key.stringValue)'"
            self.isLoading = false
            print("❌ Events - Missing key: '\(key.stringValue)' at path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            print("❌ Error loading events: \(error)")
        }
    }
    
    func searchEvents(category: EventCategory? = nil, location: String? = nil) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedEvents = try await networkManager.searchEvents(
                    category: category?.rawValue,
                    location: location
                )
                self.events = fetchedEvents
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("Error searching events: \(error)")
            }
        }
    }
    
    func getEvent(id: String) async -> Event? {
        do {
            return try await networkManager.fetchEvent(id: id)
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            return nil
        }
    }
    
    var availableEvents: [Event] {
        return events.filter { $0.availableTickets > 0 }
    }
    
    var sponsoredEvents: [Event] {
        return events.filter { $0.isSponsored }
    }
    
    func events(for category: EventCategory) -> [Event] {
        return events.filter { $0.category == category }
    }
    
    var eventsByCategory: [EventCategory: [Event]] {
        return Dictionary(grouping: events, by: { $0.category })
    }
}