//
//  InputFieldView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import SwiftUI

struct InputFieldView: View {
  @Binding var text: String
  let placeholder: String
  let isSecure: Bool
  @FocusState private var isFocused: Bool
  
  var body: some View {
    ZStack {
      fieldView
        .focused($isFocused)
        .textFieldStyle(LoginTextFieldStyle(isEmpty: text.isEmpty, isFocused: isFocused))
      
      if text.isEmpty {
        Text(placeholder)
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 16)
          .onTapGesture { isFocused = true }
      }
    }
    .frame(height: 50)
    .contentShape(Rectangle())
    .onTapGesture { isFocused = true }
    .animation(.easeInOut(duration: 0.2), value: isFocused)
  }
  
  @ViewBuilder
  private var fieldView: some View {
    if isSecure {
      SecureField("", text: $text)
    } else {
      TextField("", text: $text)
    }
  }
}

struct LoginTextFieldStyle: TextFieldStyle {
  let isEmpty: Bool
  let isFocused: Bool
  
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(isEmpty ? Color(.systemGray6) : Color(.systemGray5))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(isFocused ? .brown : .clear, lineWidth: 1)
      )
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
  }
}
