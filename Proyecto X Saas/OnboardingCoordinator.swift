import SwiftUI

struct OnboardingCoordinator: View {
    let onAuthenticationComplete: () -> Void
    @State private var currentStep: OnboardingStep = .welcome
    
    var body: some View {
        Group {
            switch currentStep {
            case .welcome:
                OnboardingWelcomeView(
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .signup
                        }
                    },
                    onLogin: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .login
                        }
                    }
                )
            case .login:
                LoginView(
                    onLoginComplete: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .complete
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .welcome
                        }
                    },
                    onSignUp: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .signup
                        }
                    },
                    onQuickAccess: {
                        // Acceso directo al HomeView (saltando onboarding)
                        onAuthenticationComplete()
                    }
                )
            case .signup:
                SignUpView(
                    onSignUpComplete: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .complete
                        }
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .welcome
                        }
                    },
                    onLogin: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .login
                        }
                    }
                )
            case .complete:
                OnboardingCompleteView {
                    onAuthenticationComplete()
                }
            }
        }
    }
}

enum OnboardingStep {
    case welcome
    case login
    case signup
    case complete
}

#Preview {
    OnboardingCoordinator(
        onAuthenticationComplete: { print("Authentication completed") }
    )
}