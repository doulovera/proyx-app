import SwiftUI

struct RootView: View {
    @EnvironmentObject var dependencies: AppDependencies
    @EnvironmentObject var session: SessionStore
    @State private var didAttemptRefresh = false
    @State private var isRefreshing = false

    var body: some View {
        Group {
            if session.isAuthenticated {
                ContentView()
            } else {
                OnboardingCoordinator()
            }
        }
        .task {
            await refreshSessionIfNeeded()
        }
    }

    private func refreshSessionIfNeeded() async {
        guard !didAttemptRefresh else { return }
        didAttemptRefresh = true
        guard session.isAuthenticated else { return }
        isRefreshing = true
        do {
            let profile = try await dependencies.profileService.profile()
            session.setSession(user: profile, token: session.token ?? "")
        } catch {
            session.clearSession()
        }
        isRefreshing = false
    }
}
