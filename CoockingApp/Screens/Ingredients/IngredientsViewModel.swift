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
  @Published var category: CategoriesEnum = .all
  @Published var selection: Bool = false
  @Published var selectedIngredients: [IngredientModel] = []
  
  private let ingredientManager = IngredientsManager.shared
  init(){
	 ingredients = ingredientManager.ingredients
//	 ingredients = [.chicken, .dairy, .fruit, .grain, .other, .sauce, .spices, .vegi] mock
  }
  
  
  func selectIngredient(_ item: IngredientModel){
	 if selectedIngredients.contains(where: {$0.id == item.id}){
		selectedIngredients.removeAll(where: {$0.id == item.id})
	 }else{
		selectedIngredients.append(item)
	 }
  }
  
  func toggleFavorite(_ item: IngredientModel){
	 if let index = ingredients.firstIndex(where: {$0.id == item.id}){
		ingredients[index].isFavorite.toggle()
	 }
	 
	 ingredientManager.toggleFavorite(ingredient: item)
  }
  
  var categorizedIngredients: [IngredientModel]{
	 switch category {
	 case .favorite:
		ingredients.filter({$0.isFavorite})
	 case .all:
		ingredients
	 default:
		ingredients.filter({$0.category == category})
	 }
	 
  }
}
