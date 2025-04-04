//
//  LoginRouter.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

class LoginRouter {
  private let appRouter: AppRouter
  
  init(appRouter: AppRouter) {
    self.appRouter = appRouter
  }
  
  func handleLoginSuccess() {
    appRouter.navigate(to: .home)
  }
  
  func handleLoginFailure() {
    
  }
}
