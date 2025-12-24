//
//  Proyecto_X_SaasApp.swift
//  Proyecto X Saas
//
//  Created by Jhon Miranda on 26/07/25.
//

import SwiftUI

@main
struct Proyecto_X_SaasApp: App {
    @StateObject private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(dependencies)
                .environmentObject(dependencies.session)
        }
    }
}
