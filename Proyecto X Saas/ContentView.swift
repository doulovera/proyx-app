//
//  ContentView.swift
//  Proyecto X Saas
//
//  Created by Jhon Miranda on 26/07/25.
//

import SwiftUI

struct ContentView: View {
    let onLogout: () -> Void
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
            
            EventsView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Eventos")
                }
            
            ProductsView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Productos")
                }
            
            ProfileView(onLogout: onLogout)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    ContentView(onLogout: { print("Logout pressed") })
}

