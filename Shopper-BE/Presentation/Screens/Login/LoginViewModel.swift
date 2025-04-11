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
  
  #if DEBUG
  @Published var email: String = "john@example.com"
  @Published var password: String = "!Password1"
  #else
  @Published var email: String = ""
  @Published var password: String = ""
  #endif
  @Published var errorMessage: String?
  @Published var authStatus: AuthStatus = .idle
  
  public init(loginUseCase: LoginUseCase) {
    self.loginUseCase = loginUseCase
  }
  
  public var isFormValid: Bool {
    !email.isEmpty && !password.isEmpty
  }
  
  public func authenticateUser() async {
    guard isFormValid else { return }
    
    authStatus = .loading
    errorMessage = nil
    
    do {
      let response = try await loginUseCase.execute(
        email: email,
        password: password
      )
      
      handleSuccess(response: response)
    } catch {
      handleLoginError(error)
    }
  }
  
  private func handleSuccess(response: AuthenticationResponse) {
    authStatus = .success
    self.errorMessage = nil
  }
  
  private func handleLoginError(_ error: Error) {
    authStatus = .failure
    
    if let httpError = error as? HTTPError {
      self.errorMessage = formatHTTPError(httpError)
    } else {
      self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
    }
  }
  
  private func formatHTTPError(_ error: HTTPError) -> String {
    let errorMessage = error.message
    if let errorCode = error.code {
      return "Error: \(errorMessage), Code: \(errorCode)"
    } else {
      return errorMessage
    }
  }
}

enum AuthStatus {
  case idle
  case loading
  case success
  case failure
}
