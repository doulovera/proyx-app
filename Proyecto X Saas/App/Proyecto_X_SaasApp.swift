//
//  Proyecto_X_SaasApp.swift
//  Proyecto X Saas
//
//  Created by Jhon Miranda on 26/07/25.
//

import SwiftUI

@main
struct Proyecto_X_SaasApp: App {
    // Toggle to switch between backend UI and legacy UI
    private let useLegacyUI = true

    var body: some Scene {
        WindowGroup {
            if useLegacyUI {
                LegacyAppCoordinator()
            } else {
                ContentViewBackend()
            }
        }
    }
}
