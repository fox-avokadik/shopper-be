//
//  AppRootView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 14.03.2025.
//

import SwiftUI
import NavigationTransitions
import IHttpClient

struct AppRootView: View {
  @StateObject private var coordinator: AppCoordinator
  
  init() {
    let coordinator: AppCoordinator = ServiceContainer.shared.resolve()
    self._coordinator = StateObject(wrappedValue: coordinator)
  }
  
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      HomeViewFactory.createHomeView()
        .navigationDestination(for: AppScreen.self) { screen in
          viewForDestination(screen, coordinator: coordinator)
            .navigationBarBackButtonHidden(true)
        }
    }
    .sheet(item: $coordinator.sheet) { screen in
      viewForDestination(screen, coordinator: coordinator)
    }
    .fullScreenCover(item: $coordinator.fullScreenCover) { screen in
      viewForDestination(screen, coordinator: coordinator)
    }
    .navigationTransition(.fade(.out))
  }
  
  @ViewBuilder
  func viewForDestination(_ screen: AppScreen, coordinator: AppCoordinator) -> some View {
    switch screen {
    case .login:
      LoginViewFactory.createLoginView()
    case .home:
      HomeViewFactory.createHomeView()
    }
  }
}

#Preview {
  AppRootView()
}
