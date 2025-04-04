//
//  LoginHeaderView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

struct LoginHeaderView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 30) {
      BrandLogoView()
      TitleView()
    }
    .horizontalLeading()
    .padding(.bottom, 15)
  }
}

private struct BrandLogoView: View {
  var body: some View {
    Circle()
      .trim(from: 0, to: 0.5)
      .fill(.black)
      .frame(width: 45, height: 45)
      .rotationEffect(.degrees(-90))
      .offset(x: -22)
  }
}

private struct TitleView: View {
  var body: some View {
    Text("Hey, \nLogin Now")
      .font(.system(size: 34, weight: .bold))
      .foregroundStyle(.black)
  }
}
