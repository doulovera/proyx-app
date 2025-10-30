import Foundation
import Combine

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let baseURL = "http://localhost:8080"
    
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    
    var authToken: String? {
        get {
            UserDefaults.standard.string(forKey: "auth_token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "auth_token")
        }
    }
    
    private init() {
        // Check if user is already logged in
        if authToken != nil {
            isLoggedIn = true
        }
    }
    
    // MARK: - Authentication
    
    func login(email: String, password: String) async throws -> User {
        let loginData = LoginRequest(email: email, password: password)
        let request = try createRequest(
            endpoint: "/api/users/login",
            method: "POST",
            body: loginData
        )
        
        let response: LoginResponse = try await performRequest(request)
        
        // Save token and user data
        authToken = response.token
        isLoggedIn = true
        currentUser = response.user
        
        return response.user
    }
    
    func register(email: String, password: String, confirmPassword: String, firstName: String, lastName: String, phone: String? = nil) async throws -> User {
        let registerData = RegisterRequest(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            firstName: firstName,
            lastName: lastName,
            phone: phone
        )
        
        let request = try createRequest(
            endpoint: "/api/users/register",
            method: "POST",
            body: registerData
        )
        
        let response: LoginResponse = try await performRequest(request)
        
        // Save token and user data
        authToken = response.token
        isLoggedIn = true
        currentUser = response.user
        
        return response.user
    }
    
    func logout() {
        authToken = nil
        isLoggedIn = false
        currentUser = nil
    }
    
    // MARK: - Events
    
    func fetchEvents() async throws -> [Event] {
        let request = try createRequest(endpoint: "/api/events", method: "GET")
        let events: [Event] = try await performRequest(request)
        return events
    }
    
    func fetchEvent(id: String) async throws -> Event {
        let request = try createRequest(endpoint: "/api/events/\(id)", method: "GET")
        let event: Event = try await performRequest(request)
        return event
    }
    
    func searchEvents(category: String? = nil, location: String? = nil, minPrice: Double? = nil, maxPrice: Double? = nil) async throws -> [Event] {
        var queryItems: [URLQueryItem] = []
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        if let location = location {
            queryItems.append(URLQueryItem(name: "location", value: location))
        }
        if let minPrice = minPrice {
            queryItems.append(URLQueryItem(name: "minPrice", value: String(minPrice)))
        }
        if let maxPrice = maxPrice {
            queryItems.append(URLQueryItem(name: "maxPrice", value: String(maxPrice)))
        }
        
        let request = try createRequest(endpoint: "/api/events/search", method: "GET", queryItems: queryItems)
        let events: [Event] = try await performRequest(request)
        return events
    }
    
    // MARK: - Stores
    
    func fetchStores() async throws -> [ProductStore] {
        let request = try createRequest(endpoint: "/api/stores", method: "GET")
        let stores: [ProductStore] = try await performRequest(request)
        return stores
    }
    
    func fetchStore(id: String) async throws -> ProductStore {
        let request = try createRequest(endpoint: "/api/stores/\(id)", method: "GET")
        let store: ProductStore = try await performRequest(request)
        return store
    }
    
    func searchStores(category: String? = nil, isOpen: Bool? = nil, latitude: Double? = nil, longitude: Double? = nil, radius: Double? = nil) async throws -> [ProductStore] {
        var queryItems: [URLQueryItem] = []
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        if let isOpen = isOpen {
            queryItems.append(URLQueryItem(name: "isOpen", value: String(isOpen)))
        }
        if let latitude = latitude {
            queryItems.append(URLQueryItem(name: "latitude", value: String(latitude)))
        }
        if let longitude = longitude {
            queryItems.append(URLQueryItem(name: "longitude", value: String(longitude)))
        }
        if let radius = radius {
            queryItems.append(URLQueryItem(name: "radius", value: String(radius)))
        }
        
        let request = try createRequest(endpoint: "/api/stores/search", method: "GET", queryItems: queryItems)
        let stores: [ProductStore] = try await performRequest(request)
        return stores
    }
    
    // MARK: - Products
    
    func fetchProducts() async throws -> [Product] {
        let request = try createRequest(endpoint: "/api/products", method: "GET")
        let products: [Product] = try await performRequest(request)
        return products
    }
    
    func fetchProduct(id: String) async throws -> Product {
        let request = try createRequest(endpoint: "/api/products/\(id)", method: "GET")
        let product: Product = try await performRequest(request)
        return product
    }
    
    func searchProducts(category: String? = nil, isVegan: Bool? = nil, isGlutenFree: Bool? = nil, isOrganic: Bool? = nil, maxCalories: Int? = nil) async throws -> [Product] {
        var queryItems: [URLQueryItem] = []
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        if let isVegan = isVegan {
            queryItems.append(URLQueryItem(name: "isVegan", value: String(isVegan)))
        }
        if let isGlutenFree = isGlutenFree {
            queryItems.append(URLQueryItem(name: "isGlutenFree", value: String(isGlutenFree)))
        }
        if let isOrganic = isOrganic {
            queryItems.append(URLQueryItem(name: "isOrganic", value: String(isOrganic)))
        }
        if let maxCalories = maxCalories {
            queryItems.append(URLQueryItem(name: "maxCalories", value: String(maxCalories)))
        }
        
        let request = try createRequest(endpoint: "/api/products/search", method: "GET", queryItems: queryItems)
        let products: [Product] = try await performRequest(request)
        return products
    }
    
    func fetchProductsByStore(storeId: String) async throws -> [Product] {
        let request = try createRequest(endpoint: "/api/stores/\(storeId)/products", method: "GET")
        let products: [Product] = try await performRequest(request)
        return products
    }
    
    // MARK: - Helper Methods
    
    private func createRequest<T: Codable>(
        endpoint: String,
        method: String,
        body: T? = nil,
        queryItems: [URLQueryItem]? = nil
    ) throws -> URLRequest {
        var components = URLComponents(string: baseURL + endpoint)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication header if available
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if provided
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
    
    private func createRequest(
        endpoint: String,
        method: String,
        queryItems: [URLQueryItem]? = nil
    ) throws -> URLRequest {
        var components = URLComponents(string: baseURL + endpoint)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication header if available
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func performRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            if let errorData = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw NetworkError.serverError(errorData.reason)
            } else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            throw NetworkError.decodingError
        }
    }
}

// MARK: - Network Models
// Note: LoginRequest, RegisterRequest, LoginResponse are now in BackendModels.swift

struct ErrorResponse: Codable {
    let error: Bool
    let reason: String
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case serverError(String)
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        case .noData:
            return "No se recibieron datos"
        case .decodingError:
            return "Error al procesar los datos"
        case .serverError(let message):
            return message
        case .httpError(let code):
            return "Error del servidor (\(code))"
        }
    }
}