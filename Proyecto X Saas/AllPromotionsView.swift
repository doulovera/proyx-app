import SwiftUI

struct AllPromotionsView: View {
    let selectedCategory: FoodCategory
    @StateObject private var dataStore = PromotionStoreData()
    @Environment(\.dismiss) private var dismiss
    @State private var currentFilter: FoodCategory
    @State private var showingPromotionDetail: Promotion?
    
    init(selectedCategory: FoodCategory) {
        self.selectedCategory = selectedCategory
        self._currentFilter = State(initialValue: selectedCategory)
    }
    
    var filteredPromotions: [Promotion] {
        dataStore.filteredPromotions(by: currentFilter)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    filterSection
                    promotionsGrid
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .sheet(item: $showingPromotionDetail) { promotion in
                PromotionDetailView(promotion: promotion)
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
                Text("Todas las promociones")
                    .sectionHeader()
                
                Text("\(filteredPromotions.count) ofertas disponibles")
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
                ForEach(FoodCategory.allCases, id: \.self) { category in
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
    
    private var promotionsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: AppTheme.Spacing.lg) {
            ForEach(filteredPromotions) { promotion in
                PromotionListCard(promotion: promotion) {
                    showingPromotionDetail = promotion
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
}

struct CategoryFilterButton: View {
    let category: FoodCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Text(category.emoji)
                    .font(AppTheme.Typography.subheadline)
                Text(category.rawValue)
                    .font(AppTheme.Typography.subheadline)
            }
            .chipStyle(isSelected: isSelected)
        }
    }
}

struct PromotionListCard: View {
    let promotion: Promotion
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.lg) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.Colors.fillColor)
                        .frame(width: 80, height: 80)
                    
                    VStack(spacing: AppTheme.Spacing.xs) {
                        Text(promotion.category.emoji)
                            .font(AppTheme.Typography.title2)
                        Text(promotion.discount)
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.discountRed)
                    }
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Text(promotion.storeName)
                            .sectionHeader()
                        
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
                    
                    Text(promotion.title)
                        .bodyText()
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs / 2) {
                            Text("Precio original: $\(Int(promotion.originalPrice))")
                                .font(AppTheme.Typography.caption1)
                                .strikethrough()
                                .foregroundColor(AppTheme.Colors.tertiaryText)
                            Text("Con descuento: $\(Int(promotion.discountedPrice))")
                                .font(AppTheme.Typography.caption1)
                                .foregroundColor(AppTheme.Colors.success)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs / 2) {
                            Text("Válido hasta:")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.tertiaryText)
                            Text(promotion.validUntilText)
                                .font(AppTheme.Typography.caption1)
                                .foregroundColor(AppTheme.Colors.validUntil)
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.lg)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PromotionDetailView: View {
    let promotion: Promotion
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerImageSection
                    promotionInfoSection
                    termsSection
                    actionSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .navigationTitle("Detalles de la promoción")
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
                .fill(
                    LinearGradient(
                        colors: [AppTheme.Colors.brandPrimary.opacity(0.8), AppTheme.Colors.secondaryText.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text(promotion.category.emoji)
                    .font(.system(size: 60))
                
                Text(promotion.discount)
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundColor(AppTheme.Colors.background)
                
                if promotion.isExclusive {
                    Text("OFERTA EXCLUSIVA")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(Color.yellow)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(AppTheme.Colors.brandPrimary.opacity(0.6))
                        .cornerRadius(AppTheme.CornerRadius.small)
                }
            }
        }
    }
    
    private var promotionInfoSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text(promotion.storeName)
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Text(promotion.title)
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            Text(promotion.description)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.primaryText)
                .lineSpacing(4)
            
            HStack(spacing: AppTheme.Spacing.xxl) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Precio original")
                        .captionText()
                    Text("$\(Int(promotion.originalPrice))")
                        .font(AppTheme.Typography.headline)
                        .strikethrough()
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Precio con descuento")
                        .captionText()
                    Text("$\(Int(promotion.discountedPrice))")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.success)
                }
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(AppTheme.Colors.validUntil)
                Text("Válido hasta \(promotion.validUntilText)")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.validUntil)
            }
            .padding(AppTheme.Spacing.lg)
            .background(AppTheme.Colors.validUntil.opacity(0.1))
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var termsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Términos y condiciones")
                .sectionHeader()
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                ForEach(promotion.terms, id: \.self) { term in
                    HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                        Text("•")
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        Text(term)
                            .bodyText()
                    }
                }
            }
            
            if let minOrder = promotion.minOrder {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(AppTheme.Colors.info)
                    Text("Compra mínima: $\(Int(minOrder))")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.info)
                }
                .padding(AppTheme.Spacing.lg)
                .background(AppTheme.Colors.info.opacity(0.1))
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var actionSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button("Usar promoción") {
                // Acción para usar la promoción
            }
            .buttonPrimaryStyle()
            
            Button("Compartir promoción") {
                // Acción para compartir
            }
            .buttonSecondaryStyle()
        }
    }
}

#Preview {
    AllPromotionsView(selectedCategory: .all)
}