import Foundation

struct UpdateProfileRequest: Codable {
    let firstName: String
    let lastName: String
    let phone: String?
    let avatarURL: String?
}

struct ChangePasswordRequest: Codable {
    let currentPassword: String
    let newPassword: String
    let confirmPassword: String
}

struct UpdateMembershipRequest: Codable {
    let membershipLevel: MembershipLevel
}

struct AddPointsRequest: Codable {
    let points: Int
    let reason: String?
}

final class ProfileService {
    private let client: APIClient
    private let encoder = JSONEncoder()

    init(client: APIClient) {
        self.client = client
    }

    func profile() async throws -> UserProfile {
        let endpoint = Endpoint(path: "/api/users/profile", requiresAuth: true)
        return try await client.send(endpoint, decodeTo: UserProfile.self)
    }

    func updateProfile(request: UpdateProfileRequest) async throws -> UserProfile {
        let data = try encoder.encode(request)
        let endpoint = Endpoint(path: "/api/users/profile", method: .put, body: data, requiresAuth: true)
        return try await client.send(endpoint, decodeTo: UserProfile.self)
    }

    func changePassword(current: String, new: String, confirm: String) async throws {
        let payload = ChangePasswordRequest(currentPassword: current, newPassword: new, confirmPassword: confirm)
        let data = try encoder.encode(payload)
        let endpoint = Endpoint(path: "/api/users/change-password", method: .put, body: data, requiresAuth: true)
        try await client.send(endpoint)
    }

    func updateMembership(level: MembershipLevel) async throws -> UserProfile {
        let data = try encoder.encode(UpdateMembershipRequest(membershipLevel: level))
        let endpoint = Endpoint(path: "/api/users/membership", method: .put, body: data, requiresAuth: true)
        return try await client.send(endpoint, decodeTo: UserProfile.self)
    }

    func points() async throws -> PointsResponse {
        let endpoint = Endpoint(path: "/api/users/points", requiresAuth: true)
        return try await client.send(endpoint, decodeTo: PointsResponse.self)
    }

    func addPoints(points: Int, reason: String?) async throws -> PointsResponse {
        let data = try encoder.encode(AddPointsRequest(points: points, reason: reason))
        let endpoint = Endpoint(path: "/api/users/points/add", method: .post, body: data, requiresAuth: true)
        return try await client.send(endpoint, decodeTo: PointsResponse.self)
    }

    func deleteAccount() async throws {
        let endpoint = Endpoint(path: "/api/users/account", method: .delete, requiresAuth: true)
        try await client.send(endpoint)
    }
}
