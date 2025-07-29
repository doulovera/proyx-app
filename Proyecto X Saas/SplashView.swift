import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void
    @State private var isAnimating = false
    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.5
    @State private var showSubtitle = false
    
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(
                colors: [
                    AppTheme.Colors.brandPrimary,
                    AppTheme.Colors.brandPrimary.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xxl) {
                Spacer()
                
                // Logo principal
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Ícono de medalla como logo
                    Image(systemName: "medal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.Colors.background)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .animation(.easeInOut(duration: 1.2), value: logoScale)
                        .animation(.easeInOut(duration: 1.0), value: logoOpacity)
                    
                    // Título principal
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("PROYECTO X")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.Colors.background)
                            .tracking(2)
                            .scaleEffect(isAnimating ? 1.0 : 0.8)
                            .opacity(logoOpacity)
                            .animation(.easeInOut(duration: 1.2).delay(0.3), value: isAnimating)
                        
                        if showSubtitle {
                            Text("SAAS")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(AppTheme.Colors.background.opacity(0.9))
                                .tracking(4)
                                .transition(.opacity.combined(with: .scale))
                                .animation(.easeInOut(duration: 0.8), value: showSubtitle)
                        }
                    }
                }
                
                Spacer()
                
                // Indicador de carga
                VStack(spacing: AppTheme.Spacing.lg) {
                    if isAnimating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.background))
                            .scaleEffect(1.2)
                            .transition(.opacity.combined(with: .scale))
                        
                        Text("Cargando experiencias locales...")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.background.opacity(0.8))
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.6).delay(1.5), value: isAnimating)
                
                Spacer()
            }
            .padding(AppTheme.Spacing.xl)
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private func startAnimationSequence() {
        // Fase 1: Mostrar logo
        withAnimation {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // Fase 2: Animar título
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isAnimating = true
            }
        }
        
        // Fase 3: Mostrar subtítulo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showSubtitle = true
            }
        }
        
        // Fase 4: Completar splash después de 3 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            onComplete()
        }
    }
}

#Preview {
    SplashView(onComplete: { print("Splash completed") })
}