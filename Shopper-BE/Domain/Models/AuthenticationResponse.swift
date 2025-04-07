//
//  AuthenticationResponse.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

struct AuthenticationResponse: Codable {
  let accessToken: String
  let accessTokenExp: Int
  let refreshTokenExp: Int
  let user: User
  
  enum CodingKeys: String, CodingKey {
    case accessToken
    case accessTokenExp
    case refreshTokenExp
    case user
  }
}
