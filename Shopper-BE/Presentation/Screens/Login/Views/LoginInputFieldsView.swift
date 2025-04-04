//
//  LoginInputFieldsView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

struct LoginInputFieldsView: View {
  @ObservedObject var viewModel: LoginViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      EmailFieldView(email: $viewModel.email)
      PasswordFieldView(password: $viewModel.password)
    }
  }
}

private struct EmailFieldView: View {
  @Binding var email: String
  
  var body: some View {
    InputFieldView(
      text: $email,
      placeholder: "Email",
      isSecure: false
    )
  }
}

private struct PasswordFieldView: View {
  @Binding var password: String
  
  var body: some View {
    InputFieldView(
      text: $password,
      placeholder: "Password",
      isSecure: true
    )
  }
}
