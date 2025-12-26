import SwiftUI

struct EventsView: View {
    let dependencies: AppDependencies
    @StateObject private var viewModel: EventsViewModel
    @State private var selectedEvent: Event?
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: EventsViewModel(eventsService: dependencies.eventsService))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Contenido fijo (header y búsqueda)
                headerSection
                searchSection
                
                // Contenido scrolleable
                ScrollView {
                    VStack(spacing: 0) {
                        recommendedSection
                        filterSection
                        eventsSection
                    }
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
            .task {
                await viewModel.loadInitial()
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("Eventos locales")
                    .captionText()
                Text("Descubre experiencias")
                    .sectionHeader()
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "cart")
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .font(AppTheme.Typography.title3)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.lg)
        .background(AppTheme.Colors.background)
    }
    
    private var searchSection: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Colors.secondaryText)
                Text("Buscar eventos")
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .font(AppTheme.Typography.body)
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.fillColor)
            .cornerRadius(AppTheme.CornerRadius.small)
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.lg)
            
            // Separador sutil
            Rectangle()
                .fill(AppTheme.Colors.separatorColor)
                .frame(height: 0.5)
                .opacity(0.5)
        }
        .background(AppTheme.Colors.background)
    }
    
    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Eventos Recomendados")
                .sectionHeader()
                .padding(.horizontal, AppTheme.Spacing.xl)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(recommendedEvents) { event in
                        RecommendedEventCard(event: event) {
                            selectedEvent = event
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxl)
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(EventFilter.allCases, id: \.self) { filter in
                    EventFilterChip(
                        text: filter.displayName,
                        isSelected: viewModel.selectedFilter == filter
                    ) {
                        viewModel.selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .padding(.bottom, AppTheme.Spacing.xxl)
    }
    
    private var eventsSection: some View {
        LazyVStack(spacing: AppTheme.Spacing.md) {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.vertical, AppTheme.Spacing.xxxl)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.vertical, AppTheme.Spacing.xxxl)
            } else if viewModel.filteredEvents(isToday: viewModel.selectedFilter == .today,
                                               isThisWeek: viewModel.selectedFilter == .thisWeek,
                                               isFree: viewModel.selectedFilter == .free,
                                               isGastronomic: viewModel.selectedFilter == .gastronomic).isEmpty {
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    Text("No hay eventos disponibles")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    Text("Prueba con otro filtro")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                .padding(.vertical, AppTheme.Spacing.xxxl)
            } else {
                ForEach(viewModel.filteredEvents(isToday: viewModel.selectedFilter == .today,
                                                 isThisWeek: viewModel.selectedFilter == .thisWeek,
                                                 isFree: viewModel.selectedFilter == .free,
                                                 isGastronomic: viewModel.selectedFilter == .gastronomic)) { event in
                    EventCard(event: event) {
                        selectedEvent = event
                    }
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
    
    private var recommendedEvents: [Event] {
        return viewModel.events.filter { ($0.isSponsored ?? false) }.prefix(4).map { $0 }
    }
}

enum EventFilter: CaseIterable {
    case today
    case thisWeek
    case free
    case gastronomic
    case all
    
    var displayName: String {
        switch self {
        case .today:
            return "HOY"
        case .thisWeek:
            return "ESTA SEMANA"
        case .free:
            return "GRATIS"
        case .gastronomic:
            return "GASTRONÓMICOS"
        case .all:
            return "TODOS"
        }
    }
}

struct EventFilterChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .chipStyle(isSelected: isSelected)
        }
    }
}

struct EventCard: View {
    let event: Event
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .center, spacing: AppTheme.Spacing.xs) {
                Text(event.dateText.components(separatedBy: " ")[0])
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.primaryText)
                Text(event.dateText.components(separatedBy: " ")[1])
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                Text(event.time ?? "-")
                    .font(AppTheme.Typography.caption2)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    Text(event.category.rawValue)
                        .font(AppTheme.Typography.caption1)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(AppTheme.Colors.fillColor)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    
                    Spacer()
                    
                    Text(event.displayPrice)
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(event.isFree ? AppTheme.Colors.success : AppTheme.Colors.primaryText)
                }
                
                Text(event.title)
                    .sectionHeader()
                
                Text(event.description ?? "")
                    .bodyText()
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "location")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                    Text(event.location ?? "-")
                        .captionText()
                    
                    Spacer()
                    
                    Button("Ver detalles") {
                        action()
                    }
                    .font(AppTheme.Typography.buttonSmall)
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .background(AppTheme.Colors.brandPrimary)
                    .foregroundColor(AppTheme.Colors.background)
                    .cornerRadius(AppTheme.CornerRadius.small)
                }
                
                let available = event.availableTickets ?? 0
                if available < 10 && available > 0 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.warning)
                        Text("¡Solo quedan \(available) entradas!")
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.warning)
                        Spacer()
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .cardStyle()
    }
}

struct RecommendedEventCard: View {
    let event: Event
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                LinearGradient(
                    colors: [AppTheme.Colors.brandPrimary.opacity(0.8), AppTheme.Colors.secondaryText.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 140)
                .cornerRadius(AppTheme.CornerRadius.medium)
                
                VStack(spacing: AppTheme.Spacing.sm) {
                    if event.isSponsored ?? false {
                        HStack {
                            Text("PATROCINADO")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(Color.yellow)
                                .padding(.horizontal, AppTheme.Spacing.sm)
                                .padding(.vertical, AppTheme.Spacing.xs)
                                .background(AppTheme.Colors.brandPrimary.opacity(0.6))
                                .cornerRadius(AppTheme.CornerRadius.small)
                            Spacer()
                        }
                        .padding(.top, AppTheme.Spacing.sm)
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }
                    
                    Spacer()
                    
                    Image(systemName: event.category.icon)
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.background)
                    
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs / 2) {
                        Text(event.dateText)
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        Text(event.time ?? "-")
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                    
                    Spacer()
                    
                    Text(event.displayPrice)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                Text(event.title)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineLimit(2)
                
                Text(event.description ?? "")
                    .captionText()
                    .lineLimit(2)
                
                let available = event.availableTickets ?? 0
                if available < 20 && available > 0 {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(.orange)
                        Text("Solo quedan \(available) entradas")
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, AppTheme.Spacing.sm)
                    .padding(.vertical, AppTheme.Spacing.xs)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.small)
                }
                
                Button("Ver detalles") {
                    action()
                }
                .font(AppTheme.Typography.buttonSmall)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.brandPrimary)
                .foregroundColor(AppTheme.Colors.background)
                .cornerRadius(AppTheme.CornerRadius.small)
            }
            .padding(AppTheme.Spacing.md)
        }
        .frame(width: 220)
        .cardStyle()
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    EventsView(dependencies: AppDependencies())
}
