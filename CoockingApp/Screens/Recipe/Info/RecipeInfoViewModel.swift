//
//  RecipeInfoViewModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import Combine
import UIKit

@MainActor
class RecipeInfoViewModel: ObservableObject{
  @Published var recipe: UIRecipeModel
  @Published var screenState: InfoScreenEnum = .info
  @Published var chatMessage: String = ""
  @Published var messageIsLoading: Bool = false
  
  @Published var cooking: Bool = false
  @Published var fromCreating: Bool = false
  @Published var shareImage: UIImage?
  @Published var shareIsLoading: Bool = false
  @Published var shareIsPresented: Bool = false
  @Published var saved: Bool = false
  
  private let geminiAPI = GeminiAPI()
  private let shareService = ShareService.shared
  let recipeManager = RecipesManager.shared
  init(recipe: UIRecipeModel, fromCreation: Bool = false) {
	 self.recipe = recipe
	 self.fromCreating = fromCreation
	 self.saved = recipeManager.recipes.contains(where: {$0.id == recipe.id}) && !recipe.isRecommended
  }
  
  
  func sendChatMessage(){
	 let message = ChatPart(message: chatMessage)
	 chatMessage.removeAll()
	 self.recipe.chatHistory.append(message)
	 let recipeInfo = ChatPart(recipe: recipe)
	 
	 let messages = [recipeInfo] + recipe.chatHistory.suffix(9)
	 
	 messageIsLoading = true
	 Task{
		defer {messageIsLoading = false}
		do{
		  let answer = try await geminiAPI.chatRequest(message: messages)
		  
		  let chatAnswer = ChatPart(message: answer, false)
		  
		  self.recipe.chatHistory.append(chatAnswer)
		  
		}
	 }
  }
 
//  BTN Save in Bottom bar
  func save(){
	 if recipe.isRecommended {
		saved = recipeManager.saveRecomended(self.recipe.id)
	 }else{
		saved = recipeManager.createRecipe(recipe: self.recipe)
	 }
  }
  
  func startCooking() {
	 screenState = .instructions
	 cooking = true
	 
	 if !saved{
		let _ = self.save()
	 }
	 
	 recipe.timesCooked += 1
	 let _ = recipeManager.incrementTimesCooked(recipe.id)
  }
  
//  SHARING RECIPE TOP BTN
  func prepareShareImage() async {
	 guard !shareIsLoading else { return }
	 
	 shareIsLoading = true
	 defer { shareIsLoading = false }
	 
	 shareImage = await shareService.makeRecipeShareImage(recipe: recipe)
	 shareIsPresented = shareImage != nil
  }
}


enum InfoScreenEnum: String, CaseIterable, Identifiable{
  case info, instructions, aiassistance
  
  var id: String{self.rawValue}
  
  var text: String{
	 switch self {
	 case .info:
		"Info"
	 case .instructions:
		"Instructions"
	 case .aiassistance:
		"AIAssistance"
	 }
  }
}
