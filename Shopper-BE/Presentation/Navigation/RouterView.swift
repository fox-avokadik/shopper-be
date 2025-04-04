//
//  RouterView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

struct RouterView: View {
  @StateObject private var appRouter: AppRouter
  
  init() {
    let appRouterValue: AppRouter = ServiceContainer.shared.resolve()!
    self._appRouter =  StateObject(wrappedValue: appRouterValue)
  }
  
  var body: some View {
    NavigationStack(path: $appRouter.path) {
      LoginViewFactory.createLoginView()
        .navigationDestination(for: Route.self) { route in
          switch route {
          case .login:
            LoginViewFactory.createLoginView()
          case .home:
            HomeViewFactory.createHomeView()
          }
        }
    }
  }
}
