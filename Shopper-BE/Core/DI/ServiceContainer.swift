//
//  ServiceContainer.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import Foundation

class ServiceContainer {
  static let shared = ServiceContainer()
  
  private var services: [String: Any] = [:]
  
  private init() {}
  
  func register<T>(_ service: T) {
    let key = String(describing: T.self)
    
    services[key] = service
  }
  
  func resolve<T>() -> T? {
    let key = String(describing: T.self)
  
    guard let service = services[key] as? T else {
      fatalError("Dependency \(key) not found in container")
    }
    
    return service
  }
}
