//
//  LoginViewFactory.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

class LoginViewFactory {
  static func createLoginView() -> some View {
    let viewModel: LoginViewModel = ServiceContainer.shared.resolve()!
    let appRouter: AppRouter = ServiceContainer.shared.resolve()!
    
    return LoginView(viewModel: viewModel, appRouter: appRouter)
  }
}
