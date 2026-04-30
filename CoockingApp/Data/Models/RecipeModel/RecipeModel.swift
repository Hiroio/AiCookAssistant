//
//  RecipeModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation


struct RecipeModel: Codable{
  let name: String
  let time: String
  let difficulty: Int
  let description: String
  let ingredients: [String]
  let instructions: [String]
  let search: String
}


struct UIRecipeModel {
  var name: String
  var time: String
  var difficulty: Int
  var description: String
  var ingredients: [String]
  var instructions: [String]
  var imageUrl: String
  
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
  }
}
