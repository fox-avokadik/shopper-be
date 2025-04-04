//
//  View.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

extension View {
  func horizontalLeading() -> some View {
    self.frame(maxWidth: .infinity, alignment: .leading)
  }
  
  func horizontalTrailing() -> some View {
    self.frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  func horizontalCenter() -> some View {
    self.frame(maxWidth: .infinity, alignment: .center)
  }
}

extension Text {
  func loginButtonStyle() -> some View {
    self
      .fontWeight(.semibold)
      .foregroundStyle(.white)
      .padding()
      .frame(maxWidth: .infinity)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(.brown)
      )
  }
}
