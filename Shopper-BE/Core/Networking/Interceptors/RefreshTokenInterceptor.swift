//
//  RefreshTokenInterceptor.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 17.03.2025.
//

import Foundation
import IHttpClient

final class RefreshTokenInterceptor: Interceptor {
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
  
  func willSend(request: inout URLRequest) async {
    let authenticationStorage: AuthenticationStorageService = ServiceContainer.shared.resolve()
    
    guard let auth = authenticationStorage.loadAuthResponse() else { return }
    let now = Int(Date().timeIntervalSince1970)
    
    if auth.accessTokenExp > now {
      setAuthorizationHeader(&request, token: auth.accessToken)
      return
    }
    
    if auth.refreshTokenExp > now, authenticationStorage.loadRefreshToken() != nil, await refreshTokenIfNeeded() {
      if let updatedAuth = authenticationStorage.loadAuthResponse() {
        setAuthorizationHeader(&request, token: updatedAuth.accessToken)
      }
    } else {
      DispatchQueue.main.async {
        let authenticationManager: AuthenticationManager = ServiceContainer.shared.resolve()
        authenticationManager.logout()
      }
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
  
  private func setAuthorizationHeader(_ request: inout URLRequest, token: String) {
    request.addValue("\(authenticationHeaderPrefix)\(token)", forHTTPHeaderField: authenticationHeaderName)
  }
  
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
    
    let authStorageService = AuthenticationStorageService()
    guard authStorageService.loadRefreshToken() != nil else {
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
        _ = try await performTokenRefresh()
        
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
    let client = IHttpClient(baseURL: "http://185.233.119.229:8080")
    
    await client.addInterceptor(CookieInterceptor())
    
    let response: HTTPResponse<AuthenticationResponse> = try await client.request(
      "/refresh",
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
