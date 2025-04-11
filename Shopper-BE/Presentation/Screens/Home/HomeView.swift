//
//  HomeView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

struct HomeView: View {
  let onLogout: () -> Void
  
  init(onLogout: @escaping () -> Void) {
    self.onLogout = onLogout
  }
  
  var body: some View {
    Button {
      onLogout()
    } label: {
      Text("Back")
    }
  }
}
