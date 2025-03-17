//
//  ContentView.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 14.03.2025.
//

import SwiftUI
import IHttpClient

struct ContentView: View {
  @State private var email: String = "sbezhuk+4@axon.dev"
  @State private var password: String = "!Password1"
  @State private var clientId: String = "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  @State private var deviceToken: String = "your_device_token"
  
  @State private var accessToken: String?
  @State private var errorMessage: String?
  
  private let client = IHttpClient(
    baseURL: "https://sandbox.way2ten.com"
  )
  
  var body: some View {
    VStack(spacing: 20) {
      TextField("Email", text: $email)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      SecureField("Password", text: $password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      Button("Login") {
        Task {
          await authenticateUser()
        }
      }
      .padding()
      .buttonStyle(.borderedProminent)
      
      if let accessToken = accessToken {
        Text("✅ Access Token:")
          .font(.headline)
          .foregroundColor(.green)
        Text(accessToken)
          .font(.caption)
          .padding()
          .background(Color.gray.opacity(0.2))
          .cornerRadius(8)
      }
      
      if let errorMessage = errorMessage {
        Text("❌ \(errorMessage)")
          .foregroundColor(.red)
      }
    }
    .padding()
  }
  
  private func authenticateUser() async {
    let path = "/tokens/credentials"
    let method: HTTPMethod = .post
    let body: [String: Any] = [
      "email": email,
      "password": password,
      "clientId": clientId,
      "deviceToken": deviceToken
    ]
    
    do {
      await client.addInterceptor(
        RefreshTokenInterceptor(
          tokenStorage: KeychainTokenStorage(),
          refreshTokenEndpoint: "/tokens/refresh"
        )
      )
      
      let response: HTTPResponse<AuthResponse> = try await client.request(path, method: method, parameters: body)
      
      // ✅ Зберігаємо токен
      let token = response.data.accessToken
      print("🔑 Access Token: \(token)")
      
      // ✅ Виводимо юзера
      let user = response.data.userDetails
      print("👤 User: \(user.fullName), Email: \(user.email), Role: \(user.role)")
      
      accessToken = token
      errorMessage = nil
      
    } catch {
      if let httpError = error as? HTTPError {
        switch httpError {
        case .unknown:
          print("❌ Unknown HTTP error")
        case .clientError(let statusCode, let apiResponse):
          print("❌ Client error: \(statusCode), Response: \(String(describing: apiResponse))")
        case .serverError(let statusCode):
          print("❌ Server error: \(statusCode)")
        }
      } else {
        print("❌ Error is not of type HTTPError: \(error.localizedDescription)")
      }
    }
  }
  
}

#Preview {
  ContentView()
}


// MARK: - Tested data models

actor SafeHttpClient {
    private let client: IHttpClient
    
    init(client: IHttpClient) {
        self.client = client
    }
    
    // Асинхронні методи, які взаємодіють з IHttpClient
}

struct AuthResponse: Codable, Sendable {
  let accessToken: String
  let userDetails: UserDetails
  let createdAt: String
  let refreshTokenExpiredAt: Int
  let accessTokenExpiredAt: Int
  let accessTokenLifeTime: Int
}

struct UserDetails: Codable, Sendable {
  let userId: String
  let email: String
  let fullName: String
  let role: String
  let createdAt: String
}

