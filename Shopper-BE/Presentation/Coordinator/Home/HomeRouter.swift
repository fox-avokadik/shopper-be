//
//  HomeRouter.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI

class HomeRouter: Routable {
  typealias Route = HomeRoute
  
  private let onLogout: () -> Void
  
  init(onLogout: @escaping () -> Void) {
    self.onLogout = onLogout
  }
  
  @ViewBuilder
  func view(for route: HomeRoute) -> some View {
    switch route {
    case .home:
      HomeViewFactory.createHomeView(onLogout: onLogout)
    case .profile:
      EmptyView()
    case .settings:
      EmptyView()
    case .details(_):
      EmptyView()
    }
  }
}
