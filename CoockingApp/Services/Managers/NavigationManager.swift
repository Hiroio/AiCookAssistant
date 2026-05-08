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
  @Published var popup: NavigationPopup? = nil
  
  var isLoading: Bool {
	 get { loadingScreen != nil }
	 set { loadingScreen = newValue ? .recipeCreation : nil }
  }
  
}



enum secondaryScreensEnum {
  case creation, info(recipe: UIRecipeModel, creation: Bool = false)
}

enum UsageFeature {
  case recipeGeneration
  case photoScan
  case ideas
  
  var limitTitle: String {
	 switch self {
	 case .recipeGeneration:
		"Recipe limit reached"
	 case .photoScan:
		"Scan limit reached"
	 case .ideas:
		"Ideas limit reached"
	 }
  }
  
  var limitMessage: String {
	 switch self {
	 case .recipeGeneration:
		"You’ve used all free recipe generations for this week. Please wait until next week or upgrade to Premium."
	 case .photoScan:
		"You’ve used all free photo scans for this week. Please wait until next week or upgrade to Premium."
	 case .ideas:
		"You’ve used all free ideas for this week. Please wait until next week or upgrade to Premium."
	 }
  }
}

enum NavigationPopup: Identifiable, Equatable {
  case weeklyLimit(UsageFeature)
  
  var id: String {
	 switch self {
	 case .weeklyLimit(let feature):
		return "weeklyLimit-\(feature)"
	 }
  }
  
  var icon: String {
	 switch self {
	 case .weeklyLimit:
		"clock.badge.exclamationmark"
	 }
  }
  
  var title: String {
	 switch self {
	 case .weeklyLimit(let feature):
		feature.limitTitle
	 }
  }
  
  var message: String {
	 switch self {
	 case .weeklyLimit(let feature):
		feature.limitMessage
	 }
  }
  
  var primaryButtonTitle: String {
	 switch self {
	 case .weeklyLimit:
		"Upgrade"
	 }
  }
  
  var secondaryButtonTitle: String {
	 "OK"
  }
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
  case main, recipes, products, profile
  
  var id: String{self.rawValue}
  
  var title: String{
	 switch self {
	 case .main:
		"Main"
	 case .recipes:
		"Recipes"
	 case .products:
		"Products"
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
	 case .products:
		"carrot"
	 case .profile:
		"person"
	 }
  }
}
