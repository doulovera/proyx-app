import Foundation

final class ProductsService {
    private let client: APIClient
    private let encoder = JSONEncoder()

    init(client: APIClient) {
        self.client = client
    }

    func list(limit: Int = 20, offset: Int = 0) async throws -> [Product] {
        let endpoint = Endpoint(
            path: "/api/products",
            queryItems: [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        )
        return try await client.send(endpoint, decodeTo: [Product].self)
    }

    func featured() async throws -> [Product] {
        let endpoint = Endpoint(path: "/api/products/featured")
        return try await client.send(endpoint, decodeTo: [Product].self)
    }

    func deals() async throws -> [Product] {
        let endpoint = Endpoint(path: "/api/products/deals")
        return try await client.send(endpoint, decodeTo: [Product].self)
    }

    func trending() async throws -> [Product] {
        let endpoint = Endpoint(path: "/api/products/trending")
        return try await client.send(endpoint, decodeTo: [Product].self)
    }

    func healthy() async throws -> [Product] {
        let endpoint = Endpoint(path: "/api/products/healthy")
        return try await client.send(endpoint, decodeTo: [Product].self)
    }

    func quick() async throws -> [Product] {
        let endpoint = Endpoint(path: "/api/products/quick")
        return try await client.send(endpoint, decodeTo: [Product].self)
    }

    func category(_ category: FoodCategory, limit: Int = 20) async throws -> [Product] {
        let endpoint = Endpoint(
            path: "/api/products/category/\(category.rawValue)",
            queryItems: [URLQueryItem(name: "limit", value: "\(limit)")]
        )
        return try await client.send(endpoint, decodeTo: [Product].self)
    }

    func search(category: FoodCategory? = nil, query: String? = nil, minPrice: Double? = nil, maxPrice: Double? = nil, minRating: Double? = nil, limit: Int = 20) async throws -> [Product] {
        var body: [String: Any] = ["limit": limit]
        if let category, category != .all {
            body["category"] = category.rawValue
        }
        if let query, !query.isEmpty {
            body["query"] = query
        }
        if let minPrice {
            body["minPrice"] = minPrice
        }
        if let maxPrice {
            body["maxPrice"] = maxPrice
        }
        if let minRating {
            body["minRating"] = minRating
        }
        let data = try JSONSerialization.data(withJSONObject: body)
        let endpoint = Endpoint(path: "/api/products/search", method: .post, body: data)
        return try await client.send(endpoint, decodeTo: [Product].self)
    }
}
