import SwiftUI

struct AllPromotionsView: View {
    let dependencies: AppDependencies
    let selectedCategory: FoodCategory
    @Environment(\.dismiss) private var dismiss
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    contentSection
                }
            }
            .navigationBarHidden(true)
            .background(AppTheme.Colors.background)
            .task {
                await load()
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
                Text("Promociones")
                    .sectionHeader()

                Text("\(products.count) ofertas")
                    .captionText()
            }

            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.lg)
    }

    private var contentSection: some View {
        VStack {
            if isLoading {
                ProgressView().padding()
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: AppTheme.Spacing.lg) {
                    ForEach(products) { product in
                        ProductPromoCard(product: product)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.bottom, AppTheme.Spacing.xxxl)
            }
        }
    }

    private func load() async {
        isLoading = true
        errorMessage = nil
        do {
            products = try await dependencies.productsService.deals()
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}

struct ProductPromoCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Text(product.name)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                Spacer()
                if let discount = product.discountPercentage {
                    Text("-\(discount)%")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.discountRed)
                }
            }

            Text(product.description ?? "")
                .bodyText()
                .lineLimit(2)

            HStack {
                Text(product.displayPrice)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                if let original = product.originalPrice {
                    Text("S/ \(Int(original))")
                        .font(AppTheme.Typography.caption1)
                        .strikethrough()
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                Spacer()
                Text(product.category.rawValue.capitalized)
                    .font(AppTheme.Typography.caption2)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    AllPromotionsView(dependencies: AppDependencies(), selectedCategory: .all)
}
