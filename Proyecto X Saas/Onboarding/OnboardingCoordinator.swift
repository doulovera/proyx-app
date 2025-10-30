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
                LoginViewBackend()
                    .onReceive(NetworkManager.shared.$isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentStep = .complete
                            }
                        }
                    }
            case .signup:
                SignUpViewBackend(
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