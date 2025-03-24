//
//  UserDetails.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 24.03.2025.
//

struct UserDetails: Codable, Sendable {
  let userId: String
  let email: String
  let fullName: String
  let role: String
  let createdAt: String
}
