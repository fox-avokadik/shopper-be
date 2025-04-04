//
//  ContentView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 14.03.2025.
//

import SwiftUI
import IHttpClient

struct ContentView: View {
  @EnvironmentObject private var appState: AppState
  
  var body: some View {
    if appState.isReady {
      RouterView()
    } else {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

#Preview {
  ContentView()
}
