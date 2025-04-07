//
//  AuthenticationManager.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 07.04.2025.
//

import SwiftUI

class AuthenticationManager: ObservableObject {
  private let authenticationStorage: AuthenticationStorageService
  @Published var isAuthorized: Bool = false
  
  init(authenticationStorage: AuthenticationStorageService) {
    self.authenticationStorage = authenticationStorage
    checkAuthorization()
  }
  
  func checkAuthorization() {
    let hasToken = authenticationStorage.loadAuthResponse()
    let oldValue = isAuthorized
    
    DispatchQueue.main.async {
      self.isAuthorized = hasToken != nil
      
      if oldValue != self.isAuthorized {
        NotificationCenter.default.post(name: NSNotification.Name("AuthStateChanged"), object: nil)
      }
    }
  }
  
  func logout() {
    authenticationStorage.clear()
    DispatchQueue.main.async {
      self.isAuthorized = false
      NotificationCenter.default.post(name: NSNotification.Name("AuthStateChanged"), object: nil)
    }
  }
  
  func setAuthorized() {
    DispatchQueue.main.async {
      self.isAuthorized = true
      NotificationCenter.default.post(name: NSNotification.Name("AuthStateChanged"), object: nil)
    }
  }
}
