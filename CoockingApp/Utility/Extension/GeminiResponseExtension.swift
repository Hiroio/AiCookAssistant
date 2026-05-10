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
		print(generatedText)
		return generatedText
	 }else{
		throw URLError(.cannotDecodeContentData)
	 }
	 
	 
  }
  
  func getRecipeFromResponse() throws -> RecipeModel{
	 let content = try self.getContentFromResponse()
	 let json = content.extractedJSONObject()
	 
	 if let data = json.data(using: .utf8){
		let recipe = try JSONDecoder().decode(RecipeModel.self, from: data)
		return recipe
	 }else{
		throw URLError(.cannotDecodeContentData)
	 }
  }
}

extension String {
  func extractedJSONObject() -> String {
	 let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
	 
	 guard
		let start = trimmed.firstIndex(of: "{"),
		let end = trimmed.lastIndex(of: "}"),
		start <= end
	 else {
		return trimmed
	 }
	 
	 return String(trimmed[start...end])
  }
}
