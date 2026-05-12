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
//mock
	 //	 ingredients = [.chicken, .dairy, .fruit, .grain, .other, .sauce, .spices, .vegi]
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


//MARK: Functions
extension IngredientsViewModel{
  //  Selection
	 func selectIngredient(_ item: IngredientModel){
		if selectedIngredients.contains(where: {$0.id == item.id}){
		  selectedIngredients.removeAll(where: {$0.id == item.id})
		}else{
		  selectedIngredients.append(item)
		}
	 }
	 
  //  ToogleFavorite
	 func toggleFavorite(_ item: IngredientModel){
		if let index = ingredients.firstIndex(where: {$0.id == item.id}){
		  ingredients[index].isFavorite.toggle()
		}
		
		ingredientManager.toggleFavorite(ingredient: item)
	 }
  
//  DELTE
  func deleteSelected(){
	 ingredientManager.deleteSelected(selected: selectedIngredients)
	 ingredients.removeAll(where: {item in selectedIngredients.contains(where: {$0.id == item.id})})
	 ingredients = ingredientManager.ingredients
	 selectedIngredients.removeAll()
  }
}
