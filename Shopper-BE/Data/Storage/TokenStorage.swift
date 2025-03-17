//
//  TokenStorage.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 17.03.2025.
//

import Foundation

public protocol TokenStorage: Sendable {
  func getAccessToken() -> String?
  func getRefreshToken() -> String?
  func saveAccessToken(_ token: String)
  func saveRefreshToken(_ token: String)
  func clearTokens()
}
