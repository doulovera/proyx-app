import SwiftUI

struct ContentViewBackend: View {
    @ObservedObject private var networkManager = NetworkManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if networkManager.isLoggedIn {
                // Main app interface with 3 tabs only (using existing Backend views)
                TabView(selection: $selectedTab) {
                    HomeViewBackend()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Inicio")
                        }
                        .tag(0)
                    
                    AllStoresViewBackend()
                        .tabItem {
                            Image(systemName: "storefront.fill")
                            Text("Tiendas")
                        }
                        .tag(1)
                    
                    AllEventsViewBackend()
                        .tabItem {
                            Image(systemName: "calendar.badge.plus")
                            Text("Eventos")
                        }
                        .tag(2)
                }
                .accentColor(AppTheme.Colors.primary)
            } else {
                // Authentication interface
                LoginViewBackend()
            }
        }
        .background(AppTheme.Colors.background)
    }
}

#Preview {
    ContentViewBackend()
}