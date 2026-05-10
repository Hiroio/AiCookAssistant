//
//  IngredientsManager.swift
//  CoockingApp
//
//  Created by user on 09.05.2026.
//

import Foundation
import Combine

class IngredientsManager{
  static let shared = IngredientsManager()
  
  @Published var ingredients: [IngredientModel] = []
  
  private let coreDateManager = CoreDataManager.shared
  private init() {
	 fetch()
  }
  
  func fetch() {
	 let entities = coreDateManager.fetchIngredients()
	 
	 self.ingredients = entities.map({ IngredientModel(entity: $0)})
  }
  
  func createIngredient(ingredient: IngredientModel){
	 ingredients.append(ingredient)
	 
	 coreDateManager.createIngredients(ingredient: ingredient)
  }
  
  func toggleFavorite(ingredient: IngredientModel){
	 if let index = ingredients.firstIndex(where: {$0.id == ingredient.id}){
		ingredients[index].isFavorite.toggle()
	 }
	 
	 coreDateManager.toggleFavorite(ingredient: ingredient)
  }
}

// MARK: CHECKING
extension IngredientsManager{
  
  func chekingNewIngredients(ingreedients: [String: String]) {
	 Task(priority: .background){
		var newList: [IngredientModel] = []
		
		for (rawName, rawCategory) in ingreedients{
		  let name = rawName.split(separator: "-").first?.trimmingCharacters(in: .whitespacesAndNewlines)
		  guard let name, !name.isEmpty else { continue }
		  
		  let categoryKey = rawCategory
			 .trimmingCharacters(in: .whitespacesAndNewlines)
			 .lowercased()
		  
		  let category = CategoriesEnum(rawValue: categoryKey) ?? .other
		  let ingredient = IngredientModel(
			 id: UUID(),
			 name: name.capitalized,
			 category: category,
			 isFavorite: false
		  )
		  
		  newList.append(ingredient)
		}
		
		for i in newList{
		  await MainActor.run {
			 let exist = self.ingredients.contains(where: {
				$0.name.compare(i.name, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
			 })
			 
			 if !exist{
				self.createIngredient(ingredient: i)
			 }
		  }
		}
	 }
  }
}
