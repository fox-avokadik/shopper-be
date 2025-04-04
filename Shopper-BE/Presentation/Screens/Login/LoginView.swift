import SwiftUI

struct LoginView: View {
  @StateObject private var appRouter: AppRouter
  @StateObject private var viewModel: LoginViewModel
  
  init(viewModel: LoginViewModel, appRouter: AppRouter) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self._appRouter = StateObject(wrappedValue: appRouter)
  }
  
  var body: some View {
    LoginContainerView {
      LoginHeaderView()
      
      LoginInputFieldsView(viewModel: viewModel)
      
      LoginActionView(viewModel: viewModel)
    }
    .onChange(of: viewModel.authStatus) {
      if viewModel.authStatus == AuthStatus.success {
        appRouter.navigate(to: .home)
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
