//
//  RecipesManager.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import Foundation
import Combine

class RecipesManager{
  static let shared = RecipesManager()
  
  @Published var recipes: [UIRecipeModel] = []
  
  private let coreDataManager = CoreDataManager.shared
  init(){
	 fetchRecipe()
  }
  
  func fetchRecipe(){
	 let entities = coreDataManager.fetchRecipes()
	 self.recipes = entities.map({UIRecipeModel(entity: $0)})
  }
  
  func createRecipe(recipe: UIRecipeModel){
	 coreDataManager.createRecipe(recipe: recipe)
	 NavigationManager.shared.secondaryScreens = nil
	 fetchRecipe()
  }
  
  
}
