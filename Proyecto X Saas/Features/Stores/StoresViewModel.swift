import Foundation

@MainActor
final class StoresViewModel: ObservableObject {
    @Published var stores: [Store] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentFilter: FoodCategory = .all

    private let service: StoresService

    init(service: StoresService) {
        self.service = service
    }

    var filteredStores: [Store] {
        guard currentFilter != .all else { return stores }
        return stores.filter { $0.category == currentFilter }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            stores = try await service.list(limit: 50)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
