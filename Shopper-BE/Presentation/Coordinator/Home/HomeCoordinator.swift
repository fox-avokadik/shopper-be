//
//  HomeCoordinator.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI

class HomeCoordinator: Coordinator {
  typealias Router = HomeRouter
  
  @Published var currentScreen: AnyView?
  let router: HomeRouter
  
  init(onLogout: @escaping () -> Void) {
    self.router = HomeRouter(onLogout: onLogout)
  }
  
  func start() {
    navigateTo(.home)
  }
  
  func navigateTo(_ route: HomeRoute) {
    withAnimation(.easeInOut) {
      currentScreen = AnyView(router.view(for: route))
    }
  }
}
