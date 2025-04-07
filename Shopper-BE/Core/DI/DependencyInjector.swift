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
    
    let authenticationStorageService = AuthenticationStorageService()
    ServiceContainer.shared.register(authenticationStorageService)
    
    let authenticationManager = AuthenticationManager(authenticationStorage: authenticationStorageService)
    ServiceContainer.shared.register(authenticationManager)
    
    let coordinator = AppCoordinator()
    ServiceContainer.shared.register(coordinator)
    
    let authenticationService = AuthenticationService(httpClient: httpClient)
    let authenticationRepository = AuthenticationRepository(authenticationService: authenticationService)
    let loginUseCase = LoginUseCase(authenticationRepository: authenticationRepository)
    
    ServiceContainer.shared.register(authenticationRepository)
    ServiceContainer.shared.register(loginUseCase)
    
    await MainActor.run {
      let loginViewModel = LoginViewModel(loginUseCase: loginUseCase)
      ServiceContainer.shared.register(loginViewModel)
    }
    
    isInitialized = true
  }
}
