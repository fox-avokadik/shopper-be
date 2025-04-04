//
//  LoginView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 25.03.2025.
//

//import SwiftUI
//
//struct LoginView: View {
//  @StateObject private var viewModel: LoginViewModel
//
//  init() {
//    if let viewModel: LoginViewModel = ServiceContainer.shared.resolve() {
//      self._viewModel = StateObject(wrappedValue: viewModel)
//    }  else {
//      fatalError("LoginViewModel not found in DI container.")
//    }
//  }
//
//  var body: some View {
//    VStack {
//      LoginHeaderView()
//
//      LoginFormView(viewModel: viewModel)
//
//      if viewModel.isLoading {
//        ProgressView()
//      } else {
//        LoginButton(viewModel: viewModel)
//      }
//    }
//    .padding(.horizontal, 25)
//    .padding(.vertical)
//  }
//}
//
//#Preview {
//  LoginView()
//}


import SwiftUI

struct LoginView: View {
  @StateObject private var viewModel: LoginViewModel
  
  init() {
    if let viewModel: LoginViewModel = ServiceContainer.shared.resolve() {
      self._viewModel = StateObject(wrappedValue: viewModel)
    }  else {
      fatalError("LoginViewModel not found in DI container.")
    }
  }
  
  var body: some View {
    LoginContainerView {
      LoginHeaderView()
      
      LoginInputFieldsView(viewModel: viewModel)
      
      LoginActionView(viewModel: viewModel)
    }
  }
}

struct LoginContainerView<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    VStack(spacing: 20) {
      content
    }
    .padding(.horizontal, 25)
    .padding(.vertical)
  }
}
