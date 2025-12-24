import Foundation

@MainActor
final class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedFilter: EventFilter = .today
    @Published var query: String = ""

    private let eventsService: EventsService

    init(eventsService: EventsService) {
        self.eventsService = eventsService
    }

    func loadInitial() async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await eventsService.list()
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func search() async {
        guard !query.isEmpty else {
            await loadInitial()
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            events = try await eventsService.search(category: nil, query: query)
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func filteredEvents(isToday: Bool, isThisWeek: Bool, isFree: Bool, isGastronomic: Bool) -> [Event] {
        events.filter { event in
            if isToday { return event.isToday }
            if isThisWeek { return event.isThisWeek }
            if isFree { return event.isFree }
            if isGastronomic { return event.category == .gastronomico }
            return true
        }
    }
}
