import SwiftUI

struct LoginView: View {
  @StateObject private var viewModel: LoginViewModel
  @StateObject private var coordinator: AppCoordinator
  
  init(viewModel: LoginViewModel, coordinator: AppCoordinator) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self._coordinator = StateObject(wrappedValue: coordinator)
  }
  
  var body: some View {
    LoginContainerView {
      LoginHeaderView()
      
      LoginInputFieldsView(viewModel: viewModel)
      
      LoginActionView(viewModel: viewModel)
    }
    .onChange(of: viewModel.authStatus) {
      if viewModel.authStatus == AuthStatus.success {
        coordinator.navigateToHome()
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
