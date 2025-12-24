import SwiftUI

struct OnboardingCompleteView: View {
    let onComplete: () -> Void
    @State private var isAnimating = false
    @State private var showConfetti = false
    @State private var currentBenefitIndex = 0
    
    private let welcomeBenefits = [
        WelcomeBenefit(
            icon: "star.fill",
            title: "100 Puntos de Bienvenida",
            description: "Comenzamos tu cuenta con puntos bonus",
            color: .yellow
        ),
        WelcomeBenefit(
            icon: "percent",
            title: "15% de Descuento",
            description: "En tu primera compra",
            color: .green
        ),
        WelcomeBenefit(
            icon: "gift.fill",
            title: "Acceso Exclusivo",
            description: "A eventos y promociones especiales",
            color: .purple
        )
    ]
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(
                colors: [
                    AppTheme.Colors.brandPrimary.opacity(0.1),
                    AppTheme.Colors.groupedBackground
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    // Celebración principal
                    celebrationSection
                    
                    // Beneficios de bienvenida
                    benefitsSection
                    
                    // Próximos pasos
                    nextStepsSection
                    
                    // Botón para continuar
                    actionButtonSection
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            
            // Efecto de confeti
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            startCelebration()
        }
    }
    
    private var celebrationSection: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            // Ícono principal animado
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                AppTheme.Colors.brandPrimary.opacity(0.2),
                                AppTheme.Colors.brandPrimary.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 150)
                    .scaleEffect(isAnimating ? 1.0 : 0.8)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isAnimating)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.Colors.success)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
                    .animation(.spring(response: 1.0, dampingFraction: 0.5).delay(0.3), value: isAnimating)
            }
            .padding(.top, AppTheme.Spacing.xl)
            
            // Mensaje de bienvenida
            VStack(spacing: AppTheme.Spacing.md) {
                Text("¡Bienvenido a Proyecto X!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(0.6), value: isAnimating)
                
                Text("Tu cuenta ha sido creada exitosamente.\nEstás listo para descubrir experiencias locales increíbles.")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.0).delay(0.9), value: isAnimating)
            }
        }
    }
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Tus Beneficios de Bienvenida")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 1.0).delay(1.2), value: isAnimating)
            
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(0..<welcomeBenefits.count, id: \.self) { index in
                    benefitCard(welcomeBenefits[index], index: index)
                }
            }
        }
    }
    
    private func benefitCard(_ benefit: WelcomeBenefit, index: Int) -> some View {
        HStack(spacing: AppTheme.Spacing.lg) {
            // Ícono
            ZStack {
                Circle()
                    .fill(benefit.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: benefit.icon)
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(benefit.color)
            }
            
            // Contenido
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(benefit.title)
                    .font(AppTheme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(benefit.description)
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
            
            // Checkmark
            Image(systemName: "checkmark.circle.fill")
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.success)
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
        .opacity(isAnimating ? 1.0 : 0.0)
        .offset(x: isAnimating ? 0 : 50)
        .animation(.easeInOut(duration: 0.6).delay(1.5 + Double(index) * 0.2), value: isAnimating)
    }
    
    private var nextStepsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Próximos Pasos")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                nextStepRow(
                    number: "1",
                    title: "Explora productos locales",
                    description: "Descubre comercios cerca de ti"
                )
                
                nextStepRow(
                    number: "2",
                    title: "Participa en eventos",
                    description: "Únete a experiencias gastronómicas"
                )
                
                nextStepRow(
                    number: "3",
                    title: "Acumula puntos",
                    description: "Gana recompensas con cada compra"
                )
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 1.0).delay(2.1), value: isAnimating)
    }
    
    private func nextStepRow(number: String, title: String, description: String) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Número
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.brandPrimary.opacity(0.2))
                    .frame(width: 30, height: 30)
                
                Text(number)
                    .font(AppTheme.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.brandPrimary)
            }
            
            // Contenido
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(description)
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
        }
    }
    
    private var actionButtonSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Button(action: onComplete) {
                HStack {
                    Text("Comenzar a Explorar")
                        .font(AppTheme.Typography.buttonPrimary)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(AppTheme.Typography.title3)
                }
                .foregroundColor(AppTheme.Colors.background)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
                .background(AppTheme.Colors.brandPrimary)
                .cornerRadius(AppTheme.CornerRadius.round)
            }
            .opacity(isAnimating ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 1.0).delay(2.4), value: isAnimating)
            
            Text("¡Gracias por unirte a nuestra comunidad!")
                .font(AppTheme.Typography.caption1)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 1.0).delay(2.7), value: isAnimating)
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
    
    private func startCelebration() {
        // Iniciar animaciones
        withAnimation {
            isAnimating = true
        }
        
        // Mostrar confeti después de un momento
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showConfetti = true
            }
            
            // Ocultar confeti después de 3 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showConfetti = false
                }
            }
        }
    }
}

// MARK: - Supporting Models
struct WelcomeBenefit {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// MARK: - Confetti Effect
struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50) { _ in
                ConfettiPiece()
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    @State private var location = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: -10)
    @State private var opacity = 1.0
    
    private let colors: [Color] = [
        .red, .blue, .green, .yellow, .orange, .purple, .pink
    ]
    
    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .blue)
            .frame(width: 8, height: 8)
            .opacity(opacity)
            .position(location)
            .onAppear {
                withAnimation(.easeOut(duration: 3.0)) {
                    location.y = UIScreen.main.bounds.height + 10
                    opacity = 0.0
                }
            }
    }
}

#Preview {
    OnboardingCompleteView {
        print("Onboarding completed")
    }
}