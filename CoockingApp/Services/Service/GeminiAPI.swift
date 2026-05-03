//
//  GeminiAPI.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import SwiftUI

class GeminiAPI{
  let apikey = Secrets.geminiAPI
  
  
//  MARK: Creating recipe
  func recipeRequest(userIngredients: [String], userDifficulty: Int, userTime: String) async throws -> RecipeModel {
	 print("Started creating dish \(Date.now.formatted(.dateTime.hour().minute().second()))")
	 guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent") else {
		throw URLError(.badURL)
	 }
	 //	 Request
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let prompt = generatePromptForRecipe(userIngredients: userIngredients, userDifficulty: userDifficulty, userTime: userTime)
	 
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
	 
	 return try data.getRecipeFromResponse()
  }
  
//  MARK: Analyzing photo for camera
  func analyzePhoto(image: UIImage, userIngredients: [String]) async throws -> String{
	 guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent") else {
		throw URLError(.badURL)
	 }
	 //	 Request
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let body = try createPhotoBody(image: image, currentIngredients: userIngredients)
	 request.httpBody = try JSONSerialization.data(withJSONObject: body)
	 
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 if let response = response as? HTTPURLResponse{
		print(response.statusCode)
	 }
	 
	 let json = try JSONSerialization.jsonObject(with: data)
	 print(json)
	 
	 
	 return try data.getContentFromResponse()
  }
  
//  MARK: Simple chat request
  func chatRequest(message: [ChatPart]) async throws -> String{
	 guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent") else {
		throw URLError(.badURL)
	 }
	 
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 request.httpBody = try JSONSerialization.data(withJSONObject: createBodyForChatRequest(messages: message))
	 
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 if let response = response as? HTTPURLResponse{
		print(response.statusCode)
	 }
	 
	 return try data.getContentFromResponse()
	 
	 
  }
}





extension GeminiAPI{
  //  For Recipe creation
  private func generatePromptForRecipe(userIngredients: [String], userDifficulty: Int, userTime: String) -> String{
	 let ingredients = userIngredients.joined(separator: " ")
	 
	 return """
  Create one cooking recipe based on:
  
  Ingredients: \(ingredients)
  Cooking Time Preference: \(userTime)
  Difficulty Preference: \(userDifficulty)
  User Language: Ukranian
  
  Return ONLY one valid JSON object.
  Do not use markdown.
  Do not use code blocks.
  Do not write explanations.
  Do not write any text before or after JSON.
  
  JSON structure must be exactly:
  
  {
  "name": "String",
  "time": Int,
  "difficulty": Int,
  "description": "String",
  "ingredients": ["String", "String", "String"],
  "instructions": ["String", "String", "String"],
  "search": "String"
  }
  
  Strict rules:
  
  1. "name" = short attractive User Language recipe title.
  2. "time" = cooking time. Example: 120
  3. "difficulty" = integer only from 1 to 5.
  4. "description" = short tasty User Language description, max 2 sentences.
  5. "ingredients" = Array of strings. Each ingredient must be using this exact pattern:
  "Ingredient Name - amount"
  Example:
  "Курка - 300 г"
  "Картопля - 4 шт"
  "Сіль - за смаком"
  6. "instructions" = JSON array only. Each item must be one User Language cooking step sentence.
  7. "search" = short English keywords for searching a food image.
  
  Important:
  - JSON must be syntactically valid.
  - Do not leave trailing commas.
  - Do not change key names.
  - Do not return null.
  """
  }
  
//  For image analys
  private func createPhotoBody(image: UIImage, currentIngredients: [String]) throws -> [String: Any] {
	 guard let imageData = image.jpegData(compressionQuality: 0.8) else { throw URLError(.cannotCreateFile) }
	 let ingredients = currentIngredients.joined(separator: " ")
	 
	 let base64Image = imageData.base64EncodedString()
	 let prompt = "Проаналізуй фото, та  поверни список інгрідієнів, що можеш побачити на фото в форматі String через 1 whitespace із вже можливо доданими інгрідієнтами - (\(ingredients)), Тільки продукти, або спеції, які використовуються для приготування їжі, Якщо ж ти нічого не знайдеш поверни пустий String, або теперішній список який надався якщо він був"
	 
	 let body: [String: Any] = [
		"contents": [
		  [
			 "parts": [
				["text": prompt],
				[
				  "inlineData": [
					 "mimeType": "image/jpeg",
					 "data": base64Image
				  ]
				]
			 ]
		  ]
		]
	 ]
	 return body
  }
  
  private func createBodyForChatRequest(messages: [ChatPart]) -> [String: Any]{
	 let systemPrompt = "Ти — професійний шеф-кухар. Відповідай на уточнювальні питання по рецепту лаконічно та зрозуміло. Якщо користувач просить замінити інгредієнт, запропонуй найкращу альтернативу. Видай відповідь в String форматі без виділень # або ** просто текст"
	 
	 let body: [String: Any] = [
		"systemInstruction": [
						"parts": [["text": systemPrompt]]
				  ],
				"contents": messages.map { [
				  "role": $0.role.rawValue,
					 "parts": $0.parts
				]},
				"generationConfig": [
					 "temperature": 0.7
				]
		  ]
	 return body
  }
}
