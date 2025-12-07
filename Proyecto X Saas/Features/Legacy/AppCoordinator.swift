import SwiftUI

struct LegacyAppCoordinator: View {
    @State private var appState: AppState = .splash
    
    var body: some View {
        Group {
            switch appState {
            case .splash:
                SplashView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .onboarding
                    }
                }
            case .onboarding:
                OnboardingCoordinator(
                    onAuthenticationComplete: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState = .authenticated
                        }
                    }
                )
            case .authenticated:
                LegacyContentView(onLogout: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .login
                    }
                })
            case .login:
                LegacyLoginView(
                    onLoginComplete: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState = .authenticated
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState = .onboarding
                        }
                    },
                    onSignUp: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState = .onboarding
                        }
                    },
                    onQuickAccess: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            appState = .authenticated
                        }
                    }
                )
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState)
    }
}

enum AppState {
    case splash
    case onboarding
    case authenticated
    case login
}

// AppState moved to AppCoordinatorBackend to avoid conflicts

#Preview {
    LegacyAppCoordinator()
}
