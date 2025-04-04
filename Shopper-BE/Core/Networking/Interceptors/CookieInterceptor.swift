//
//  CookieInterceptor.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 24.03.2025.
//

import Foundation
import IHttpClient

final class CookieInterceptor: Interceptor {
  private let refreshTokenEndpoint = "/refresh"
  private let refrehsTokenCookieName = "refreshToken"
  
  public func willSend(request: inout URLRequest) {
    guard shouldAttachRefreshToken(to: request), let refreshToken = TokenStorage.getToken(type: .refresh) else {
      return
    }
    
    request.setValue(makeRefreshTokenCookie(refreshToken), forHTTPHeaderField: "Cookie")
  }
  
  public func didReceive(response: URLResponse, data: Data) {
    guard let httpResponse = response as? HTTPURLResponse else { return }
    
    if let setCookieHeader = httpResponse.allHeaderFields["Set-Cookie"] as? String {
      if let refreshToken = extractRefreshToken(from: setCookieHeader) {
        TokenStorage.save(token: refreshToken, type: .refresh)
      }
    }
    
    if let authenticationResponse = extractAccessToken(from: data) {
      let accessToken = authenticationResponse.accessToken
      TokenStorage.save(token: accessToken, type: .access)
    }
  }
  
  private func shouldAttachRefreshToken(to request: URLRequest) -> Bool {
    return request.url?.path == refreshTokenEndpoint
  }
  
  private func makeRefreshTokenCookie(_ token: String) -> String {
    return "\(refrehsTokenCookieName)=\(token); Path=/; HttpOnly"
  }
  
  private func extractRefreshToken(from setCookieHeader: String) -> String? {
    let cookies = setCookieHeader.components(separatedBy: "; ")
    for cookie in cookies {
      if cookie.starts(with: "\(refrehsTokenCookieName)=") {
        return cookie.replacingOccurrences(of: "\(refrehsTokenCookieName)=", with: "")
      }
    }
    return nil
  }
  
  private func extractAccessToken(from data: Data) -> AuthenticationResponse? {
    return try? JSONDecoder().decode(AuthenticationResponse.self, from: data)
  }
}
