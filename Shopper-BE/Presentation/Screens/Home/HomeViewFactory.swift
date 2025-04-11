//
//  HomeViewFactory.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

class HomeViewFactory {
  static func createHomeView(onLogout: @escaping () -> Void) -> some View {
    return HomeView(onLogout: onLogout)
  }
}
