//
//  MainViewModel.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject{
  @Published var recipes: [UIRecipeModel] = []
  @Published var recomendedLoading: Bool = false
  @Published var recomendedError: CreationError? = .badInternetConnection

  private let recipeManager = RecipesManager.shared
  private let geminiAPI = GeminiAPI()
  private let pexelsManager = PexelsAPI()
  init(){
	 self.recipes = recipeManager.recipes
  }
  
  func initializeRecomendedRecipe() {
	 if recommendedRecipe == nil {
		generateRecomendedRecipe()
	 }
  }
  
  var recommendedRecipe: UIRecipeModel?{
	 let recommended = self.recipes.filter({
		$0.recommendedDate?.inToday() ?? false && $0.isRecommended
	 })
	 
	 return recommended.first(where: {$0.recommendedDate?.inToday() ?? false})
  }
  
  var latestRecipes: [UIRecipeModel]{
	 self.recipes.filter({ !$0.isRecommended })
  }
  
}



extension MainViewModel{
  func generateRecomendedRecipe() {
	 let user = UserManager.shared.user
	 self.recomendedLoading = true
	 Task{
		defer {recomendedLoading = false}
		do{
		  let response = try await geminiAPI.recomendedRequest(user: user, recipeList: self.recipes.recipeList)
		  let image = try await pexelsManager.searchImage(query: response.search)
		  var recipe = UIRecipeModel(recipe: response, isRecommended: true, recomendedDate: Date())
		  recipe.imageUrl = image ?? ""
		  await MainActor.run{
			 RecipesManager().createRecipe(recipe: recipe)
			 self.recipes.insert(recipe, at: 0)
		  }
		}catch{
		  await MainActor.run {
			 self.recomendedError = CreationError.map(error)
		  }
		}
	 }
  }
}
