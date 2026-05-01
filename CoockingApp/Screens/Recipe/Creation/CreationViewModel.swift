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
  
  private let apiManager = GeminiAPI()
  private let pexelsManager = PexelsAPI()
  init(){}
  
  var loading: Bool {
	 get{
		NavigationManager.shared.isLoading
	 }
	 set{
		NavigationManager.shared.isLoading = newValue
	 }
  }
  
  func request(){
	 loading = true
	 Task{
		defer {loading = false}
		
		do{
		  let response = try await apiManager.recipeRequest(userIngredients: userIngredients, userDifficulty: difficulty, userTime: selectedTime)
		  print("SEARCH kEYWORD \(response.search)")
		  let image = try await pexelsManager.searchImage(query: response.search)
		  var recipe = UIRecipeModel(recipe: response)
		  recipe.imageUrl = image ?? ""
		  await MainActor.run{
			 self.recipe = response
			 
			 NavigationManager.shared.secondaryScreens = .info(recipe: recipe)
		  }
		}catch{
		  print(error.localizedDescription)
		}
	 }
  }
  
  func analyzePhoto(image: UIImage){
	 loading = true
	 Task{
		defer {loading = false}
		
		do{
		  let products = try await apiManager.analyzePhoto(image: image, userIngredients: userIngredients)
		  let array = products.components(separatedBy: " ")
		  await MainActor.run {
			 self.userIngredients = array
		  }
		}
	 }
  }
  
}
