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
	 checkForOldRecomendations()
  }
  
  func fetchRecipe(){
	 let entities = coreDataManager.fetchRecipes()
	 self.recipes = entities.map({UIRecipeModel(entity: $0)})
  }
  
  func checkForOldRecomendations(){
	 let old = recipes.filter({ !($0.recommendedDate?.inToday() ?? true) && $0.isRecommended})
	 
	 guard !old.isEmpty else { return }
	 
	 let deleted = old.map { deleteRecomended($0.id) }
	 
	 if deleted.contains(true) {
		fetchRecipe()
	 }
  }
  
  @discardableResult
  func createRecipe(recipe: UIRecipeModel) -> Bool {
	 let success = coreDataManager.createRecipe(recipe: recipe)
	 if success {
		fetchRecipe()
	 }
	 return success
  }
  
  @discardableResult
  func saveRecomended(_ id: UUID) -> Bool {
	 let success = coreDataManager.saveRecomended(id)
	 if success {
		fetchRecipe()
	 }
	 return success
  }
  
  @discardableResult
  func deleteRecomended(_ id: UUID) -> Bool {
	 let success = coreDataManager.deleteRecomended(id)
	 if success {
		fetchRecipe()
	 }
	 return success
  }
  
  
  @discardableResult
  func deleteRecipe(_ id: UUID) -> Bool {
	 let success = coreDataManager.deleteRecipe(id)
	 if success {
		fetchRecipe()
	 }
	 return success
  }
  
  @discardableResult
  func toggleFavorite(_ id: UUID) -> Bool {
	 let success = coreDataManager.toggleFavorite(id)
	 if success {
		fetchRecipe()
	 }
	 return success
  }
  
  @discardableResult
  func incrementTimesCooked(_ id: UUID) -> Bool {
	 let success = coreDataManager.incrementTimesCooked(id)
	 if success {
		fetchRecipe()
	 }
	 return success
  }
  
}
