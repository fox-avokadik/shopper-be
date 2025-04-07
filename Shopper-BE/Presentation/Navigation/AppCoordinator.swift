//
//  AppCoordinator.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 07.04.2025.
//

import SwiftUI

class AppCoordinator: Coordinating {
  @Published var path = NavigationPath()
  @Published var sheet: AppScreen?
  @Published var fullScreenCover: AppScreen?
  
  private var authManagerObserver: NSObjectProtocol?
  
  init() {
    determineInitialScreen()
    setupAuthListener()
  }
  
  private func determineInitialScreen() {
    let authManager: AuthenticationManager = ServiceContainer.shared.resolve()
    if !authManager.isAuthorized {
      path.append(AppScreen.login)
    }
  }
  
  private func setupAuthListener() {
    let authManager: AuthenticationManager = ServiceContainer.shared.resolve()
    
    authManagerObserver = NotificationCenter.default.addObserver(
      forName: NSNotification.Name("AuthStateChanged"),
      object: nil,
      queue: .main
    ) { [weak self] _ in
      DispatchQueue.main.async {
        if authManager.isAuthorized {
          self?.navigateToHome()
        } else {
          self?.navigateToLogin()
        }
      }
    }
  }
  
  deinit {
    if let observer = authManagerObserver {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
  func push(_ screen: AppScreen) {
    path.append(screen)
  }
  
  func present(sheet screen: AppScreen) {
    self.sheet = screen
  }
  
  func presentFullScreen(_ screen: AppScreen) {
    self.fullScreenCover = screen
  }
  
  func dismiss() {
    sheet = nil
    fullScreenCover = nil
  }
  
  func popToRoot() {
    path = NavigationPath()
  }
  
  func navigateToLogin() {
    withAnimation(.easeInOut(duration: 0.3)) {
      popToRoot()
      dismiss()
      path.append(AppScreen.login)
    }
  }
  
  func navigateToHome() {
    withAnimation(.easeInOut(duration: 0.3)) {
      popToRoot()
      dismiss()
    }
  }
}
