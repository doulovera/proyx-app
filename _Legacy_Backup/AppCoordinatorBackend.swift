import SwiftUI

struct AppCoordinatorBackend: View {
    @StateObject private var networkManager = NetworkManager.shared
    @State private var appState: BackendAppState = .splash
    
    var body: some View {
        Group {
            switch appState {
            case .splash:
                SplashViewBackend {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        // Check authentication status after splash
                        if networkManager.isLoggedIn && networkManager.authToken != nil {
                            appState = .authenticated
                        } else {
                            appState = .login
                        }
                    }
                }
            case .onboarding:
                // Skip onboarding and go directly to login for MVP
                LoginViewBackend()
                    .onReceive(networkManager.$isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                appState = .authenticated
                            }
                        }
                    }
            case .authenticated:
                ContentViewBackend()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            case .login:
                LoginViewBackend()
                    .onReceive(networkManager.$isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                appState = .authenticated
                            }
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.6), value: appState)
        .onReceive(networkManager.$isLoggedIn) { isLoggedIn in
            // Handle logout
            if !isLoggedIn && appState == .authenticated {
                withAnimation(.easeInOut(duration: 0.5)) {
                    appState = .login
                }
            }
        }
        .onAppear {
            // Initial authentication check
            Task {
                await checkInitialAuthState()
            }
        }
    }
    
    private func checkInitialAuthState() async {
        // Small delay for splash screen
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        await MainActor.run {
            withAnimation(.easeInOut(duration: 0.8)) {
                if networkManager.isLoggedIn && networkManager.authToken != nil {
                    appState = .authenticated
                } else {
                    appState = .login
                }
            }
        }
    }
}

enum BackendAppState {
    case splash
    case onboarding
    case authenticated
    case login
}

// MARK: - Enhanced SplashView with better styling

struct SplashViewBackend: View {
    let onComplete: () -> Void
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    AppTheme.Colors.primary.opacity(0.1),
                    AppTheme.Colors.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                // Logo or app icon placeholder
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.Colors.primary, AppTheme.Colors.primary.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text("X")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    )
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Proyecto X")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("SaaS Platform")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            
            // Auto complete after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onComplete()
            }
        }
    }
}

#Preview {
    AppCoordinatorBackend()
}