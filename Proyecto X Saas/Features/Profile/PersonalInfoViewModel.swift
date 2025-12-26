import Foundation

@MainActor
final class PersonalInfoViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var phone: String = ""
    @Published var address: String = ""
    @Published var zipCode: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // MARK: - Read-only Properties
    var fullName: String {
        sessionStore.user?.fullName ?? ""
    }
    
    var email: String {
        sessionStore.user?.email ?? ""
    }
    
    var dni: String {
        sessionStore.user?.dni ?? ""
    }
    
    var memberSince: String {
        guard let date = sessionStore.user?.memberSince else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - Dependencies
    private let profileService: ProfileService
    private let sessionStore: SessionStore
    
    // MARK: - Initialization
    init(profileService: ProfileService, sessionStore: SessionStore) {
        self.profileService = profileService
        self.sessionStore = sessionStore
        loadUserData()
    }
    
    // MARK: - Methods
    private func loadUserData() {
        guard let user = sessionStore.user else { return }
        phone = user.phone ?? ""
        address = user.address ?? ""
        zipCode = user.zipCode ?? ""
    }
    
    func save() async {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let request = UpdateProfileRequest(
                firstName: nil,
                lastName: nil,
                phone: phone.isEmpty ? nil : phone,
                avatarURL: nil,
                dni: nil,
                address: address.isEmpty ? nil : address,
                zipCode: zipCode.isEmpty ? nil : zipCode
            )
            
            let updatedUser = try await profileService.updateProfile(request: request)
            sessionStore.setUser(updatedUser)
            successMessage = "Información actualizada correctamente"
        } catch {
            errorMessage = "Error al actualizar información: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
