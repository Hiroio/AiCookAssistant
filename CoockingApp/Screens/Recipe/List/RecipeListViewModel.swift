//
//  RecipeListViewModel.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import Foundation
import Combine


class RecipeListViewModel: ObservableObject{
  @Published var recipes: [UIRecipeModel] = []
  @Published var searchType: Bool = false
  @Published var searchText: String = ""
  
  private let recipesManager = RecipesManager.shared
  
  init(){
	 self.recipes = recipesManager.recipes
  }
  
  var favoritesRecipes: [UIRecipeModel]{
	 recipes.filter({$0.isFavorite})
  }
  
//  TODO: FAVORITE
  func toggleFavorite(_ id: UUID){
	 if let index = recipes.firstIndex(where: {$0.id == id}){
		self.recipes[index].isFavorite.toggle()
	 }
	 
	 recipesManager.toggleFavorite(id)
  }
//  TODO: DELETE
  
  
  var filteredRecipes: [UIRecipeModel]{
	 self.recipes.filter({!$0.isRecommended}).sorted(by: {$0.dateCreated > $1.dateCreated})
  }
}


enum FilterRecipeEnum: String, Identifiable, CaseIterable{
  case dateAscedent, dateDescedent, favorite
  
  var id: String { self.rawValue }
  
  var icon: String{
	 switch self {
	 case .dateAscedent:
		""
	 case .dateDescedent:
		""
	 case .favorite:
		""
	 }
  }
}
