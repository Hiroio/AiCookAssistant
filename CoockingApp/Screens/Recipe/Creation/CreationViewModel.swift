//
//  CreationViewModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import Combine

@MainActor
class CreationViewModel: ObservableObject{
  @Published var recipe: RecipeModel? = nil
  @Published var userIngredients: [String] = []
  @Published var selectedTime: String = "< 20"
  @Published var difficulty: Int = 2
  
  private let apiManager = GeminiAPI()
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
		  
		  await MainActor.run{
			 self.recipe = response
			 
			 NavigationManager.shared.secondaryScreens = .info(recipe: response)
		  }
		}catch{
		  print(error.localizedDescription)
		}
	 }
  }
  
}
