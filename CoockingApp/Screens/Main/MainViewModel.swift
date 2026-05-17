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
  @Published var user: UserModel
  
  private let recipeManager = RecipesManager.shared
  private let geminiAPI = GeminiAPI()
  private let pexelsManager = PexelsAPI()
  private let userManager = UserManager.shared
  private var recipesTask: Task<Void, Never>?
  
  init(){
	 self.user = UserManager.shared.user
	 self.recipes = recipeManager.recipes
	 observeRecipes()
	 self.initializeRecomendedRecipe()
  }
  
  deinit {
	 recipesTask?.cancel()
  }
  
  func initializeRecomendedRecipe() {
	 if recommendedRecipe == nil && !recomendedLoading {
		recomendedError = nil
		generateRecomendedRecipe()
	 }
  }
  
  private func observeRecipes() {
	 let publisher = recipeManager.$recipes
	 recipesTask = Task { [weak self] in
		for await recipes in publisher.values {
		  await MainActor.run {
			 self?.recipes = recipes
			 self?.initializeRecomendedRecipe()
		  }
		}
	 }
  }
  
  var recommendedRecipe: UIRecipeModel?{
	 let recommended = self.recipes.filter({
		$0.recommendedDate?.inToday() ?? false
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
				 let _ = recipeManager.createRecipe(recipe: recipe)
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
