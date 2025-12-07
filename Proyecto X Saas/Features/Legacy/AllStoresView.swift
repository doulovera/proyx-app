import SwiftUI

struct LegacyAllStoresView: View {
    let selectedCategory: LegacyFoodCategory
    @StateObject private var dataStore = LegacyPromotionStoreData()
    @Environment(\.dismiss) private var dismiss
    @State private var currentFilter: LegacyFoodCategory
    @State private var showingStoreDetail: LegacyStore?
    
    init(selectedCategory: LegacyFoodCategory) {
        self.selectedCategory = selectedCategory
        self._currentFilter = State(initialValue: selectedCategory)
    }
    
    var filteredStores: [LegacyStore] {
        dataStore.filteredStores(by: currentFilter)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    filterSection
                    storesGrid
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .sheet(item: $showingStoreDetail) { store in
                StoreDetailView(store: store)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.xs / 2) {
                Text("Todas las tiendas")
                    .sectionHeader()
                
                Text("\(filteredStores.count) locales disponibles")
                    .captionText()
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.lg)
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(LegacyFoodCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        category: category,
                        isSelected: currentFilter == category
                    ) {
                        currentFilter = category
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .padding(.bottom, AppTheme.Spacing.xl)
    }
    
    private var storesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: AppTheme.Spacing.lg) {
            ForEach(filteredStores) { store in
                StoreListCard(store: store) {
                    showingStoreDetail = store
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
}

struct StoreListCard: View {
    let store: LegacyStore
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.lg) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(storeBackgroundColor)
                        .frame(width: 80, height: 80)
                    
                    VStack(spacing: AppTheme.Spacing.xs) {
                        Text(store.category.emoji)
                            .font(AppTheme.Typography.title2)
                        Text(store.name.prefix(8))
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.background)
                            .lineLimit(1)
                    }
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Text(store.name)
                            .sectionHeader()
                        
                        Spacer()
                        
                        HStack(spacing: AppTheme.Spacing.xs) {
                            Circle()
                                .fill(store.isOpen ? AppTheme.Colors.storeOpen : AppTheme.Colors.storeClosed)
                                .frame(width: 8, height: 8)
                            Text(store.statusText)
                                .font(AppTheme.Typography.caption1)
                                .foregroundColor(store.isOpen ? AppTheme.Colors.storeOpen : AppTheme.Colors.storeClosed)
                        }
                    }
                    
                    Text(store.description)
                        .bodyText()
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        HStack(spacing: AppTheme.Spacing.xs / 2) {
                            Image(systemName: "star.fill")
                                .font(AppTheme.Typography.caption1)
                                .foregroundColor(AppTheme.Colors.storeRating)
                            Text(store.ratingText)
                                .font(AppTheme.Typography.caption1)
                                .foregroundColor(AppTheme.Colors.primaryText)
                        }
                        
                        Text("•")
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                        
                        Text(store.category.rawValue)
                            .captionText()
                        
                        Text("•")
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                        
                        Text(store.priceRange.rawValue)
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        Spacer()
                        
                        Text(store.address.components(separatedBy: ",").first ?? "")
                            .captionText()
                            .lineLimit(1)
                    }
                }
            }
            .padding(AppTheme.Spacing.lg)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var storeBackgroundColor: Color {
        switch store.backgroundColor {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "brown": return .brown
        case "black": return AppTheme.Colors.brandPrimary
        default: return AppTheme.Colors.secondaryText
        }
    }
}

struct StoreDetailView: View {
    let store: LegacyStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerImageSection
                    storeInfoSection
                    specialtiesSection
                    featuresSection
                    contactSection
                    actionSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Detalles de la tienda")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .background(AppTheme.Colors.groupedBackground)
        }
    }
    
    private var headerImageSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(storeBackgroundColor)
                .frame(height: 200)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text(store.category.emoji)
                    .font(.system(size: 60))
                
                Text(store.name)
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundColor(AppTheme.Colors.background)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: AppTheme.Spacing.sm) {
                    Circle()
                        .fill(store.isOpen ? AppTheme.Colors.storeOpen : AppTheme.Colors.storeClosed)
                        .frame(width: 12, height: 12)
                    Text(store.statusText)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.background)
                }
            }
        }
    }
    
    private var storeInfoSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text(store.description)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(4)
            
            HStack(spacing: AppTheme.Spacing.xxl) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Calificación")
                        .captionText()
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "star.fill")
                            .foregroundColor(AppTheme.Colors.storeRating)
                        Text(store.ratingText)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Categoría")
                        .captionText()
                    Text(store.category.rawValue)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Precio")
                        .captionText()
                    Text(store.priceRange.rawValue)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.success)
                }
                
                Spacer()
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var specialtiesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Especialidades")
                .sectionHeader()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.Spacing.sm) {
                ForEach(store.specialties, id: \.self) { specialty in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.success)
                            .font(AppTheme.Typography.caption1)
                        Text(specialty)
                            .bodyText()
                        Spacer()
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Características")
                .sectionHeader()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: AppTheme.Spacing.sm) {
                ForEach(store.features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(AppTheme.Colors.info)
                            .font(AppTheme.Typography.caption1)
                        Text(feature)
                            .bodyText()
                        Spacer()
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Información de contacto")
                .sectionHeader()
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(AppTheme.Colors.error)
                    Text(store.address)
                        .bodyText()
                }
                
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(AppTheme.Colors.success)
                    Text(store.phone)
                        .bodyText()
                }
                
                Button("Ver en mapa") {
                    
                }
                .font(AppTheme.Typography.buttonSmall)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.fillColor)
                .foregroundColor(AppTheme.Colors.primaryText)
                .cornerRadius(AppTheme.CornerRadius.round)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var actionSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button("Ver menú completo") {
                
            }
            .buttonPrimaryStyle()
            
            HStack(spacing: AppTheme.Spacing.md) {
                Button("Llamar") {
                    
                }
                .buttonSecondaryStyle()
                
                Button("Compartir") {
                    
                }
                .buttonSecondaryStyle()
            }
        }
    }
    
    private var storeBackgroundColor: Color {
        switch store.backgroundColor {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "brown": return .brown
        case "black": return AppTheme.Colors.brandPrimary
        default: return AppTheme.Colors.secondaryText
        }
    }
}

#Preview {
    LegacyAllStoresView(selectedCategory: .all)
}