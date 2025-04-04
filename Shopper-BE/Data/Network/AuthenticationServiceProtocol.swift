//
//  AuthServiceProtocol.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//


protocol AuthenticationServiceProtocol {
  func login(email: String, password: String) async throws -> AuthenticationResponse
}
