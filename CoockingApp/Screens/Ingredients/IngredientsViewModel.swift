//
//  IngredientsViewModel.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import Foundation
import Combine

class IngredientsViewModel: ObservableObject{
  @Published var ingredients: [IngredientModel] = []
  @Published var category: CategoriesEnum = .vegetables
  @Published var selection: Bool = false
  @Published var selectedIngredients: [IngredientModel] = []
  
  private let ingredientManager = IngredientsManager.shared
  init(){
	 ingredients = ingredientManager.ingredients
	 ingredients = [.chicken, .dairy, .fruit, .grain, .other, .sauce, .spices, .vegi]
  }
  
  
  func selectIngredient(_ item: IngredientModel){
	 if selectedIngredients.contains(where: {$0.id == item.id}){
		selectedIngredients.removeAll(where: {$0.id == item.id})
	 }else{
		selectedIngredients.append(item)
	 }
  }
  
  var categorizedIngredients: [IngredientModel]{
	 ingredients.filter({$0.category == category})
  }
}
