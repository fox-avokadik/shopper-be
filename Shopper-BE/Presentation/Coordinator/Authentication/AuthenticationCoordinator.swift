//
//  AuthenticationCoordinator.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI

class AuthenticationCoordinator: Coordinator {
  typealias Router = AuthenticationRouter
  
  @Published var currentScreen: AnyView?
  let router: AuthenticationRouter
  private let onAuthenticated: () -> Void
  
  init(onAuthenticated: @escaping () -> Void) {
    self.onAuthenticated = onAuthenticated
    self.router = AuthenticationRouter(onLogin: onAuthenticated)
  }
  
  func start() {
    navigateTo(.login)
  }
  
  func navigateTo(_ route: AuthenticationRoute) {
    withAnimation(.easeInOut) {
      currentScreen = AnyView(router.view(for: route))
    }
  }
}
