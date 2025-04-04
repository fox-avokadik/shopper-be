//
//  AuthenticationService.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import IHttpClient

class AuthenticationService: AuthenticationServiceProtocol {
  private let httpClient: IHttpClient
  
  init(httpClient: IHttpClient) {
    self.httpClient = httpClient
  }
  
  /// Method for authenticating a user with email and password
  ///
  /// - Parameters:
  ///   - email: The user's email address
  ///   - password: The user's password
  /// - Returns: An `AuthenticationResponse` object containing the access token and user data
  /// - Throws: An `HTTPError` exception in case of an error
  func login(email: String, password: String) async throws -> AuthenticationResponse {
    let body = prepareRequestBody(email: email, password: password)
    
    do {
      let response: HTTPResponse<AuthenticationResponse> = try await sendLoginRequest(body: body)
      
      return response.data
    } catch {
      throw try await handleLoginError(error)
    }
  }
  
  
  /// Preparing the request body for authentication
  ///
  /// - Parameters:
  ///   - email: The email address
  ///   - password: The password
  /// - Returns: A dictionary with parameters for the POST request
  private func prepareRequestBody(email: String, password: String) -> [String: Any] {
    return [
      "email": email,
      "password": password
    ]
  }
  
  /// Sending a POST request for authentication
  ///
  /// - Parameters:
  ///   - body: The body of the request
  /// - Returns: HTTP response with authentication data
  private func sendLoginRequest(body: [String: Any]) async throws -> HTTPResponse<AuthenticationResponse> {
    let path = "/login"
    let method: HTTPMethod = .post
    
    await httpClient.addInterceptor(CookieInterceptor())
    
    return try await httpClient.request(path, method: method, parameters: body)
  }
  
  /// Handling authentication errors
  ///
  /// - Parameters:
  ///   - error: The error that occurred during the request
  /// - Returns: A specific exception of type `HTTPError`
  private func handleLoginError(_ error: Error) async throws -> HTTPError {
    if let httpError = error as? HTTPError {
      switch httpError {
      case .unknown:
        print("❌ Unknown error")
        return .unknown
      case .clientError(let statusCode, let apiResponse):
        print("❌ Client error \(statusCode): \(String(describing: apiResponse))")
        return .clientError(statusCode, apiResponse)
      case .serverError(let statusCode):
        print("❌ Server error \(statusCode)")
        return .serverError(statusCode)
      }
    } else {
      print("❌ General error: \(error.localizedDescription)")
      throw HTTPError.unknown
    }
  }
}
