//
//  GeminiAPI.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation


class GeminiAPI{
  let apikey = Secrets.geminiAPI
  
  func recipeRequest(userIngredients: [String], userDifficulty: Int, userTime: String) async throws -> RecipeModel {
	 guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent") else {
		throw URLError(.badURL)
	 }
	 //	 Request
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let prompt = generatePrompt(userIngredients: userIngredients, userDifficulty: userDifficulty, userTime: userTime)
	 
	 let payload: [String: Any] = [
		"contents": [[
		  "parts": [["text" : prompt]]
		]],
		"generationConfig": [
		  "temperature": 0.5,
		  "response_mime_type": "application/json"
		]
	 ]
	 
	 request.httpBody = try JSONSerialization.data(withJSONObject: payload)
	 
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 if let response = response as? HTTPURLResponse{
		print(response.statusCode)
	 }
	 
	 let json = try JSONSerialization.jsonObject(with: data)
	 print(json)
	 
	 return try data.getContentFromResponse()
  }
  
  
  
  func generatePrompt(userIngredients: [String], userDifficulty: Int, userTime: String) -> String{
	 let ingredients = userIngredients.joined(separator: " ")
	 
	 return """
  Склади рецепт на основі інгредієнтів: \(ingredients), затраченого часу: \(userTime) та складності: \(userDifficulty).
  Згенеруй рецепт у форматі JSON. Використовуй такі ключі: **name** (String), **difficulty** (Int), **description** (String), **ingredients** (Array of Strings), **instructions** (Array of Strings). Не додавай нічого, крім чистого JSON.
  """
  }
}
