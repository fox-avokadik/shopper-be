//
//  User.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 04.04.2025.
//

struct User: Codable {
  let id: String
  let name: String
  let email: String
  let createdAt: String
  let updatedAt: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case createdAt
    case updatedAt
  }
}
