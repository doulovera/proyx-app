import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var featuredEvents: [Event] = []
    @Published var upcomingEvents: [Event] = []
    @Published var featuredStores: [Store] = []
    @Published var trendingProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let eventsService: EventsService
    private let storesService: StoresService
    private let productsService: ProductsService

    init(eventsService: EventsService, storesService: StoresService, productsService: ProductsService) {
        self.eventsService = eventsService
        self.storesService = storesService
        self.productsService = productsService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            async let featured = eventsService.featured()
            async let upcoming = eventsService.upcoming()
            async let stores = storesService.featured()
            async let trending = productsService.trending()

            featuredEvents = try await featured
            upcomingEvents = try await upcoming
            featuredStores = try await stores
            trendingProducts = try await trending
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
