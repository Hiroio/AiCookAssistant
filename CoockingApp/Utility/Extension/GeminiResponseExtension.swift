//
//  GeminiResponseExtension.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation

extension Data{
  func getContentFromResponse() throws -> RecipeModel{
	 let decoded = try JSONDecoder().decode(GeminiResponse.self, from: self)
	 
	 if let generatedText = decoded.candidates.first?.content.parts.first?.text.data(using: .utf8){
		let recipe = try JSONDecoder().decode(RecipeModel.self, from: generatedText)
		return recipe
	 }else{
		throw URLError(.cannotDecodeContentData)
	 }
	 
	 
  }
}
