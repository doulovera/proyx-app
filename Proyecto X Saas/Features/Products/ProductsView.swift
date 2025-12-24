import SwiftUI

struct ProductsView: View {
    let dependencies: AppDependencies
    @StateObject private var viewModel: ProductsViewModel
    @State private var searchText: String = ""
    @State private var selectedCategory: FoodCategory = .all

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: ProductsViewModel(productsService: dependencies.productsService))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                searchSection
                categoryChips
                contentSection
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(AppTheme.Colors.background)
            .task {
                await viewModel.loadInitial()
            }
            .onChange(of: selectedCategory) { newValue in
                Task { await viewModel.filter(category: newValue, query: searchText) }
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("Productos")
                    .sectionHeader()
                Text("Explora opciones destacadas")
                    .captionText()
            }
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.lg)
    }

    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.secondaryText)
            TextField("Buscar productos", text: $searchText, onCommit: {
                Task { await viewModel.filter(category: selectedCategory, query: searchText) }
            })
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.Colors.fillColor)
        .cornerRadius(AppTheme.CornerRadius.small)
        .padding(.horizontal, AppTheme.Spacing.xl)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(FoodCategory.allCases, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category.rawValue.capitalized)
                            .chipStyle(isSelected: selectedCategory == category)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.md)
        }
    }

    private var contentSection: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.vertical, AppTheme.Spacing.xxxl)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.vertical, AppTheme.Spacing.xxxl)
            } else if viewModel.products.isEmpty {
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "bag.badge.minus")
                        .font(AppTheme.Typography.largeTitle)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    Text("No hay productos")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                    Text("Prueba otra categoría o búsqueda")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                .padding(.vertical, AppTheme.Spacing.xxxl)
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.md) {
                        ForEach(viewModel.products) { product in
                            ProductCard(product: product)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.bottom, AppTheme.Spacing.xxxl)
                }
            }
        }
    }
}

// MARK: - Card
struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Text(product.name)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                Spacer()
                Text(product.displayPrice)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }

            if let desc = product.description, !desc.isEmpty {
                Text(desc)
                    .bodyText()
                    .lineLimit(2)
            }

            HStack(spacing: AppTheme.Spacing.sm) {
                Text(product.category.rawValue.capitalized)
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                if let discount = product.discountPercentage {
                    Text("-\(discount)%")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.discountRed)
                }
                Spacer()
                if let store = product.store {
                    Text(store.name)
                        .font(AppTheme.Typography.caption2)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - ViewModel
@MainActor
final class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: ProductsService

    init(productsService: ProductsService) {
        self.service = productsService
    }

    func loadInitial() async {
        await filter(category: .all, query: nil)
    }

    func filter(category: FoodCategory, query: String?) async {
        isLoading = true
        errorMessage = nil
        do {
            if let query, !query.isEmpty {
                products = try await service.search(category: category == .all ? nil : category, query: query)
            } else if category != .all {
                products = try await service.category(category)
            } else {
                products = try await service.list(limit: 50)
            }
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    ProductsView(dependencies: AppDependencies())
}
