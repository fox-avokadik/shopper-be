//
//  AppState.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

@MainActor
final class AppState: ObservableObject {
  @Published var isReady = false
}
