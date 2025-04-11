//
//  Routable.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI

protocol Routable {
  associatedtype Route
  associatedtype Content: View
  
  func view(for route: Route) -> Content
}
