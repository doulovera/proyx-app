import Foundation

struct AuthResponse: Codable {
    let user: UserProfile
    let token: String
}

struct UserProfile: Codable {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let phone: String?
    let avatarURL: String?
    let membershipLevel: MembershipLevel
    let points: Int
    let memberSince: Date?
    let emailVerified: Bool
    let createdAt: Date?
    let dni: String?
    let address: String?
    let zipCode: String?

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

enum MembershipLevel: String, Codable, CaseIterable {
    case silver
    case gold
    case platinum

    var displayName: String {
        rawValue.capitalized
    }
}

struct PointsResponse: Codable {
    let points: Int
}
