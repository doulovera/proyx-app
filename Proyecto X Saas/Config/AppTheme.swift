import SwiftUI

// MARK: - App Theme System
struct AppTheme {
    
    // MARK: - Colors
    struct Colors {
        // Primary Colors
        static let primary = Color.primary
        static let secondary = Color.secondary
        
        // Background Colors
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let tertiaryBackground = Color(.tertiarySystemBackground)
        static let groupedBackground = Color(.systemGroupedBackground)
        
        // Text Colors
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let tertiaryText = Color(.tertiaryLabel)
        
        // Accent Colors
        static let accent = Color.accentColor
        static let tint = Color(.tintColor)
        
        // Status Colors
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        static let info = Color.blue
        
        // Custom Brand Colors
        static let brandPrimary = Color(.label) // Adapts to dark/light mode
        static let brandSecondary = Color(.secondaryLabel)
        
        // UI Element Colors
        static let cardBackground = Color(.secondarySystemBackground)
        static let separatorColor = Color(.separator)
        static let fillColor = Color(.systemFill)
        static let secondaryFillColor = Color(.secondarySystemFill)
        static let tertiaryFillColor = Color(.tertiarySystemFill)
        
        // Interactive Colors
        static let buttonPrimary = Color(.label)
        static let buttonSecondary = Color(.systemFill)
        static let selectionColor = Color(.label)
        
        // Category Colors (with dark mode support)
        static let categorySelected = Color(.label)
        static let categoryUnselected = Color(.systemFill)
        
        // Promotion Colors
        static let discountRed = Color.red
        static let exclusiveBadge = Color(.label)
        static let validUntil = Color.orange
        
        // Store Status Colors
        static let storeOpen = Color.green
        static let storeClosed = Color.red
        static let storeRating = Color.orange
    }
    
    // MARK: - Typography
    struct Typography {
        // Headers
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.bold)
        static let title2 = Font.title2.weight(.bold)
        static let title3 = Font.title3.weight(.semibold)
        
        // Body Text
        static let headline = Font.headline.weight(.semibold)
        static let subheadline = Font.subheadline.weight(.medium)
        static let body = Font.body
        static let bodyEmphasized = Font.body.weight(.medium)
        
        // Small Text
        static let caption1 = Font.caption.weight(.medium)
        static let caption2 = Font.caption2.weight(.medium)
        static let footnote = Font.footnote
        
        // Button Text
        static let buttonPrimary = Font.headline.weight(.semibold)
        static let buttonSecondary = Font.subheadline.weight(.medium)
        static let buttonSmall = Font.caption.weight(.semibold)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
        static let round: CGFloat = 25
    }
    
    // MARK: - Shadows
    struct Shadow {
        static let small = (color: Color.black.opacity(0.1), radius: CGFloat(2), x: CGFloat(0), y: CGFloat(1))
        static let medium = (color: Color.black.opacity(0.1), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        static let large = (color: Color.black.opacity(0.15), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
    }
}

// MARK: - Custom View Modifiers
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(
                color: AppTheme.Shadow.medium.color,
                radius: AppTheme.Shadow.medium.radius,
                x: AppTheme.Shadow.medium.x,
                y: AppTheme.Shadow.medium.y
            )
    }
}

struct ButtonPrimaryStyle: ViewModifier {
    let isEnabled: Bool
    
    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.buttonPrimary)
            .foregroundColor(isEnabled ? AppTheme.Colors.background : AppTheme.Colors.tertiaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(isEnabled ? AppTheme.Colors.brandPrimary : AppTheme.Colors.tertiaryFillColor)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .opacity(isEnabled ? 1.0 : 0.6)
    }
}

struct ButtonSecondaryStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.buttonSecondary)
            .foregroundColor(AppTheme.Colors.brandPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.buttonSecondary)
            .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

struct ChipStyle: ViewModifier {
    let isSelected: Bool
    
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.caption1)
            .foregroundColor(isSelected ? AppTheme.Colors.background : AppTheme.Colors.primaryText)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(isSelected ? AppTheme.Colors.brandPrimary : AppTheme.Colors.fillColor)
            .cornerRadius(AppTheme.CornerRadius.round)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func buttonPrimaryStyle(isEnabled: Bool = true) -> some View {
        modifier(ButtonPrimaryStyle(isEnabled: isEnabled))
    }
    
    func buttonSecondaryStyle() -> some View {
        modifier(ButtonSecondaryStyle())
    }
    
    func chipStyle(isSelected: Bool) -> some View {
        modifier(ChipStyle(isSelected: isSelected))
    }
    
    func sectionHeader() -> some View {
        self
            .font(AppTheme.Typography.title2)
            .foregroundColor(AppTheme.Colors.primaryText)
    }
    
    func bodyText() -> some View {
        self
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.secondaryText)
    }
    
    func captionText() -> some View {
        self
            .font(AppTheme.Typography.caption1)
            .foregroundColor(AppTheme.Colors.tertiaryText)
    }
}

// MARK: - Category Colors
extension FoodCategory {
    var themeColor: Color {
        switch self {
        case .pizza: return .red
        case .sushi: return .orange
        case .sandwich: return .brown
        case .grocery: return .blue
        case .healthy: return .green
        case .burger: return .orange
        case .bebidas: return .purple
        case .alimentos: return .cyan
        case .cocteles: return .pink
        case .promociones: return .yellow
        case .all: return AppTheme.Colors.brandPrimary
        }
    }
}
