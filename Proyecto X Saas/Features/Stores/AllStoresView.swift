import SwiftUI

struct AllStoresView: View {
    let dependencies: AppDependencies
    let selectedCategory: FoodCategory
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: StoresViewModel

    init(dependencies: AppDependencies, selectedCategory: FoodCategory) {
        self.dependencies = dependencies
        self.selectedCategory = selectedCategory
        _viewModel = StateObject(wrappedValue: StoresViewModel(service: dependencies.storesService))
        _viewModel.wrappedValue.currentFilter = selectedCategory
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    filterSection
                    if viewModel.isLoading {
                        ProgressView().padding()
                    } else if let error = viewModel.errorMessage {
                        Text(error).foregroundColor(.red).padding()
                    } else {
                        storesGrid
                    }
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .task {
                await viewModel.load()
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
                
                Text("\(viewModel.filteredStores.count) locales disponibles")
                    .captionText()
            }
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.lg)
    }
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    Button {
                        viewModel.currentFilter = category
                    } label: {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            Text(category.emoji)
                            Text(category.rawValue.capitalized)
                        }
                        .chipStyle(isSelected: viewModel.currentFilter == category)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .padding(.bottom, AppTheme.Spacing.xl)
    }
    
    private var storesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: AppTheme.Spacing.lg) {
            ForEach(viewModel.filteredStores) { store in
                StoreListCard(store: store) { }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
}

struct StoreListCard: View {
    let store: Store
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.lg) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.Colors.fillColor)
                        .frame(width: 80, height: 80)
                    
                    VStack(spacing: AppTheme.Spacing.xs) {
                        Text(store.category.emoji)
                            .font(AppTheme.Typography.title2)
                        Text(store.name.prefix(8))
                            .font(AppTheme.Typography.caption2)
                            .foregroundColor(AppTheme.Colors.primaryText)
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
                                .fill((store.isOpen ?? false) ? AppTheme.Colors.storeOpen : AppTheme.Colors.storeClosed)
                                .frame(width: 8, height: 8)
                            Text(store.statusText)
                                .font(AppTheme.Typography.caption1)
                                .foregroundColor((store.isOpen ?? false) ? AppTheme.Colors.storeOpen : AppTheme.Colors.storeClosed)
                        }
                    }
                    
                    Text(store.description ?? "")
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
                        
                        Text(store.category.rawValue.capitalized)
                            .captionText()
                        
                        Spacer()
                        
                        Text(store.priceRange?.rawValue ?? "")
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                }
            }
            .padding(AppTheme.Spacing.lg)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StoreDetailView: View {
    let store: Store
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerImageSection
                    storeInfoSection
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
                .fill(AppTheme.Colors.fillColor)
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
                        .fill((store.isOpen ?? false) ? AppTheme.Colors.storeOpen : AppTheme.Colors.storeClosed)
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
            Text(store.description ?? "")
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
                    Text(store.priceRange?.rawValue ?? "")
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
    
    // Detail sections removed until backend store detail is integrated.
    
}

#Preview {
    AllStoresView(dependencies: AppDependencies(), selectedCategory: .all)
}
