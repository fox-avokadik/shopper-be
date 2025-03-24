//
//  RefreshTokenInterceptor.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 17.03.2025.
//

import Foundation
import IHttpClient

final class RefreshTokenInterceptor: Interceptor {
  // MARK: - Properties
  private let authenticationHeaderName = "Authorization"
  private let authenticationHeaderPrefix = "Bearer "
  
  private let refreshLock = NSLock()
  private actor RefreshState {
    private var isRefreshing = false
    private var refreshCompletionHandlers = [(Bool) -> Void]()
    
    func setRefreshing(_ value: Bool) {
      isRefreshing = value
    }
    
    func isCurrentlyRefreshing() -> Bool {
      return isRefreshing
    }
    
    func addCompletionHandler(_ handler: @escaping (Bool) -> Void) {
      refreshCompletionHandlers.append(handler)
    }
    
    func getAndClearHandlers() -> [(Bool) -> Void] {
      let handlers = refreshCompletionHandlers
      refreshCompletionHandlers.removeAll()
      return handlers
    }
  }
  
  private let refreshState = RefreshState()
  
  // MARK: - Interceptor Methods
  
  func willSend(request: inout URLRequest) {
    if let accessToken = TokenStorage.getToken(type: .access) {
      request.addValue("\(authenticationHeaderPrefix)\(accessToken)", forHTTPHeaderField: authenticationHeaderName)
    }
  }
  
  func onError<T: Decodable>(
    response: HTTPURLResponse,
    data: Data,
    originalRequest: (path: String, method: HTTPMethod, parameters: HTTPParameters?, headers: [String: String]?),
    client: DefaultHttpClient
  ) async throws -> HTTPResponse<T>? {
    guard response.statusCode == 401 else { return nil }
    
    let refreshed = await refreshTokenIfNeeded()
    
    guard refreshed else { return nil }
    
    return try await client.request(
      originalRequest.path,
      method: originalRequest.method,
      parameters: originalRequest.parameters,
      headers: originalRequest.headers
    )
  }
  
  // MARK: - Private Methods
  
  /// Refreshes the authentication token if needed
  /// - Returns: Boolean indicating whether the refresh was successful
  private func refreshTokenIfNeeded() async -> Bool {
    if await refreshState.isCurrentlyRefreshing() {
      return await withCheckedContinuation { continuation in
        Task {
          await refreshState.addCompletionHandler { success in
            continuation.resume(returning: success)
          }
        }
      }
    }
    
    guard let refreshToken = TokenStorage.getToken(type: .refresh) else {
      return false
    }
    
    return await Task {
      if await refreshState.isCurrentlyRefreshing() {
        return await withCheckedContinuation { continuation in
          Task {
            await refreshState.addCompletionHandler { success in
              continuation.resume(returning: success)
            }
          }
        }
      }
      
      await refreshState.setRefreshing(true)
      
      do {
        let tokenResponse = try await performTokenRefresh()
        
        await notifyRefreshCompletion(true)
        return true
      } catch {
        await notifyRefreshCompletion(false)
        return false
      }
    }.value
  }
  
  /// Performs the token refresh network request
  /// - Parameter refreshToken: The current refresh token
  /// - Returns: The new token response
  private func performTokenRefresh() async throws -> AuthenticationResponse {
    let client = IHttpClient(baseURL: "https://sandbox.way2ten.com")
    
    await client.addInterceptor(CookieInterceptor())
    
    let response: HTTPResponse<AuthenticationResponse> = try await client.request(
      "/tokens/refresh",
      method: .post
    )
    
    return response.data
  }
  
  /// Updates the refreshing state and notifies waiting handlers
  /// - Parameter success: Whether the refresh operation was successful
  private func notifyRefreshCompletion(_ success: Bool) async {
    let handlers = await refreshState.getAndClearHandlers()
    await refreshState.setRefreshing(false)
    
    for handler in handlers {
      handler(success)
    }
  }
}
