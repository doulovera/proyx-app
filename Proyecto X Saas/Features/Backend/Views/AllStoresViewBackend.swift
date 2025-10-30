import SwiftUI

struct AllStoresViewBackend: View {
    @StateObject private var storeManager = StoreManager()
    @State private var selectedCategory: ProductCategory
    @State private var searchText = ""
    @State private var showOpenOnly = false
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedCategory: ProductCategory = .alimentos) {
        _selectedCategory = State(initialValue: selectedCategory)
    }
    
    var filteredStores: [ProductStore] {
        var stores = storeManager.stores
        
        // Filter by category
        if selectedCategory != .alimentos { // Using alimentos as "all" for now
            stores = stores.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            stores = stores.filter { store in
                store.name.localizedCaseInsensitiveContains(searchText) ||
                store.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Filter by open status
        if showOpenOnly {
            stores = stores.filter { $0.isOpen }
        }
        
        return stores.sorted { $0.rating > $1.rating }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with filters
                headerSection
                
                // Stores list
                if storeManager.isLoading {
                    Spacer()
                    ProgressView("Cargando tiendas...")
                        .scaleEffect(1.2)
                    Spacer()
                } else if storeManager.stores.isEmpty {
                    Spacer()
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: "storefront")
                            .font(.system(size: 50))
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        Text("No hay tiendas disponibles")
                            .bodyText()
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        Button("Reintentar") {
                            Task {
                                await storeManager.loadStores()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppTheme.Spacing.sm) {
                            ForEach(filteredStores) { store in
                                StoreRowBackend(store: store)
                                    .padding(.horizontal, AppTheme.Spacing.md)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.sm)
                    }
                }
            }
            .navigationTitle("Tiendas")
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
        .onAppear {
            if storeManager.stores.isEmpty {
                Task {
                    await storeManager.loadStores()
                }
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
                    
                    TextField("Buscar tiendas...", text: $searchText)
                        .bodyText()
                }
                .padding(AppTheme.Spacing.sm)
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.CornerRadius.medium)
                
                Button(action: {
                    showOpenOnly.toggle()
                }) {
                    Image(systemName: showOpenOnly ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(AppTheme.Colors.primary)
                        .font(.title2)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            // Toggle for open stores
            if showOpenOnly {
                HStack {
                    Text("Solo tiendas abiertas")
                        .captionText()
                        .foregroundColor(AppTheme.Colors.primary)
                    Spacer()
                }
                .padding(.horizontal, AppTheme.Spacing.md)
            }
            
            // Categories filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(ProductCategory.allCases, id: \.self) { category in
                        StoreCategoryFilterChip(
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
                Text("\(filteredStores.count) tiendas encontradas")
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

struct StoreCategoryFilterChip: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(category.icon)
                    .font(.caption)
                Text(category.displayName)
                    .captionText()
            }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.cardBackground)
            .foregroundColor(isSelected ? .white : AppTheme.Colors.primaryText)
            .cornerRadius(AppTheme.CornerRadius.large)
        }
    }
}

struct StoreRowBackend: View {
    let store: ProductStore
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            // Store icon and status
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.Colors.cardBackground)
                        .frame(width: 60, height: 60)
                    
                    Text(store.category.icon)
                        .font(.title2)
                }
                
                Circle()
                    .fill(store.isOpen ? .green : .red)
                    .frame(width: 8, height: 8)
            }
            
            // Store info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(store.name)
                        .bodyText()
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(store.priceRangeText)
                        .captionText()
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppTheme.Colors.cardBackground)
                        .cornerRadius(4)
                }
                
                Text(store.description)
                    .captionText()
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .lineLimit(2)
                
                HStack(spacing: AppTheme.Spacing.md) {
                    // Rating
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", store.rating))
                            .captionText()
                        Text("(\(store.reviewCount))")
                            .captionText()
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    
                    // Delivery time
                    HStack(spacing: 2) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(store.deliveryTime)
                            .captionText()
                    }
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Spacer()
                    
                    // Status
                    Text(store.statusText)
                        .captionText()
                        .foregroundColor(store.isOpen ? .green : .red)
                        .fontWeight(.medium)
                }
                
                // Specialties
                if !store.specialties.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(store.specialties.prefix(3), id: \.self) { specialty in
                                Text(specialty)
                                    .font(.caption2)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }
            
            // Navigation arrow
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .padding(AppTheme.Spacing.sm)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(color: AppTheme.Shadow.medium.color, radius: AppTheme.Shadow.medium.radius, x: AppTheme.Shadow.medium.x, y: AppTheme.Shadow.medium.y)
    }
}

#Preview {
    AllStoresViewBackend()
}