//
//  AuthenticationStorageService.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 24.03.2025.
//

import Foundation
import Security

final class AuthenticationStorageService {
  
  // MARK: - Keys
  private let accessTokenKey = "auth_response"
  private let refreshTokenKey = "refresh_token"
  
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  // MARK: - Save
  
  func saveAuthResponse(_ response: AuthenticationResponse) {
    do {
      let data = try encoder.encode(response)
      saveToKeychain(data, forKey: accessTokenKey)
    } catch {
      print("❌ Failed to encode AuthenticationResponse:", error)
    }
  }
  
  func saveRefreshToken(_ token: String) {
    saveToKeychain(token.data(using: .utf8)!, forKey: refreshTokenKey)
  }
  
  // MARK: - Load
  
  func loadAuthResponse() -> AuthenticationResponse? {
    guard let data = loadFromKeychain(forKey: accessTokenKey) else { return nil }
    do {
      return try decoder.decode(AuthenticationResponse.self, from: data)
    } catch {
      print("❌ Failed to decode AuthenticationResponse:", error)
      return nil
    }
  }
  
  func loadRefreshToken() -> String? {
    guard let data = loadFromKeychain(forKey: refreshTokenKey) else { return nil }
    return String(data: data, encoding: .utf8)
  }
  
  // MARK: - Clear
  
  func clear() {
    deleteFromKeychain(forKey: accessTokenKey)
    deleteFromKeychain(forKey: refreshTokenKey)
  }
  
  // MARK: - Internal Keychain Helpers
  
  private func saveToKeychain(_ data: Data, forKey key: String) {
    deleteFromKeychain(forKey: key) // overwrite if exists
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecValueData as String: data
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    if status != errSecSuccess {
      print("❌ Failed to save \(key) to Keychain. Status:", status)
    }
  }
  
  private func loadFromKeychain(forKey key: String) -> Data? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    guard status == errSecSuccess, let data = result as? Data else {
      return nil
    }
    return data
  }
  
  private func deleteFromKeychain(forKey key: String) {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key
    ]
    SecItemDelete(query as CFDictionary)
  }
}
