//
//  AuthenticationResponse.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 24.03.2025.
//

struct AuthenticationResponse: Codable, Sendable {
  let accessToken: String
  let userDetails: UserDetails
  let createdAt: String
  let refreshTokenExpiredAt: Int
  let accessTokenExpiredAt: Int
  let accessTokenLifeTime: Int
}
