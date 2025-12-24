import Foundation

final class StoresService {
    private let client: APIClient
    private let encoder = JSONEncoder()

    init(client: APIClient) {
        self.client = client
    }

    func list(limit: Int = 20, offset: Int = 0) async throws -> [Store] {
        let endpoint = Endpoint(
            path: "/api/stores",
            queryItems: [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        )
        return try await client.send(endpoint, decodeTo: [Store].self)
    }

    func featured() async throws -> [Store] {
        let endpoint = Endpoint(path: "/api/stores/featured")
        return try await client.send(endpoint, decodeTo: [Store].self)
    }

    func openNow() async throws -> [Store] {
        let endpoint = Endpoint(path: "/api/stores/open")
        return try await client.send(endpoint, decodeTo: [Store].self)
    }

    func category(_ category: FoodCategory, limit: Int = 20) async throws -> [Store] {
        let endpoint = Endpoint(
            path: "/api/stores/category/\(category.rawValue)",
            queryItems: [URLQueryItem(name: "limit", value: "\(limit)")]
        )
        return try await client.send(endpoint, decodeTo: [Store].self)
    }

    func search(category: FoodCategory? = nil, isOpen: Bool? = nil, minRating: Double? = nil, limit: Int = 20) async throws -> [Store] {
        var body: [String: Any] = ["limit": limit]
        if let category, category != .all {
            body["category"] = category.rawValue
        }
        if let isOpen {
            body["isOpen"] = isOpen
        }
        if let minRating {
            body["minRating"] = minRating
        }
        let data = try JSONSerialization.data(withJSONObject: body)
        let endpoint = Endpoint(path: "/api/stores/search", method: .post, body: data)
        return try await client.send(endpoint, decodeTo: [Store].self)
    }
}
