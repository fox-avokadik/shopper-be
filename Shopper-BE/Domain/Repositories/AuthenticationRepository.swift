//
//  AuthenticationRepository.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import Foundation

class AuthenticationRepository: AuthenticationRepositoryProtocol {
  
  private let authService: AuthenticationService
  
  
  init(authenticationService: AuthenticationService) {
    self.authService = authenticationService
  }
  
  func login(email: String, password: String) async throws -> AuthenticationResponse {
    return try await authService.login(email: email, password: password)
  }
}
