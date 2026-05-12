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
  @Published var recomendedError: CreationError? = nil
  @Published var user: UserModel
  
  private let recipeManager = RecipesManager.shared
  private let geminiAPI = GeminiAPI()
  private let pexelsManager = PexelsAPI()
  private let userManager = UserManager.shared
  init(){
	 self.user = UserManager.shared.user
	 self.recipes = recipeManager.recipes
	 self.initializeRecomendedRecipe()
  }
  
  func initializeRecomendedRecipe() {
	 if recommendedRecipe == nil {
		recomendedError = nil
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
	 self.recipes.filter({ !$0.isRecommended }).sorted(by: {$0.dateCreated > $1.dateCreated})
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
			 print(error.localizedDescription)
			 self.recomendedError = CreationError.map(error)
		  }
		}
	 }
  }
  
  func generateQuickIdeaRecipe(prompt: String){
	 let user = UserManager.shared.user
	 guard StoreManager.shared.hasFullAccess || user.freeIdeasUsed < 3 else {
		NavigationManager.shared.popup = .weeklyLimit(.ideas)
		return
	 }
	 
	 NavigationManager.shared.isLoading = true
	 Task{
		defer {NavigationManager.shared.isLoading = false}
		
		do{
		  let response = try await geminiAPI.quickIdeaRequest(user: user, prompt: prompt, recipeList: recipes.recipeList)
		  let image = try await pexelsManager.searchImage(query: response.search)
		  var recipe = UIRecipeModel(recipe: response)
		  recipe.imageUrl = image ?? ""
		  await MainActor.run{
			 if !StoreManager.shared.hasFullAccess {
				self.addIdeaCount()
			 }
			 NavigationManager.shared.secondaryScreens = .info(recipe: recipe, creation: true)
		  }
		}catch{
		  await MainActor.run {
			 NavigationManager.shared.error = CreationError.map(error)
		  }
		}
	 }
  }
  
  func addIdeaCount(){
	 userManager.addIdeaGenerationUser()
	 user = userManager.user
  }
}
