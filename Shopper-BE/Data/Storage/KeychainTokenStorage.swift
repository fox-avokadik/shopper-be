//
//  KeychainTokenStorage.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 17.03.2025.
//

import Foundation
import Security

public class KeychainTokenStorage: TokenStorage {
  internal let accessTokenKey: String
  internal let refreshTokenKey: String
  internal let serviceIdentifier: String
  
  public init(
    accessTokenKey: String = "com.app.accessToken",
    refreshTokenKey: String = "com.app.refreshToken",
    serviceIdentifier: String = "com.app.authService"
  ) {
    self.accessTokenKey = accessTokenKey
    self.refreshTokenKey = refreshTokenKey
    self.serviceIdentifier = serviceIdentifier
  }
  
  // MARK: - TokenStorage Protocol Implementation
  
  public func getAccessToken() -> String? {
    return readFromKeychain(key: accessTokenKey)
  }
  
  public func getRefreshToken() -> String? {
    return readFromKeychain(key: refreshTokenKey)
  }
  
  public func saveAccessToken(_ token: String) {
    saveToKeychain(key: accessTokenKey, value: token)
  }
  
  public func saveRefreshToken(_ token: String) {
    saveToKeychain(key: refreshTokenKey, value: token)
  }
  
  public func clearTokens() {
    deleteFromKeychain(key: accessTokenKey)
    deleteFromKeychain(key: refreshTokenKey)
  }
  
  // MARK: - Keychain Operations
  
  private func saveToKeychain(key: String, value: String) {
    guard let data = value.data(using: .utf8) else { return }
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: serviceIdentifier,
      kSecValueData as String: data
    ]
    
    // Спочатку спробуємо видалити існуючий запис, щоб уникнути помилки дублікату
    deleteFromKeychain(key: key)
    
    // Додати новий запис
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status != errSecSuccess {
      print("Помилка збереження в Keychain: \(status)")
    }
  }
  
  private func readFromKeychain(key: String) -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: serviceIdentifier,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    guard status == errSecSuccess,
          let data = item as? Data,
          let value = String(data: data, encoding: .utf8) else {
      return nil
    }
    
    return value
  }
  
  private func deleteFromKeychain(key: String) {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: serviceIdentifier
    ]
    
    SecItemDelete(query as CFDictionary)
  }
}

// MARK: - Розширений KeychainTokenStorage з додатковими налаштуваннями безпеки

public class SecureKeychainTokenStorage: KeychainTokenStorage {
  
  public override func saveAccessToken(_ token: String) {
    saveToSecureKeychain(key: accessTokenKey, value: token)
  }
  
  public override func saveRefreshToken(_ token: String) {
    saveToSecureKeychain(key: refreshTokenKey, value: token)
  }
  
  private func saveToSecureKeychain(key: String, value: String) {
    guard let data = value.data(using: .utf8) else { return }
    
    var query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: serviceIdentifier,
      kSecValueData as String: data
    ]
    
    // Додаємо розширені налаштування безпеки
#if !targetEnvironment(simulator)
    // Доступно тільки на цьому пристрої та коли пристрій розблоковано
    query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    
    // Додатково можна встановити прапорець, щоб дані не бекапились у iCloud/iTunes
    query[kSecAttrSynchronizable as String] = kCFBooleanFalse
#endif
    
    // Видаляємо існуючий запис
    deleteFromKeychain(key: key)
    
    // Додаємо новий запис
    let status = SecItemAdd(query as CFDictionary, nil)
    
    if status != errSecSuccess {
      print("Помилка збереження в Keychain (SecureKeychainTokenStorage): \(status)")
    }
  }
  
  private func deleteFromKeychain(key: String) {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: serviceIdentifier
    ]
    
    SecItemDelete(query as CFDictionary)
  }
}
