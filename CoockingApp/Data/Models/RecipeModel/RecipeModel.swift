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
  let macros: String
  let tip: String
  let ingredients: [String]
  let instructions: [String]
  let search: String
}


struct UIRecipeModel: Identifiable {
  var id: UUID
  var name: String
  var time: Int
  var difficulty: Int
  var timesCooked: Int
  var description: String
  var macros: String
  var cookingTip: String
  var ingredients: [String]
  var instructions: [String]
  var isFavorite: Bool
  var imageUrl: String
  var chatHistory: [ChatPart]
  var dateCreated: Date
  var isRecommended: Bool
  var recommendedDate: Date?
}

extension UIRecipeModel{
  init(recipe: RecipeModel, isRecommended: Bool = false, recomendedDate: Date? = nil){
	 self.id = UUID()
	 self.name = recipe.name
	 self.time = recipe.time
	 self.difficulty = recipe.difficulty
	 self.timesCooked = 0
	 self.description = recipe.description
	 self.macros = recipe.macros
	 self.cookingTip = recipe.tip
	 self.ingredients = recipe.ingredients
	 self.instructions = recipe.instructions
	 self.isFavorite = false
	 self.imageUrl = ""
	 self.chatHistory = []
	 self.dateCreated = Date()
	 self.isRecommended = isRecommended
	 self.recommendedDate = recomendedDate
  }
  
  init(entity: RecipeEntity){
	 self.id = entity.id ?? UUID()
	 self.name = entity.name ?? "Unknown"
	 self.time = Int(entity.time)
	 self.difficulty = Int(entity.difficulty)
	 self.timesCooked = Int(entity.timesCooked)
	 self.description = entity.desc ?? ""
	 self.macros = entity.macros ?? ""
	 self.cookingTip = entity.cookingTip ?? ""
	 self.ingredients = entity.ingredientsUI
	 self.instructions = entity.instructionsUI
	 self.isFavorite = entity.isFavorite
	 self.imageUrl = entity.imageUrl ?? ""
	 self.chatHistory = entity.chatHistoryUI
	 self.dateCreated = entity.dateCreated ?? Date()
	 self.isRecommended = entity.isRecommended
	 self.recommendedDate = entity.recommendedDate
  }
  
  func getContext() -> String {
		return """
		Контекст рецепта:
		Назва: \(self.name)
		Інгредієнти: \(self.ingredients.joined(separator: ", "))
		Інструкція: \(self.instructions.joined(separator: ". "))
		"""
  }
  
  static var preview = UIRecipeModel(id: UUID(), name: "Creamy Herb Chicken with Potato",time: 35, difficulty: 3, timesCooked: 0, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce",macros: "-420, 12, 25, 12", cookingTip: "QWe qwe eqweqwm wqmekqw kmwqelq qwkm", ingredients: ["asdasd", "dqwd", "qwdqwd", "qdwqd", "qwdqwd"], instructions: [], isFavorite: false, imageUrl: "https://images.pexels.com/photos/7837671/pexels-photo-7837671.jpeg?auto=compress&cs=tinysrgb&h=650&w=940", chatHistory: [], dateCreated: Date(), isRecommended: false)
  static var preview2 = UIRecipeModel(id: UUID(), name: "Sweet Soup Borsch",time: 35, difficulty: 2,timesCooked: 0, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", macros: "-420, 12, 25, 12", cookingTip: "QWe qwe eqweqwm wqmekqw kmwqelq qwkm", ingredients: ["asdasd", "dqwd", "qwdqwd", "qdwqd", "qwdqwd"], instructions: [], isFavorite: false, imageUrl: "https://images.pexels.com/photos/5436476/pexels-photo-5436476.jpeg?auto=compress&cs=tinysrgb&h=650&w=940", chatHistory: [], dateCreated: Date(), isRecommended: false)
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
