//
//  LoginActionView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

struct LoginActionView: View {
  @ObservedObject var viewModel: LoginViewModel
  
  var body: some View {
    Group {
      if viewModel.isLoading {
        ProgressView()
      } else {
        LoginButton(viewModel: viewModel)
      }
    }
    .frame(height: 50)
  }
}

private struct LoginButton: View {
  @ObservedObject var viewModel: LoginViewModel
  
  var body: some View {
    Button(action: handleLogin) {
      Text("Login")
        .loginButtonStyle()
    }
    .disabled(!viewModel.isFormValid)
    .opacity(viewModel.isFormValid ? 1 : 0.5)
  }
  
  private func handleLogin() {
    Task {
      await viewModel.authenticateUser()
    }
  }
}
