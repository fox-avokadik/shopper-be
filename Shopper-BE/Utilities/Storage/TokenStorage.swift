//
//  TokenStorage.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 24.03.2025.
//

import Foundation
import Security

class TokenStorage {
  private static let accessTokenKey = "access_token"
  private static let refreshTokenKey = "refresh_token"
  
  static func save(token: String, type: TokenType) {
    let key = type == .access ? accessTokenKey : refreshTokenKey
    let tokenData = token.data(using: .utf8)!
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecValueData as String: tokenData
    ]
    
    SecItemDelete(query as CFDictionary)
    SecItemAdd(query as CFDictionary, nil)
  }
  
  static func getToken(type: TokenType) -> String? {
    let key = type == .access ? accessTokenKey : refreshTokenKey
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: kCFBooleanTrue!,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
      return String(data: retrievedData, encoding: .utf8)
    }
    return nil
  }
  
  static func deleteToken(type: TokenType) {
    let key = type == .access ? accessTokenKey : refreshTokenKey
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key
    ]
    
    SecItemDelete(query as CFDictionary)
  }
}

enum TokenType {
  case access
  case refresh
}
