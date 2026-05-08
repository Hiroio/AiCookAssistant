//
//  CoreDataExtension.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import Foundation
import CoreData


extension RecipeEntity{
  var chatHistoryUI: [ChatPart]{
	 get{
		if let data = self.chatHistory{
		  let result = try? JSONDecoder().decode([ChatPart].self, from: data)
		  return result ?? []
		}else{
		  return []
		}
	 }
	 set{
		if let data = try? JSONEncoder().encode(newValue){
		  self.chatHistory = data
		}
	 }
  }
  
  var instructionsUI: [String]{
	 get{
		if let instructions = self.instructions{
		  return instructions.components(separatedBy: "\n")
		}else{
		  return []
		}
	 }set{
		self.instructions = newValue.joined(separator: "\n")
	 }
  }
  
  var ingredientsUI: [String]{
	 get{
		if let ingredients = self.ingredients{
		  return ingredients.components(separatedBy: "\n")
		}else{
		  return []
		}
	 }
	 set{
		self.ingredients = newValue.joined(separator: "\n")
	 }
  }
}
