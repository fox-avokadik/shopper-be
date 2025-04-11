import SwiftUI

struct LoginView: View {
  let onAuthenticated: () -> Void
  
  @StateObject private var viewModel: LoginViewModel
  
  init(viewModel: LoginViewModel, onAuthenticated: @escaping () -> Void) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self.onAuthenticated = onAuthenticated
  }
  
  var body: some View {
    LoginContainerView {
      LoginHeaderView()
      
      LoginInputFieldsView(viewModel: viewModel)
      
      LoginActionView(viewModel: viewModel)
    }
    .onChange(of: viewModel.authStatus) {
      if viewModel.authStatus == AuthStatus.success {
        onAuthenticated()
      }
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
