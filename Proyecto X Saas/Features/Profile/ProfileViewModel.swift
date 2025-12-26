import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var errorMessage: String?
    
    private let session: SessionStore
    
    init(session: SessionStore) {
        self.session = session
    }
    
    // MARK: - Computed Properties (from session.user)
    
    var fullName: String {
        session.user?.fullName ?? "Usuario"
    }
    
    var memberSince: String {
        guard let date = session.user?.memberSince else { return "---" }
        return Self.memberSinceDateFormatter.string(from: date)
    }
    
    var memberId: String {
        guard let id = session.user?.id else { return "--------" }
        return String(id.uuidString.suffix(8))
    }
    
    var points: Int {
        session.user?.points ?? 0
    }
    
    var membershipLevel: String {
        session.user?.membershipLevel.displayName ?? "Silver"
    }
    
    var currentLevel: MembershipLevel {
        session.user?.membershipLevel ?? .silver
    }
    
    var nextLevelName: String {
        switch currentLevel {
        case .silver: return "Gold"
        case .gold: return "Platinum"
        case .platinum: return "Máximo"
        }
    }
    
    var nextLevelThreshold: Int {
        switch currentLevel {
        case .silver: return 1000
        case .gold: return 2500
        case .platinum: return points
        }
    }
    
    var pointsToNextLevel: Int {
        switch currentLevel {
        case .silver, .gold:
            return max(0, nextLevelThreshold - points)
        case .platinum:
            return 0
        }
    }
    
    var progressFraction: Double {
        switch currentLevel {
        case .silver, .gold:
            return min(1.0, Double(points) / Double(nextLevelThreshold))
        case .platinum:
            return 1.0
        }
    }
    
    // MARK: - Actions
    
    func logout() {
        session.clearSession()
    }
    
    // MARK: - Private
    
    private static let memberSinceDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        f.locale = Locale(identifier: "es_ES")
        return f
    }()
}
