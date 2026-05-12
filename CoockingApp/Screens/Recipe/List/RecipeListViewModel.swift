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
  @Published var isEditing: Bool = false
  @Published var filter: FilterRecipeEnum = .dateDescedent
  @Published var selectedRecipe: UIRecipeModel? = nil
  private let recipesManager = RecipesManager.shared
  
  init(){
	 self.recipes = recipesManager.recipes
	 recipesManager.$recipes
		.receive(on: RunLoop.main)
		.assign(to: &$recipes)
  }
  
  var favoritesRecipes: [UIRecipeModel]{
	 recipes.filter({$0.isFavorite})
  }
  
// MARK: toggle FAVORITE
  func toggleFavorite(_ id: UUID){
	 if let index = recipes.firstIndex(where: {$0.id == id}){
		self.recipes[index].isFavorite.toggle()
	 }
	 
	 recipesManager.toggleFavorite(id)
  }
//  MARK:  DELETE
  func deleteRecipe(recipe: UIRecipeModel){
	 if let index = recipes.firstIndex(where: {$0.id == recipe.id}){
		self.recipes[index].isFavorite.toggle()
	 }
	 
	 recipesManager.deleteRecipe(recipe.id)
	 
	 recipes = recipesManager.recipes
	 selectedRecipe = nil
  }
  
  var filteredRecipes: [UIRecipeModel]{
	 let filteredRecipes: [UIRecipeModel]
	 switch filter {
	 case .dateAscedent:
		filteredRecipes = self.recipes.filter({!$0.isRecommended}).sorted(by: {$0.dateCreated < $1.dateCreated})
	 case .dateDescedent:
		filteredRecipes = self.recipes.filter({!$0.isRecommended}).sorted(by: {$0.dateCreated > $1.dateCreated})
	 case .favorite:
		filteredRecipes = self.recipes.filter({!$0.isRecommended && $0.isFavorite}).sorted(by: {$0.dateCreated > $1.dateCreated})
	 case .timesCooked:
		filteredRecipes = self.recipes.filter({!$0.isRecommended && $0.timesCooked > 0}).sorted(by: {$0.dateCreated > $1.dateCreated})
	 }
	 
	 return search(in: filteredRecipes)
  }
  
  private func search(in recipes: [UIRecipeModel]) -> [UIRecipeModel] {
	 let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
	 
	 guard !query.isEmpty else { return recipes }
	 
	 return recipes.filter { recipe in
		if searchType {
		  recipe.ingredients.contains { ingredient in
			 ingredient.localizedStandardContains(query)
		  }
		} else {
		  recipe.name.localizedStandardContains(query)
		  || recipe.description.localizedStandardContains(query)
		}
	 }
  }
}

