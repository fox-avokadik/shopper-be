//
//  AnyCoordinator.swift
//  Shopper-BE
//
//  Created by Stepan Bezhuk on 11.04.2025.
//

import SwiftUI
import Combine

final class AnyCoordinator: ObservableObject {
  private let wrappedObject: AnyObject
  private let _currentScreen: () -> AnyView?
  private let _objectWillChange: () -> AnyPublisher<Void, Never>
  
  @Published private var _screenValue: AnyView?
  private var cancellables = Set<AnyCancellable>()
  
  var currentScreen: AnyView? {
    _screenValue
  }
  
  init<T: Coordinator>(_ coordinator: T) {
    self.wrappedObject = coordinator
    self._currentScreen = { coordinator.currentScreen }
    self._objectWillChange = { coordinator.objectWillChange.map { _ in () }.eraseToAnyPublisher() }
    
    coordinator.objectWillChange
      .sink { [weak self] _ in
        self?._screenValue = coordinator.currentScreen
        self?.objectWillChange.send()
      }
      .store(in: &cancellables)
    
    self._screenValue = coordinator.currentScreen
  }
}
