import SwiftUI

struct LegacyHomeView: View {
    @StateObject private var dataStore = LegacyPromotionStoreData()
    @State private var selectedCategory: LegacyFoodCategory = .all
    @State private var showAllPromotions = false
    @State private var showAllStores = false
    
    var filteredPromotions: [LegacyPromotion] {
        dataStore.filteredPromotions(by: selectedCategory).prefix(3).map { $0 }
    }
    
    var filteredStores: [LegacyStore] {
        dataStore.filteredStores(by: selectedCategory).prefix(3).map { $0 }
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
                        categoriesSection
                        promotionsSection
                        featuredSection
                    }
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .sheet(isPresented: $showAllPromotions) {
                LegacyAllPromotionsView(selectedCategory: selectedCategory)
            }
            .sheet(isPresented: $showAllStores) {
                LegacyAllStoresView(selectedCategory: selectedCategory)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("Explora ahora")
                    .captionText()
                Text("Proyecto X SaaS")
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
                Text("Buscar locales")
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
    
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(LegacyFoodCategory.allCases, id: \.self) { category in
                    CategoryItem(
                        icon: category.emoji,
                        name: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .padding(.top, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xl)
    }
    
    private var promotionsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Promociones")
                    .sectionHeader()
                Spacer()
                Button(action: {
                    showAllPromotions = true
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(filteredPromotions) { promotion in
                        PromotionCard(promotion: promotion)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
    
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Tiendas")
                    .sectionHeader()
                Spacer()
                Button(action: {
                    showAllStores = true
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(filteredStores) { store in
                        FeaturedCard(store: store)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
}

struct CategoryItem: View {
    let icon: String
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.sm) {
                Circle()
                    .fill(isSelected ? AppTheme.Colors.brandPrimary : AppTheme.Colors.fillColor)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(icon)
                            .font(AppTheme.Typography.title2)
                    )
                
                Text(name)
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(isSelected ? AppTheme.Colors.primaryText : AppTheme.Colors.secondaryText)
            }
        }
    }
}

struct PromotionCard: View {
    let promotion: LegacyPromotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.fillColor)
                    .frame(height: 140)
                
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text(promotion.category.emoji)
                        .font(AppTheme.Typography.largeTitle)
                    
                    Text(promotion.discount)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.discountRed)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(AppTheme.Colors.cardBackground)
                        .cornerRadius(AppTheme.CornerRadius.small)
                }
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(promotion.storeName)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(promotion.title)
                    .bodyText()
                    .lineLimit(2)
                
                HStack {
                    Text("Hasta \(promotion.validUntilText)")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.validUntil)
                    
                    Spacer()
                    
                    if promotion.isExclusive {
                        Text("EXCLUSIVA")
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.background)
                            .padding(.horizontal, AppTheme.Spacing.xs)
                            .padding(.vertical, AppTheme.Spacing.xs / 2)
                            .background(AppTheme.Colors.exclusiveBadge)
                            .cornerRadius(AppTheme.CornerRadius.small / 2)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.md)
        }
        .frame(width: 260)
        .cardStyle()
    }
}

struct FeaturedCard: View {
    let store: LegacyStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(storeBackgroundColor)
                    .frame(height: 140)
                
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text(store.category.emoji)
                        .font(AppTheme.Typography.largeTitle)
                    
                    Text(store.name)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .padding(AppTheme.Spacing.md)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                HStack {
                    Text(store.category.rawValue)
                        .font(AppTheme.Typography.caption1)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(AppTheme.Colors.fillColor)
                        .cornerRadius(AppTheme.CornerRadius.small)
                    
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
                    .captionText()
                    .lineLimit(2)
                
                HStack {
                    HStack(spacing: AppTheme.Spacing.xs / 2) {
                        Image(systemName: "star.fill")
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.storeRating)
                        Text(store.ratingText)
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                    
                    Spacer()
                    
                    Text(store.priceRange.rawValue)
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.md)
        }
        .frame(width: 260)
        .cardStyle()
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
    LegacyHomeView()
}
