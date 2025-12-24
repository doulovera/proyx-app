import SwiftUI

struct OnboardingCoordinator: View {
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
                    onLoginComplete: {},
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .welcome
                        }
                    },
                    onSignUp: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentStep = .signup
                        }
                    }
                )
            case .signup:
                SignUpView(
                    onSignUpComplete: {},
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
            }
        }
    }
}

enum OnboardingStep {
    case welcome
    case login
    case signup
}

#Preview {
    OnboardingCoordinator()
}
