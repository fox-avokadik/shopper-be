//
//  AppRouter.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

class AppRouter: ObservableObject {
  @Published var path: [Route] = []
  
  func navigate(to route: Route) {
    path.append(route)
  }
  
  func pop() {
    path.removeLast()
  }
}
