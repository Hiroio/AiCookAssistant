//
//  CreationViewModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CreationViewModel: ObservableObject{
  @Published var recipe: RecipeModel? = nil
  @Published var userIngredients: [String] = []
  @Published var selectedTime: String = "< 20"
  @Published var difficulty: Int = 2
  @Published var userNote: String = ""
  @Published var error: CreationError? = nil
  
  private let apiManager = GeminiAPI()
  private let pexelsManager = PexelsAPI()
  private let user: UserModel
  
  init(){
	 let entity = CoreDataManager.shared.fetchUser()
	 self.user = UserModel(entity: entity)
  }
  
  var loading: LoadingScreenType? {
	 get{
		NavigationManager.shared.loadingScreen
	 }
	 set{
		NavigationManager.shared.loadingScreen = newValue
	 }
  }
  
  func request(){
	 loading = .recipeCreation
	 Task{
		defer {loading = nil}
		
		do{
		  let response = try await apiManager.recipeRequest(userIngredients: userIngredients, userDifficulty: difficulty, userTime: selectedTime, user: user, userNote: userNote)
		  let image = try await pexelsManager.searchImage(query: response.search)
		  var recipe = UIRecipeModel(recipe: response)
		  IngredientsManager.shared.chekingNewIngredients(ingreedients: response.ingredients)
		  recipe.imageUrl = image ?? ""
		  await MainActor.run{
			 self.recipe = response
			 
			 NavigationManager.shared.secondaryScreens = .info(recipe: recipe, creation: true)
		  }
		}catch{
		  await MainActor.run {
			 NavigationManager.shared.error = CreationError.map(error)
		  }
		}
	 }
  }
  
  
  func analyzePhoto(image: UIImage){
	 loading = .photoAnalysis
	 Task{
		defer {loading = nil}
		
		do{
		  let products = try await apiManager.analyzePhoto(image: image, userIngredients: userIngredients)
		  let array = products.components(separatedBy: " ")
		  await MainActor.run {
			 let filtered = array.filter({item in !self.userIngredients.contains(where: {$0.lowercased() == item})})
			 self.userIngredients.insert(contentsOf: filtered, at: 0)
		  }
		}catch{
		  await MainActor.run {
			 NavigationManager.shared.error = CreationError.map(error)
		  }
		}
	 }
  }
  
  
  var ableToCreate: Bool{
	 !userIngredients.isEmpty && !userNote.isEmpty
  }
}
