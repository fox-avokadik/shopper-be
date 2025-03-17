//
//  RefreshTokenInterceptor.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 17.03.2025.
//

import Foundation
import IHttpClient

final class RefreshTokenInterceptor: Interceptor {
  private let tokenStorage: TokenStorage
  private let refreshTokenEndpoint: String
  private var isRefreshing = false
  private var refreshCompletionHandlers: [(Bool) -> Void] = []
  
  public init(tokenStorage: TokenStorage, refreshTokenEndpoint: String) {
    self.tokenStorage = tokenStorage
    self.refreshTokenEndpoint = refreshTokenEndpoint
  }
  
  public func willSend(request: inout URLRequest) {
    if let accessToken = tokenStorage.getAccessToken() {
      request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
  }
  
  public func didReceive(response: URLResponse, data: Data) { }
  
  public func onError<T: Decodable>(
    response: HTTPURLResponse,
    data: Data,
    originalRequest: (path: String, method: HTTPMethod, parameters: HTTPParameters?, headers: [String: String]?),
    client: IHttpClient
  ) async throws -> HTTPResponse<T>? {
    guard response.statusCode == 401 else { return nil }
    
    let refreshed = await refreshTokenIfNeeded()
    
    if refreshed {
      let result: HTTPResponse<T> = try await client.request(
        originalRequest.path,
        method: originalRequest.method,
        parameters: originalRequest.parameters,
        headers: originalRequest.headers
      )
      return result
    }
    
    return nil
  }
  
  private func refreshTokenIfNeeded() async -> Bool {
    if isRefreshing {
      return await withCheckedContinuation { continuation in
        refreshCompletionHandlers.append { success in
          continuation.resume(returning: success)
        }
      }
    }
    
    guard let refreshToken = tokenStorage.getRefreshToken() else {
      return false
    }
    
    isRefreshing = true
    
    do {
      let client = IHttpClient(baseURL: "")
      
      let parameters: HTTPParameters = [
        "refreshToken": refreshToken
      ]
      
      let response: HTTPResponse<TokenResponse> = try await client.request(
        refreshTokenEndpoint,
        method: .post,
        parameters: parameters
      )

      let tokenData = response.data
      
      tokenStorage.saveAccessToken(tokenData.accessToken)
      tokenStorage.saveRefreshToken(tokenData.refreshToken)
      notifyRefreshCompletion(true)
      isRefreshing = false
      
      return true
    } catch {
      notifyRefreshCompletion(false)
      isRefreshing = false
      return false
    }
  }
  
  
  private func notifyRefreshCompletion(_ success: Bool) {
    let handlers = refreshCompletionHandlers
    refreshCompletionHandlers.removeAll()
    
    for handler in handlers {
      handler(success)
    }
  }
}

// MARK: - Додаткові структури, необхідні для роботи інтерсептора



/// Структура для десеріалізації відповіді з оновленими токенами
struct TokenResponse: Decodable {
  let accessToken: String
  let refreshToken: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
  }
}
