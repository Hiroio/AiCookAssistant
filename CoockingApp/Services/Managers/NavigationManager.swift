//
//  NavigationManager.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import Combine

class NavigationManager: ObservableObject {
  static let shared = NavigationManager()
  
  private init() {}
  
  @Published var secondaryScreens: secondaryScreensEnum? = .creation
  @Published var isLoading: Bool = false
}



enum secondaryScreensEnum {
  case creation, info(recipe: UIRecipeModel)
}
