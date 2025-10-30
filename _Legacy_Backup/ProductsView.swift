import SwiftUI

// MARK: - ProductsView
struct ProductsView: View {
    @StateObject private var productStore = ProductStoreManager()
    @State private var selectedProduct: Product?
    @State private var searchText = ""
    @State private var activeCategory: ProductCategory = .bebidas
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Contenido fijo (header y búsqueda)
                headerSection
                searchSection
                
                // ScrollView con ScrollViewReader para navegación suave
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            // Sección de productos recomendados
                            recommendedProductsSection
                                .padding(.bottom, AppTheme.Spacing.xxl)
                            
                            // Menú sticky de categorías
                            Section {
                                // Contenido de las secciones de categorías
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    categorySection(for: category)
                                }
                            } header: {
                                stickyCategorySelector(proxy: proxy)
                            }
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(AppTheme.Colors.background)
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product)
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("Catálogo")
                    .captionText()
                Text("Productos locales")
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
                TextField("Buscar productos", text: $searchText)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                }
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
    
    private var recommendedProductsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Productos Recomendados")
                .sectionHeader()
                .padding(.horizontal, AppTheme.Spacing.xl)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(productStore.recommendedProducts) { product in
                        RecommendedProductCard(product: product) {
                            selectedProduct = product
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxl)
    }
    
    // MARK: - Helper Functions
    private func productsForCategory(_ category: ProductCategory) -> [Product] {
        var filtered = productStore.products.filter { $0.category == category }
        
        // Filter by search text if not empty
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.store.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    // MARK: - Sticky Category Selector
    private func stickyCategorySelector(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(ProductCategory.allCases, id: \.self) { category in
                    Button(action: {
                        activeCategory = category
                        withAnimation(.easeInOut(duration: 0.6)) {
                            proxy.scrollTo(category, anchor: .top)
                        }
                    }) {
                        Text(category.rawValue)
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(activeCategory == category ? AppTheme.Colors.background : AppTheme.Colors.primaryText)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                    .fill(activeCategory == category ? AppTheme.Colors.brandPrimary : AppTheme.Colors.fillColor)
                            )
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.Colors.background)
        .overlay(
            Rectangle()
                .fill(AppTheme.Colors.separatorColor)
                .frame(height: 0.5)
                .opacity(0.5),
            alignment: .bottom
        )
    }
    
    // MARK: - Category Sections
    private func categorySection(for category: ProductCategory) -> some View {
        let products = productsForCategory(category)
        
        return VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
            // Título grande de la sección
            Text(category.rawValue)
                .font(AppTheme.Typography.title1)
                .foregroundColor(AppTheme.Colors.primaryText)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.top, AppTheme.Spacing.xxl)
            
            if products.isEmpty {
                // Estado vacío
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "bag.badge.questionmark")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    Text("No hay productos disponibles")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    if !searchText.isEmpty {
                        Text("Prueba con otro término de búsqueda")
                            .captionText()
                    }
                }
                .padding(.vertical, AppTheme.Spacing.xxxl)
                .frame(maxWidth: .infinity)
            } else {
                // Grid de productos
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.Spacing.md) {
                    ForEach(products) { product in
                        ProductCard(product: product) {
                            selectedProduct = product
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
        .id(category) // ID para el scroll automático
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
}


// MARK: - ProductCard
struct ProductCard: View {
    let product: Product
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.fillColor)
                    .frame(height: 130)
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "bag.fill")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(iconColor)
                    
                    if let discount = product.discount {
                        Text(discount)
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.background)
                            .padding(.horizontal, AppTheme.Spacing.xs)
                            .padding(.vertical, AppTheme.Spacing.xs / 2)
                            .background(AppTheme.Colors.discountRed)
                            .cornerRadius(AppTheme.CornerRadius.small / 2)
                    }
                }
                
                // Badges
                VStack {
                    HStack {
                        if product.isOrganic {
                            Text("ORG")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.success)
                                .padding(.horizontal, AppTheme.Spacing.xs)
                                .padding(.vertical, AppTheme.Spacing.xs / 2)
                                .background(AppTheme.Colors.success.opacity(0.2))
                                .cornerRadius(AppTheme.CornerRadius.small / 2)
                        }
                        Spacer()
                        if !product.isAvailable {
                            Text("AGOTADO")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.error)
                                .padding(.horizontal, AppTheme.Spacing.xs)
                                .padding(.vertical, AppTheme.Spacing.xs / 2)
                                .background(AppTheme.Colors.error.opacity(0.2))
                                .cornerRadius(AppTheme.CornerRadius.small / 2)
                        }
                    }
                    Spacer()
                }
                .padding(AppTheme.Spacing.xs)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(product.name)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(product.store.name)
                    .captionText()
                
                HStack {
                    HStack(spacing: AppTheme.Spacing.xs / 2) {
                        Image(systemName: "star.fill")
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.storeRating)
                        Text(String(format: "%.1f", product.rating))
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs / 2) {
                        if let originalPrice = product.originalPrice {
                            Text("$\(Int(originalPrice))")
                                .font(AppTheme.Typography.caption2)
                                .strikethrough()
                                .foregroundColor(AppTheme.Colors.tertiaryText)
                        }
                        Text(product.priceText)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                
                // Dietary tags
                if !product.dietaryTags.isEmpty {
                    HStack(spacing: AppTheme.Spacing.xs / 2) {
                        ForEach(product.dietaryTags.prefix(2), id: \.self) { tag in
                            Text(tag)
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.success)
                                .padding(.horizontal, AppTheme.Spacing.xs / 2)
                                .padding(.vertical, AppTheme.Spacing.xs / 4)
                                .background(AppTheme.Colors.success.opacity(0.1))
                                .cornerRadius(AppTheme.CornerRadius.small / 3)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.md)
        }
        .cardStyle()
        .opacity(product.isAvailable ? 1.0 : 0.7)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
    
    private var iconColor: Color {
        switch product.category {
        case .bebidas: return .brown
        case .alimentos: return .orange
        case .cocteles: return .purple
        case .promociones: return .green
        }
    }
}

// MARK: - RecommendedProductCard
struct RecommendedProductCard: View {
    let product: Product
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
                    if product.isSponsored {
                        HStack {
                            Text("DESTACADO")
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
                    
                    Image(systemName: "star.fill")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.background)
                    
                    if let discount = product.discount {
                        Text(discount)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.background)
                            .padding(.horizontal, AppTheme.Spacing.sm)
                            .padding(.vertical, AppTheme.Spacing.xs)
                            .background(AppTheme.Colors.discountRed)
                            .cornerRadius(AppTheme.CornerRadius.small)
                    }
                    
                    Spacer()
                }
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs / 2) {
                        Text(product.store.name)
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        HStack(spacing: AppTheme.Spacing.xs / 2) {
                            Image(systemName: "star.fill")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.storeRating)
                            Text(String(format: "%.1f", product.rating))
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            Text("(\(product.reviewCount))")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.tertiaryText)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs / 2) {
                        if let originalPrice = product.originalPrice {
                            Text("$\(Int(originalPrice))")
                                .font(AppTheme.Typography.caption1)
                                .strikethrough()
                                .foregroundColor(AppTheme.Colors.tertiaryText)
                        }
                        Text(product.priceText)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                
                Text(product.name)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .lineLimit(2)
                
                Text(product.description)
                    .captionText()
                    .lineLimit(2)
                
                // Features row
                HStack(spacing: AppTheme.Spacing.xs) {
                    if product.isOrganic {
                        Text("🌱")
                            .font(AppTheme.Typography.caption2)
                    }
                    if product.isVegan {
                        Text("🌿")
                            .font(AppTheme.Typography.caption2)
                    }
                    if product.isGlutenFree {
                        Text("⭐")
                            .font(AppTheme.Typography.caption2)
                    }
                    if let calories = product.caloriesText {
                        Text(calories)
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                    Spacer()
                    Text(product.preparationTime)
                        .font(AppTheme.Typography.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                
                Button("Ver producto") {
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
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

// MARK: - ProductDetailView
struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSize: ProductSize
    @State private var selectedExtras: Set<UUID> = []
    @State private var quantity = 1
    
    init(product: Product) {
        self.product = product
        self._selectedSize = State(initialValue: product.availableSizes.first ?? .medium)
    }
    
    var totalPrice: Double {
        var total = product.basePrice * selectedSize.priceMultiplier * Double(quantity)
        
        for extraId in selectedExtras {
            if let extra = product.extras.first(where: { $0.id == extraId }) {
                total += extra.price * Double(quantity)
            }
        }
        
        return total
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    headerImageSection
                    productInfoSection
                    
                    if !product.availableSizes.isEmpty {
                        sizeSelectionSection
                    }
                    
                    if !product.extras.isEmpty {
                        extrasSection
                    }
                    
                    if let nutritionalInfo = product.nutritionalInfo {
                        nutritionalInfoSection(nutritionalInfo)
                    }
                    
                    ingredientsSection
                    addToCartSection
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .navigationTitle("Detalles del producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.Colors.background)
                
                if let discount = product.discount {
                    Text(discount)
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.background)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.discountRed)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                }
            }
        }
    }
    
    private var productInfoSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(product.name)
                        .font(AppTheme.Typography.title1)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text(product.store.name)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                    if let originalPrice = product.originalPrice {
                        Text("$\(Int(originalPrice))")
                            .font(AppTheme.Typography.headline)
                            .strikethrough()
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                    Text(product.priceText)
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
            }
            
            Text(product.fullDescription)
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
                        Text(product.ratingText)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Tiempo de preparación")
                        .captionText()
                    Text(product.preparationTime)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                Spacer()
            }
            
            // Dietary badges
            if !product.dietaryTags.isEmpty {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(product.dietaryTags, id: \.self) { tag in
                        Text(tag)
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.success)
                            .padding(.horizontal, AppTheme.Spacing.sm)
                            .padding(.vertical, AppTheme.Spacing.xs)
                            .background(AppTheme.Colors.success.opacity(0.1))
                            .cornerRadius(AppTheme.CornerRadius.small)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var sizeSelectionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Tamaño")
                .sectionHeader()
            
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(product.availableSizes, id: \.self) { size in
                    Button(action: {
                        selectedSize = size
                    }) {
                        VStack(spacing: AppTheme.Spacing.xs) {
                            Text(size.rawValue)
                                .font(AppTheme.Typography.subheadline)
                            Text("+$\(Int((product.basePrice * size.priceMultiplier) - product.basePrice))")
                                .font(AppTheme.Typography.caption1)
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(selectedSize == size ? AppTheme.Colors.brandPrimary : AppTheme.Colors.fillColor)
                        .foregroundColor(selectedSize == size ? AppTheme.Colors.background : AppTheme.Colors.primaryText)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                }
                Spacer()
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var extrasSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Extras")
                .sectionHeader()
            
            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(product.extras) { extra in
                    HStack {
                        Button(action: {
                            if selectedExtras.contains(extra.id) {
                                selectedExtras.remove(extra.id)
                            } else {
                                selectedExtras.insert(extra.id)
                            }
                        }) {
                            HStack {
                                Image(systemName: selectedExtras.contains(extra.id) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(selectedExtras.contains(extra.id) ? AppTheme.Colors.brandPrimary : AppTheme.Colors.tertiaryText)
                                
                                Text(extra.name)
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                
                                Spacer()
                                
                                Text(extra.priceText)
                                    .font(AppTheme.Typography.subheadline)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                            }
                        }
                        .disabled(!extra.isAvailable)
                        .opacity(extra.isAvailable ? 1.0 : 0.5)
                    }
                    .padding(.vertical, AppTheme.Spacing.xs)
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private func nutritionalInfoSection(_ info: NutritionalInfo) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Información nutricional")
                .sectionHeader()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: AppTheme.Spacing.md) {
                NutritionalItem(title: "Calorías", value: "\(info.calories)", unit: "kcal")
                NutritionalItem(title: "Proteína", value: String(format: "%.1f", info.protein), unit: "g")
                NutritionalItem(title: "Carbohidratos", value: String(format: "%.1f", info.carbs), unit: "g")
                NutritionalItem(title: "Grasas", value: String(format: "%.1f", info.fat), unit: "g")
                
                if let fiber = info.fiber {
                    NutritionalItem(title: "Fibra", value: String(format: "%.1f", fiber), unit: "g")
                }
                
                if let sugar = info.sugar {
                    NutritionalItem(title: "Azúcar", value: String(format: "%.1f", sugar), unit: "g")
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Ingredientes")
                .sectionHeader()
            
            Text(product.ingredients.joined(separator: ", "))
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            if !product.allergens.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Alérgenos:")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.warning)
                    
                    Text(product.allergens.joined(separator: ", "))
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.warning)
                }
                .padding(AppTheme.Spacing.sm)
                .background(AppTheme.Colors.warning.opacity(0.1))
                .cornerRadius(AppTheme.CornerRadius.small)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var addToCartSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Cantidad")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                HStack(spacing: AppTheme.Spacing.md) {
                    Button(action: {
                        if quantity > 1 {
                            quantity -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(quantity > 1 ? AppTheme.Colors.brandPrimary : AppTheme.Colors.tertiaryText)
                    }
                    .disabled(quantity <= 1)
                    
                    Text("\(quantity)")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        quantity += 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.brandPrimary)
                    }
                }
            }
            
            Button(action: {
                // Add to cart logic
                dismiss()
            }) {
                HStack {
                    Text("Agregar al carrito")
                    Spacer()
                    Text("$\(Int(totalPrice))")
                }
                .font(AppTheme.Typography.buttonPrimary)
            }
            .buttonPrimaryStyle(isEnabled: product.isAvailable)
            .disabled(!product.isAvailable)
        }
    }
}

// MARK: - NutritionalItem
struct NutritionalItem: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            Text(title)
                .captionText()
            Text("\(value)\(unit)")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
        }
    }
}

#Preview {
    ProductsView()
}

