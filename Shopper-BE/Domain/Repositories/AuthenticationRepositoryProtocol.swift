//
//  AuthenticationRepositoryProtocol.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

import Foundation

protocol AuthenticationRepositoryProtocol {
  func login(email: String, password: String) async throws -> AuthenticationResponse
}
