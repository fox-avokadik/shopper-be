//
//  HomeView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    Button {
      let authenticationManager: AuthenticationManager = ServiceContainer.shared.resolve()
      authenticationManager.logout()
    } label: {
      Text("Back")
    }
  }
}
