import SwiftUI

struct HomeViewBackend: View {
    @StateObject private var storeManager = StoreManager()
    @StateObject private var eventManager = EventManager()
    @StateObject private var productManager = ProductManager()
    @ObservedObject private var networkManager = NetworkManager.shared
    
    @State private var selectedCategory: ProductCategory = .alimentos
    @State private var showAllStores = false
    @State private var showAllEvents = false
    @State private var searchText = ""
    @State private var errorMessage: String? // Added for error display
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Search
                searchSection
                
                // Contenido scrolleable
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        categoriesSection
                        featuredEventsSection
                        featuredStoresSection
                        quickProductsSection
                    }
                    .padding(.vertical, AppTheme.Spacing.md)
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .onAppear {
                // Wrap async calls in a Task
                Task {
                    await loadData()
                }
            }
            .sheet(isPresented: $showAllStores) {
                AllStoresViewBackend(selectedCategory: selectedCategory)
            }
            .sheet(isPresented: $showAllEvents) {
                AllEventsViewBackend()
            }
            // Display error message if any
            .alert("Error", isPresented: Binding(get: { errorMessage != nil }, set: { _ in errorMessage = nil })) {
                Button("OK") { }
            } message: {
                Text(errorMessage ?? "An unknown error occurred.")
            }
        }
    }
    
    // Corrected loadData function to properly handle concurrent loading
    private func loadData() async {
        errorMessage = nil // Clear previous errors
        
        // Execute all loading operations concurrently
        async let storesLoad: () = storeManager.loadStores()
        async let eventsLoad: () = eventManager.loadEvents()
        async let productsLoad: () = productManager.loadProducts()
        
        // Await all operations to complete
        _ = await (storesLoad, eventsLoad, productsLoad)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("¡Bienvenido!")
                    .captionText()
                
                if let user = networkManager.currentUser {
                    Text("Hola, \(user.firstName)")
                        .sectionHeader()
                } else {
                    Text("Proyecto X SaaS")
                        .sectionHeader()
                }
            }
            
            Spacer()
            
            if let user = networkManager.currentUser {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(user.points) pts")
                        .captionText()
                        .fontWeight(.semibold)
                    
                    Text(user.membershipLevel.rawValue)
                        .captionText()
                        .foregroundColor(Color(user.membershipLevel.color))
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private var searchSection: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                TextField("Buscar tiendas, productos...", text: $searchText)
                    .bodyText()
            }
            .padding(AppTheme.Spacing.sm)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
            
            Button(action: {
                // TODO: Implementar filtros
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(AppTheme.Colors.primary)
                    .padding(AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.cardBackground)
                    .cornerRadius(AppTheme.CornerRadius.medium)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.md)
    }
    
    private var categoriesSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Text("Categorías")
                    .sectionHeader()
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(ProductCategory.allCases, id: \.self) { category in
                        CategoryCard(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                            Task {
                                await storeManager.searchStores(category: category)
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
    
    private var featuredEventsSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Text("Eventos Destacados")
                    .sectionHeader()
                Spacer()
                Button("Ver todos") {
                    showAllEvents = true
                }
                .captionText()
                .foregroundColor(AppTheme.Colors.primary)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            if eventManager.isLoading {
                ProgressView("Cargando eventos...")
                    .padding()
            } else if eventManager.events.isEmpty {
                Text("No hay eventos disponibles")
                    .bodyText()
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(Array(eventManager.upcomingEvents.prefix(5))) { event in
                            EventCardBackend(event: event)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
        }
    }
    
    private var featuredStoresSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Text("Tiendas Populares")
                    .sectionHeader()
                Spacer()
                Button("Ver todas") {
                    showAllStores = true
                }
                .captionText()
                .foregroundColor(AppTheme.Colors.primary)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            if storeManager.isLoading {
                ProgressView("Cargando tiendas...")
                    .padding()
            } else if storeManager.stores.isEmpty {
                Text("No hay tiendas disponibles")
                    .bodyText()
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(Array(storeManager.featuredStores)) { store in
                            StoreCardBackend(store: store)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
        }
    }
    
    private var quickProductsSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Text("Preparación Rápida")
                    .sectionHeader()
                Spacer()
                Button("Ver más") {
                    // TODO: Navigate to products view
                }
                .captionText()
                .foregroundColor(AppTheme.Colors.primary)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            if productManager.isLoading {
                ProgressView("Cargando productos...")
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        ForEach(Array(productManager.quickProducts.prefix(5))) { product in
                            ProductCardBackend(product: product)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
        }
    }
}

// MARK: - Event Card Component

struct EventCardBackend: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            // Date badge
            HStack {
                Text(event.dateText)
                    .captionText()
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, AppTheme.Spacing.xs)
                    .padding(.vertical, 2)
                    .background(Color(event.category.color))
                    .cornerRadius(AppTheme.CornerRadius.small)
                
                Spacer()
                
                if event.isFree {
                    Text("GRATIS")
                        .captionText()
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            
            Text(event.title)
                .bodyText()
                .fontWeight(.semibold)
                .lineLimit(2)
            
            Text(event.description)
                .captionText()
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineLimit(2)
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(event.time)
                }
                .captionText()
                .foregroundColor(AppTheme.Colors.secondaryText)
                
                Spacer()
                
                if !event.isFree {
                    Text(event.priceText)
                        .bodyText()
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.primary)
                }
            }
            
            // Availability
            Text("\(event.availableTickets) disponibles")
                .captionText()
                .foregroundColor(event.availableTickets > 0 ? .green : .red)
        }
        .padding(AppTheme.Spacing.sm)
        .frame(width: 200)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(color: AppTheme.Shadow.small.color, radius: AppTheme.Shadow.small.radius, x: AppTheme.Shadow.small.x, y: AppTheme.Shadow.small.y)
    }
}

// MARK: - Store Card Component

struct StoreCardBackend: View {
    let store: ProductStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            // Store status and category
            HStack {
                Image(systemName: "storefront")
                    .font(.title3)
                
                Spacer()
                
                Circle()
                    .fill(store.isOpen ? .green : .red)
                    .frame(width: 8, height: 8)
            }
            
            Text(store.name)
                .bodyText()
                .fontWeight(.semibold)
                .lineLimit(1)
            
            Text(store.description)
                .captionText()
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineLimit(2)
            
            HStack {
                // Rating
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", store.rating))
                        .captionText()
                }
                
                Spacer()
                
                // Price range
                Text(store.priceRangeText)
                    .captionText()
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            // Delivery time
            HStack {
                Image(systemName: "clock")
                    .font(.caption)
                Text(store.deliveryTime)
                    .captionText()
            }
            .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .padding(AppTheme.Spacing.sm)
        .frame(width: 160)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(color: AppTheme.Shadow.small.color, radius: AppTheme.Shadow.small.radius, x: AppTheme.Shadow.small.x, y: AppTheme.Shadow.small.y)
    }
}

// MARK: - Product Card Component

struct ProductCardBackend: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            // Badges
            HStack {
                if product.hasDiscount {
                    Text("-\(product.discountPercentage ?? 0)%")
                        .captionText()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, AppTheme.Spacing.xs)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(AppTheme.CornerRadius.small)
                }
                
                Spacer()
                
                if product.isSponsored {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                }
            }
            
            Text(product.name)
                .bodyText()
                .fontWeight(.semibold)
                .lineLimit(2)
            
            // Dietary tags
            if !product.dietaryTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(product.dietaryTags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(4)
                        }
                    }
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.priceText)
                        .bodyText()
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.primary)
                    
                    if let originalPrice = product.originalPrice, product.hasDiscount {
                        Text(String(format: "€%.2f", originalPrice))
                            .captionText()
                            .strikethrough()
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(product.preparationTime)
                        .captionText()
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    if let calories = product.caloriesText {
                        Text(calories)
                            .font(.caption2)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.sm)
        .frame(width: 140)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(color: AppTheme.Shadow.small.color, radius: AppTheme.Shadow.small.radius, x: AppTheme.Shadow.small.x, y: AppTheme.Shadow.small.y)
    }
}

#Preview {
    HomeViewBackend()
}
