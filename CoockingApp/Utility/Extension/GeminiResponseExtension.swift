//
//  GeminiResponseExtension.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation

extension Data{
  func getContentFromResponse() throws -> String{
	 let decoded = try JSONDecoder().decode(GeminiResponse.self, from: self)
	 if let generatedText = decoded.candidates.first?.content.parts.first?.text{
		return generatedText
	 }else{
		throw URLError(.cannotDecodeContentData)
	 }
	 
	 
  }
  
  func getRecipeFromResponse() throws -> RecipeModel{
	 if let data = try self.getContentFromResponse().data(using: .utf8){
		let recipe = try JSONDecoder().decode(RecipeModel.self, from: data)
		return recipe
	 }else{
		throw URLError(.cannotDecodeContentData)
	 }
  }
}
