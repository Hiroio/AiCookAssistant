//
//  NavigationManager.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import Combine
import SwiftUI

class NavigationManager: ObservableObject {
  static let shared = NavigationManager()
  
  private init() {}
  @Published var mainNavigation: MainNavigationEnum = .main
  
  @Published var secondaryScreens: secondaryScreensEnum? = nil
  @Published var loadingScreen: LoadingScreenType? = nil
  
  var isLoading: Bool {
	 get { loadingScreen != nil }
	 set { loadingScreen = newValue ? .recipeCreation : nil }
  }
  
}



enum secondaryScreensEnum {
  case creation, info(recipe: UIRecipeModel, creation: Bool = false)
}

enum LoadingScreenType {
  case recipeCreation
  case photoAnalysis
  
  var messageInterval: TimeInterval { 2 }
  
  var messages: [String] {
	 switch self {
	 case .recipeCreation:
		[
		  "Creating your recipe",
		  "Matching ingredients",
		  "Finding a photo",
		  "Almost ready"
		]
	 case .photoAnalysis:
		[
		  "Reading your photo",
		  "Finding ingredients",
		  "Checking your list",
		  "Almost ready"
		]
	 }
  }
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
