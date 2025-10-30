import SwiftUI

struct AllEventsViewBackend: View {
    @StateObject private var eventManager = EventManager()
    @State private var selectedCategory: EventCategory? = nil
    @State private var searchText = ""
    @State private var showFreeOnly = false
    @State private var showAvailableOnly = true
    @Environment(\.presentationMode) var presentationMode
    
    var filteredEvents: [Event] {
        var events = eventManager.events
        
        // Filter by category
        if let selectedCategory = selectedCategory {
            events = events.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            events = events.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.organizer.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by free events
        if showFreeOnly {
            events = events.filter { $0.isFree }
        }
        
        // Filter by availability
        if showAvailableOnly {
            events = events.filter { $0.availableTickets > 0 }
        }
        
        return events.sorted {
            return $0.parsedDate < $1.parsedDate
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with filters
                headerSection
                
                // Events list
                if eventManager.isLoading {
                    Spacer()
                    ProgressView("Cargando eventos...")
                        .scaleEffect(1.2)
                    Spacer()
                } else if eventManager.events.isEmpty {
                    Spacer()
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "calendar")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        Text("No hay eventos disponibles")
                            .bodyText()
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        Button("Reintentar") {
                            Task {
                                await eventManager.loadEvents()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.sm) {
                            ForEach(filteredEvents) { event in
                                EventRowBackend(event: event)
                                    .padding(.horizontal, AppTheme.Spacing.md)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.sm)
                    }
                }
            }
            .navigationTitle("Eventos")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .background(AppTheme.Colors.background)
        }
        .task {
            if eventManager.events.isEmpty {
                await eventManager.loadEvents()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            // Search bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    TextField("Buscar eventos...", text: $searchText)
                        .bodyText()
                }
                .padding(AppTheme.Spacing.sm)
                .background(AppTheme.Colors.fillColor)
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            // Filters
            HStack(spacing: AppTheme.Spacing.sm) {
                Button(action: {
                    showFreeOnly.toggle()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: showFreeOnly ? "checkmark.circle.fill" : "circle")
                        Text("Gratis")
                            .captionText()
                    }
                    .foregroundColor(showFreeOnly ? AppTheme.Colors.accent : AppTheme.Colors.secondaryText)
                }
                
                Button(action: {
                    showAvailableOnly.toggle()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: showAvailableOnly ? "checkmark.circle.fill" : "circle")
                        Text("Disponibles")
                            .captionText()
                    }
                    .foregroundColor(showAvailableOnly ? AppTheme.Colors.accent : AppTheme.Colors.secondaryText)
                }
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            // Categories filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    // All categories button
                    Button(action: {
                        selectedCategory = nil
                    }) {
                        Text("Todos")
                            .chipStyle(isSelected: selectedCategory == nil)
                    }
                    
                    ForEach(EventCategory.allCases, id: \.self) { category in
                        EventCategoryFilterChip(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
            }
            
            // Results count
            HStack {
                Text("\(filteredEvents.count) eventos encontrados")
                    .captionText()
                    .foregroundColor(AppTheme.Colors.secondaryText)
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.md)
        }
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.Colors.background)
    }
}

struct EventCategoryFilterChip: View {
    let category: EventCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: category.icon)
                Text(category.rawValue)
            }
            .chipStyle(isSelected: isSelected)
        }
    }
}


#Preview {
    AllEventsViewBackend()
}
