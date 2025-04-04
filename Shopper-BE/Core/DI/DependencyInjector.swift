//
//  DependencyInjector.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import Foundation
import IHttpClient

actor DependencyInjector {
  static let shared = DependencyInjector()
  private var isInitialized = false
  
  private init() {}
  
  func registerDependencies() async {
    guard !isInitialized else { return }
    
    let httpClient = IHttpClient(baseURL: "http://185.233.119.229:8080")
    ServiceContainer.shared.register(httpClient)
    
    let authenticationService = AuthenticationService(httpClient: httpClient)
    let authenticationRepository = AuthenticationRepository(authenticationService: authenticationService)
    let loginUseCase = LoginUseCase(authenticationRepository: authenticationRepository)
    
    ServiceContainer.shared.register(authenticationRepository)
    ServiceContainer.shared.register(loginUseCase)
    
    let appRouter = AppRouter()
    ServiceContainer.shared.register(appRouter)
    
    await MainActor.run {
      let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
      ServiceContainer.shared.register(loginViewModel)
    }
    
    isInitialized = true
  }
}
