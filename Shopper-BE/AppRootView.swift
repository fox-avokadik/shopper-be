//
//  AppRootView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 14.03.2025.
//

import SwiftUI
import IHttpClient

struct AppRootView: View {
  @StateObject var appCoordinator = AppCoordinator()
  
  var body: some View {
    Group {
      if let coordinator = appCoordinator.activeCoordinator,
         let screen = coordinator.currentScreen {
        screen
      }
    }
    .animation(.easeInOut, value: appCoordinator.currentState)
    .onAppear {
      appCoordinator.start()
    }
  }
}

#Preview {
  AppRootView()
}
