//
//  RecipeModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation


struct RecipeModel: Codable{
  let name: String
  let time: Int
  let difficulty: Int
  let description: String
  let ingredients: [String]
  let instructions: [String]
  let search: String
}


struct UIRecipeModel {
  var name: String
  var time: Int
  var difficulty: Int
  var description: String
  var ingredients: [String]
  var instructions: [String]
  var imageUrl: String
  var chatHistory: [ChatPart]
}

extension UIRecipeModel{
  init(recipe: RecipeModel){
	 self.name = recipe.name
	 self.time = recipe.time
	 self.difficulty = recipe.difficulty
	 self.description = recipe.description
	 self.ingredients = recipe.ingredients
	 self.instructions = recipe.instructions
	 self.imageUrl = ""
	 self.chatHistory = []
	 
  }
  
  init(entity: RecipeEntity){
	 self.name = entity.name ?? "Unknown"
	 self.time = Int(entity.time)
	 self.difficulty = Int(entity.difficulty)
	 self.description = entity.desc ?? ""
	 self.ingredients = entity.ingredientsUI
	 self.instructions = entity.instructionsUI
	 self.imageUrl = entity.imageUrl ?? ""
	 self.chatHistory = entity.chatHistoryUI
  }
  
  func getContext() -> String {
		return """
		Контекст рецепта:
		Назва: \(self.name)
		Інгредієнти: \(self.ingredients.joined(separator: ", "))
		Інструкція: \(self.instructions.joined(separator: ". "))
		"""
  }
  
  static var preview = UIRecipeModel(name: "Creamy Herb Chicken with Potato",time: 35, difficulty: 2, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", ingredients: ["asdasd", "dqwd", "qwdqwd", "qdwqd", "qwdqwd"], instructions: [], imageUrl: "https://images.pexels.com/photos/34326260/pexels-photo-34326260.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200", chatHistory: [])
  static var preview2 = UIRecipeModel(name: "Sweet Soup Borsch",time: 35, difficulty: 2, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", ingredients: ["asdasd", "dqwd", "qwdqwd", "qdwqd", "qwdqwd"], instructions: [], imageUrl: "https://images.pexels.com/photos/34326260/pexels-photo-34326260.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200", chatHistory: [])
}


struct ChatPart: Codable {
	 let role: RecipeChatRoleEnum // "user" or "model"
	 let parts: [[String: String]] // [["text": "text: message"]]
}


extension ChatPart{
  init(message: String, _ user: Bool = true){
	 self.role = user ? .user : .model
	 self.parts = [["text": message]]
  }
  
  
  init(recipe: UIRecipeModel){
	 self.role = .user
	 self.parts = [["text": recipe.getContext()]]
  }
}
