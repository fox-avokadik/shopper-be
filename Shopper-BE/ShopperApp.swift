//
//  ShopperApp.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 14.03.2025.
//

import SwiftUI

@main
struct ShopperApp: App {
  @StateObject private var appState = AppState()
  
  var body: some Scene {
    WindowGroup {
      if appState.isReady {
        AppRootView()
          .environmentObject(appState)
      } else {
        ProgressView()
          .task {
            await DependencyInjector.shared.registerDependencies()
            appState.isReady = true
          }
      }
    }
  }
}
