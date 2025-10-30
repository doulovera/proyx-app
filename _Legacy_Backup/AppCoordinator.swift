import SwiftUI

struct AppCoordinator: View {
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
                ContentView()
            case .login:
                LoginView()
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
    AppCoordinator()
}
