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
  @Published var mainNavigation: MainNavigationEnum = .main
  
  @Published var secondaryScreens: secondaryScreensEnum? = nil
  @Published var isLoading: Bool = false
}



enum secondaryScreensEnum {
  case creation, info(recipe: UIRecipeModel)
}

enum MainNavigationEnum:String, CaseIterable, Identifiable{
  case main, recipes, favorites, profile
  
  var id: String{self.rawValue}
  
  var title: String{
	 switch self {
	 case .main:
		"Main"
	 case .recipes:
		"Recipes"
	 case .favorites:
		"Favorites"
	 case .profile:
		"Profile"
	 }
  }
  
  var icon: String{
	 switch self {
	 case .main:
		"house"
	 case .recipes:
		"list.bullet.rectangle"
	 case .favorites:
		"heart"
	 case .profile:
		"person"
	 }
  }
}
