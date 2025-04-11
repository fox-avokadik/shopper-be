//
//  AuthenticationRouter.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI

class AuthenticationRouter: Routable {
  typealias Route = AuthenticationRoute
  
  private let onLogin: () -> Void
  
  init(onLogin: @escaping () -> Void) {
    self.onLogin = onLogin
  }
  
  @ViewBuilder
  func view(for route: AuthenticationRoute) -> some View {
    switch route {
    case .login:
      LoginViewFactory.createLoginView(onAuthenticated: onLogin)
    case .register:
      EmptyView()
    case .forgotPassword:
      EmptyView()
    }
  }
}
