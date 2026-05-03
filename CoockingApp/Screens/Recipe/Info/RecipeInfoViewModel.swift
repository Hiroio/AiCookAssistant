//
//  RecipeInfoViewModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import Combine

@MainActor
class RecipeInfoViewModel: ObservableObject{
  @Published var recipe: UIRecipeModel
  @Published var screenState: InfoScreenEnum = .info
  @Published var chatMessage: String = ""
  @Published var messageIsLoading: Bool = false
  
  private let geminiAPI = GeminiAPI()
  let recipeManager = RecipesManager.shared
  init(recipe: UIRecipeModel) {
	 self.recipe = recipe
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
  
  func save(){
	 recipeManager.createRecipe(recipe: self.recipe)
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
