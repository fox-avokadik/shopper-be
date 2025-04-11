//
//  Coordinator.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI

protocol Coordinator: ObservableObject {
  associatedtype Route
  
  var currentScreen: AnyView? { get }
  
  func start()
  func navigateTo(_ route: Route)
}
