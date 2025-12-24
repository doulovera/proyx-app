import Foundation

final class EventsService {
    private let client: APIClient
    private let encoder = JSONEncoder()

    init(client: APIClient) {
        self.client = client
    }

    func list(limit: Int = 20, offset: Int = 0) async throws -> [Event] {
        let endpoint = Endpoint(
            path: "/api/events",
            queryItems: [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        )
        return try await client.send(endpoint, decodeTo: [Event].self)
    }

    func featured() async throws -> [Event] {
        let endpoint = Endpoint(path: "/api/events/featured")
        return try await client.send(endpoint, decodeTo: [Event].self)
    }

    func upcoming() async throws -> [Event] {
        let endpoint = Endpoint(path: "/api/events/upcoming")
        return try await client.send(endpoint, decodeTo: [Event].self)
    }

    func category(_ category: EventCategory, limit: Int = 20) async throws -> [Event] {
        let endpoint = Endpoint(
            path: "/api/events/category/\(category.rawValue)",
            queryItems: [URLQueryItem(name: "limit", value: "\(limit)")]
        )
        return try await client.send(endpoint, decodeTo: [Event].self)
    }

    func detail(id: UUID) async throws -> Event {
        let endpoint = Endpoint(path: "/api/events/\(id.uuidString)")
        return try await client.send(endpoint, decodeTo: Event.self)
    }

    func search(category: EventCategory? = nil, query: String? = nil, limit: Int = 20) async throws -> [Event] {
        var requestBody: [String: Any] = ["limit": limit]
        if let category {
            requestBody["category"] = category.rawValue
        }
        if let query, !query.isEmpty {
            requestBody["query"] = query
        }
        let data = try JSONSerialization.data(withJSONObject: requestBody)
        let endpoint = Endpoint(path: "/api/events/search", method: .post, body: data)
        return try await client.send(endpoint, decodeTo: [Event].self)
    }

    func purchase(eventID: UUID, request: TicketPurchaseRequestDTO) async throws -> PurchaseResponseDTO {
        let data = try encoder.encode(request)
        let endpoint = Endpoint(
            path: "/api/events/\(eventID.uuidString)/purchase",
            method: .post,
            body: data,
            requiresAuth: true
        )
        return try await client.send(endpoint, decodeTo: PurchaseResponseDTO.self)
    }
}
