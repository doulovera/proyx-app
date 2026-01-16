import SwiftUI

struct OnboardingWelcomeView: View {
    let onContinue: () -> Void
    let onLogin: () -> Void
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var autoScrollTimer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    private let features = [
        OnboardingFeature(
            icon: "bag.fill",
            title: "Productos Locales",
            description: "Descubre una amplia variedad de productos frescos de comercios locales en tu área",
            color: .orange
        ),
        OnboardingFeature(
            icon: "calendar.badge.clock",
            title: "Eventos Únicos",
            description: "Participa en eventos gastronómicos exclusivos y experiencias culinarias especiales",
            color: .purple
        ),
        OnboardingFeature(
            icon: "star.fill",
            title: "Sistema de Puntos",
            description: "Gana puntos con cada compra y canjéalos por descuentos y productos gratuitos",
            color: .green
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header con logo
                headerSection
                
                // Contenido principal con páginas
                TabView(selection: $currentPage) {
                    ForEach(0..<features.count, id: \.self) { index in
                        featurePage(features[index], geometry: geometry)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onReceive(autoScrollTimer) { _ in
                    withAnimation {
                        currentPage = (currentPage + 1) % features.count
                    }
                }
                
                // Botones de acción
                actionButtonsSection
            }
            .background(
                LinearGradient(
                    colors: [
                        AppTheme.Colors.groupedBackground,
                        AppTheme.Colors.background
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .onAppear {
                startAnimation()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Logo y título
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: "medal.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.Colors.brandPrimary)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isAnimating)
                
                VStack(spacing: AppTheme.Spacing.xs) {
                    Text("Proyecto X")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("Tu plataforma local favorita")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 1.0).delay(0.5), value: isAnimating)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.top, AppTheme.Spacing.xxl)
        .padding(.bottom, AppTheme.Spacing.lg)
    }
    
    private func featurePage(_ feature: OnboardingFeature, geometry: GeometryProxy) -> some View {
        VStack(spacing: AppTheme.Spacing.xxl) {
            // Ilustración central
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                feature.color.opacity(0.2),
                                feature.color.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 80))
                    .foregroundColor(feature.color)
            }
            .padding(.top, AppTheme.Spacing.xl)
            
            // Contenido de texto
            VStack(spacing: AppTheme.Spacing.lg) {
                Text(feature.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(feature.description)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            Spacer()
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Page indicator dots (moved above buttons)
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(0..<features.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? AppTheme.Colors.brandPrimary : AppTheme.Colors.tertiaryText)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            .padding(.bottom, AppTheme.Spacing.md)
            
            // Primary button - "Empezar" (centered text with arrow)
            Button(action: onContinue) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Text("Empezar")
                        .font(AppTheme.Typography.buttonPrimary)
                    Image(systemName: "arrow.right")
                        .font(AppTheme.Typography.body)
                }
                .foregroundColor(AppTheme.Colors.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.lg)
                .background(AppTheme.Colors.brandPrimary)
                .cornerRadius(AppTheme.CornerRadius.round)
            }
            
            // Secondary button - "Ya tengo una cuenta"
            Button(action: onLogin) {
                Text("Ya tengo una cuenta")
                    .font(AppTheme.Typography.buttonPrimary)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.lg)
                    .background(AppTheme.Colors.fillColor)
                    .cornerRadius(AppTheme.CornerRadius.round)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxxl)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 1.0).delay(1.0), value: isAnimating)
    }
    
    private func startAnimation() {
        withAnimation {
            isAnimating = true
        }
    }
}

// MARK: - Supporting Models
struct OnboardingFeature {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

#Preview {
    OnboardingWelcomeView(
        onContinue: { print("Continue tapped") },
        onLogin: { print("Login tapped") }
    )
}