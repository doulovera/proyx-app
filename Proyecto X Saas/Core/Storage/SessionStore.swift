import Foundation
import Combine

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var user: UserProfile?
    @Published private(set) var token: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let tokenStore: TokenStore
    private var cancellables = Set<AnyCancellable>()

    init(tokenStore: TokenStore = .shared) {
        self.tokenStore = tokenStore
        self.token = tokenStore.load()
    }

    var isAuthenticated: Bool {
        !(token ?? "").isEmpty
    }

    func setSession(user: UserProfile, token: String) {
        self.user = user
        self.token = token
        tokenStore.save(token: token)
    }

    func clearSession() {
        user = nil
        token = nil
        tokenStore.clear()
    }
}
