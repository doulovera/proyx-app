import SwiftUI

struct HomeView: View {
    let dependencies: AppDependencies
    @StateObject private var viewModel: HomeViewModel
    @State private var selectedCategory: FoodCategory = .all
    @State private var showAllPromotions = false
    @State private var showAllStores = false

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: HomeViewModel(
            eventsService: dependencies.eventsService,
            storesService: dependencies.storesService,
            productsService: dependencies.productsService
        ))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                searchSection

                ScrollView {
                    VStack(spacing: 0) {
                        categoriesSection
                        eventsSection
                        storesSection
                        productsSection
                    }
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .sheet(isPresented: $showAllPromotions) {
                AllPromotionsView(dependencies: dependencies, selectedCategory: selectedCategory)
            }
            .sheet(isPresented: $showAllStores) {
                AllStoresView(dependencies: dependencies, selectedCategory: selectedCategory)
            }
            .task {
                await viewModel.load()
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
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    CategoryItem(
                        icon: category.emoji,
                        name: category.rawValue.capitalized,
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

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Eventos destacados")
                    .sectionHeader()
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.xl)

            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppTheme.Spacing.md) {
                        ForEach(viewModel.featuredEvents) { event in
                            EventCard(event: event) { }
                                .frame(width: 260)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                }
            }
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }

    private var storesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Tiendas destacadas")
                    .sectionHeader()
                Spacer()
                Button(action: { showAllStores = true }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(viewModel.featuredStores) { store in
                        StoreListCard(store: store) { }
                            .frame(width: 220)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
            }
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }

    private var productsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Productos destacados")
                    .sectionHeader()
                Spacer()
                Button(action: { showAllPromotions = true }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(viewModel.trendingProducts) { product in
                        ProductCard(product: product)
                            .frame(width: 220)
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

#Preview {
    HomeView(dependencies: AppDependencies())
}
