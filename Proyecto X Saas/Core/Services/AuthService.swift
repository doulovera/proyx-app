import Foundation

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
}

final class AuthService {
    private let client: APIClient
    private let encoder = JSONEncoder()

    init(client: APIClient) {
        self.client = client
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let payload = LoginRequest(email: email, password: password)
        let data = try encoder.encode(payload)
        let endpoint = Endpoint(
            path: "/api/users/login",
            method: .post,
            body: data
        )
        return try await client.send(endpoint, decodeTo: AuthResponse.self)
    }

    func register(request: RegisterRequest) async throws -> AuthResponse {
        let data = try encoder.encode(request)
        let endpoint = Endpoint(
            path: "/api/users/register",
            method: .post,
            body: data
        )
        return try await client.send(endpoint, decodeTo: AuthResponse.self)
    }
}
