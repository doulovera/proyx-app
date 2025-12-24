//
//  ContentView.swift
//  Proyecto X Saas
//
//  Created by Jhon Miranda on 26/07/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dependencies: AppDependencies

    var body: some View {
        TabView {
            HomeView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }

            EventsView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Eventos")
                }

            ProductsView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Productos")
                }

            ProfileView(dependencies: dependencies)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppDependencies())
        .environmentObject(SessionStore())
}
