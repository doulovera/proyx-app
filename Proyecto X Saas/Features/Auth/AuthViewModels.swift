import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthService
    private let session: SessionStore

    init(authService: AuthService, session: SessionStore) {
        self.authService = authService
        self.session = session
    }

    func login() async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await authService.login(email: email, password: password)
            session.setSession(user: response.user, token: response.token)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthService
    private let session: SessionStore

    init(authService: AuthService, session: SessionStore) {
        self.authService = authService
        self.session = session
    }

    func signUp() async {
        isLoading = true
        errorMessage = nil
        let request = RegisterRequest(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            firstName: firstName,
            lastName: lastName,
            phone: phone.isEmpty ? nil : phone
        )

        do {
            let response = try await authService.register(request: request)
            session.setSession(user: response.user, token: response.token)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
