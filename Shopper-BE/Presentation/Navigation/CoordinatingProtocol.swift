//
//  CoordinatingProtocol.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 07.04.2025.
//

import SwiftUI

protocol Coordinating: ObservableObject {
  var path: NavigationPath { get set }
  var sheet: AppScreen? { get set }
  var fullScreenCover: AppScreen? { get set }
  
  func push(_ screen: AppScreen)
  func present(sheet screen: AppScreen)
  func presentFullScreen(_ screen: AppScreen)
  func dismiss()
  func popToRoot()
  func navigateToLogin()
  func navigateToHome()
}
