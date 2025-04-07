//
//  AppScreen.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 07.04.2025.
//

import Foundation

enum AppScreen: Identifiable, Hashable {
  case login
  case home
  
  var id: String {
    switch self {
    case .login:
      return "login"
    case .home:
      return "home"
    }
  }
}
