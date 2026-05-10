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
  
  func saveRecomended(){
//	 TODO: Core data swift isRecomended
  }
  
  func toggleFavorite(_ id: UUID){
	 if let index = recipes.firstIndex(where: {$0.id == id}){
		self.recipes[index].isFavorite.toggle()
	 }
	 
	 coreDataManager.toggleFavorite(id)
	 
	 fetchRecipe()
  }
  
  func incrementTimesCooked(_ id: UUID){
	 if let index = recipes.firstIndex(where: {$0.id == id}){
		recipes[index].timesCooked += 1
	 }
	 
	 coreDataManager.incrementTimesCooked(id)
	 
	 fetchRecipe()
  }
  
}
