//
//  AppCoordinator.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
  enum State {
    case auth
    case main
  }
  
  @Published var currentState: State = .auth
  @Published var activeCoordinator: AnyCoordinator?
  @Published var userSession: AuthenticationManager
  
  private var authCoordinator: AuthenticationCoordinator?
  private var homeCoordinator: HomeCoordinator?
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    let authManager: AuthenticationManager = ServiceContainer.shared.resolve()
    userSession = authManager
    setupCoordinators()
    
    userSession.$isAuthorized
      .sink { [weak self] isAuthenticated in
        self?.updateState(isAuthenticated: isAuthenticated)
      }
      .store(in: &cancellables)
  }
  
  private func setupCoordinators() {
    authCoordinator = AuthenticationCoordinator { [weak self] in
      self?.userSession.setAuthorized()
    }
    
    homeCoordinator = HomeCoordinator { [weak self] in
      self?.userSession.logout()
    }
  }
  
  func start() {
    updateState(isAuthenticated: userSession.isAuthorized)
  }
  
  private func updateState(isAuthenticated: Bool) {
    currentState = isAuthenticated ? .main : .auth
    updateActiveCoordinator()
  }
  
  private func updateActiveCoordinator() {
    withAnimation(.easeInOut) {
      switch currentState {
      case .auth:
        authCoordinator?.start()
        activeCoordinator = AnyCoordinator(authCoordinator!)
      case .main:
        homeCoordinator?.start()
        activeCoordinator = AnyCoordinator(homeCoordinator!)
      }
    }
  }
}
