import Foundation

@MainActor
final class AppDependencies: ObservableObject {
    let session: SessionStore
    let authService: AuthService
    let eventsService: EventsService
    let storesService: StoresService
    let productsService: ProductsService
    let profileService: ProfileService

    init(session: SessionStore? = nil) {
        let session = session ?? SessionStore()
        self.session = session
        let client = APIClient { [weak session] in
            session?.token
        }
        self.authService = AuthService(client: client)
        self.eventsService = EventsService(client: client)
        self.storesService = StoresService(client: client)
        self.productsService = ProductsService(client: client)
        self.profileService = ProfileService(client: client)
    }
}
