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
  var id: UUID
  var name: String
  var time: Int
  var difficulty: Int
  var timesCooked: Int
  var description: String
  var ingredients: [String]
  var instructions: [String]
  var isFavorite: Bool
  var imageUrl: String
  var chatHistory: [ChatPart]
  var dateCreated: Date
}

extension UIRecipeModel{
  init(recipe: RecipeModel){
	 self.id = UUID()
	 self.name = recipe.name
	 self.time = recipe.time
	 self.difficulty = recipe.difficulty
	 self.timesCooked = 0
	 self.description = recipe.description
	 self.ingredients = recipe.ingredients
	 self.instructions = recipe.instructions
	 self.isFavorite = false
	 self.imageUrl = ""
	 self.chatHistory = []
	 self.dateCreated = Date()
	 
  }
  
  init(entity: RecipeEntity){
	 self.id = entity.id ?? UUID()
	 self.name = entity.name ?? "Unknown"
	 self.time = Int(entity.time)
	 self.difficulty = Int(entity.difficulty)
	 self.timesCooked = Int(entity.timesCooked)
	 self.description = entity.desc ?? ""
	 self.ingredients = entity.ingredientsUI
	 self.instructions = entity.instructionsUI
	 self.isFavorite = entity.isFavorite
	 self.imageUrl = entity.imageUrl ?? ""
	 self.chatHistory = entity.chatHistoryUI
	 self.dateCreated = entity.dateCreated ?? Date()
  }
  
  func getContext() -> String {
		return """
		Контекст рецепта:
		Назва: \(self.name)
		Інгредієнти: \(self.ingredients.joined(separator: ", "))
		Інструкція: \(self.instructions.joined(separator: ". "))
		"""
  }
  
  static var preview = UIRecipeModel(id: UUID(), name: "Creamy Herb Chicken with Potato",time: 35, difficulty: 2, timesCooked: 0, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", ingredients: ["asdasd", "dqwd", "qwdqwd", "qdwqd", "qwdqwd"], instructions: [], isFavorite: false, imageUrl: "https://images.pexels.com/photos/34326260/pexels-photo-34326260.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200", chatHistory: [], dateCreated: Date())
  static var preview2 = UIRecipeModel(id: UUID(), name: "Sweet Soup Borsch",time: 35, difficulty: 2,timesCooked: 0, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", ingredients: ["asdasd", "dqwd", "qwdqwd", "qdwqd", "qwdqwd"], instructions: [], isFavorite: false, imageUrl: "https://images.pexels.com/photos/34326260/pexels-photo-34326260.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200", chatHistory: [], dateCreated: Date())
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
