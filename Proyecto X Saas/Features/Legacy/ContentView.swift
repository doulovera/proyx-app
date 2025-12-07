//
//  LegacyContentView.swift
//  Proyecto X Saas
//
//  Created by Jhon Miranda on 26/07/25.
//

import SwiftUI

struct LegacyContentView: View {
    let onLogout: () -> Void
    
    var body: some View {
        TabView {
            LegacyHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
            
            LegacyEventsView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Eventos")
                }
            
            LegacyProductsView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Productos")
                }
            
            LegacyProfileView(onLogout: onLogout)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    LegacyContentView(onLogout: { print("Logout pressed") })
}

