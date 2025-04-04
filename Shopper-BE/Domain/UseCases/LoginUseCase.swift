//
//  LoginUseCase.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import Foundation

class LoginUseCase {
  private let authenticationRepository: AuthenticationRepository
  
  init(authenticationRepository: AuthenticationRepository) {
    self.authenticationRepository = authenticationRepository
  }
  
  func execute(email: String, password: String) async throws -> AuthenticationResponse {
    return try await authenticationRepository.login(email: email, password: password)
  }
}
