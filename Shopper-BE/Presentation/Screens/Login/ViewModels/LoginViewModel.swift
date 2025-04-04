//
//  LoginViewModel.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import Foundation
import IHttpClient

@MainActor
class LoginViewModel: ObservableObject {
  private let loginUseCase: LoginUseCase
  
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var errorMessage: String?
  @Published var isLoading: Bool = false
  
  init(loginUseCase: LoginUseCase) {
    self.loginUseCase = loginUseCase
  }
  
  var isFormValid: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  func authenticateUser() async {
    self.isLoading = true
    
    do {
      let response = try await loginUseCase.execute(email: email, password: password)
      self.handleSuccess(response: response)
    } catch {
      let errorMessage = handleLoginError(error)
      
      self.errorMessage = errorMessage
      print("Login error: \(errorMessage)")
    }
    
    self.isLoading = false
  }
  
  private func handleSuccess(response: AuthenticationResponse) {
    print("Token: \(response.accessToken)")
    self.errorMessage = nil
  }
  
  private func handleLoginError(_ error: Error) -> String {
    if let httpError = error as? HTTPError {
      let errorMessage = httpError.message
      if let errorCode = httpError.code {
        return "Error: \(errorMessage), Code: \(errorCode)"
      } else {
        return errorMessage
      }
    } else {
      return "An unexpected error occurred: \(error.localizedDescription)"
    }
  }
}
