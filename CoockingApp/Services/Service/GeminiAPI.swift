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
  private let recipeMaxOutputTokens = 3072
  private let recipeThinkingBudget = 512
  
  func getUrl() throws -> URL{
	 guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent") else {
		throw URLError(.badURL)
	 }
	 return url
  }
  
//  MARK: Creating recommended recipe
  func recomendedRequest(user: UserModel, recipeList: [String]) async throws -> RecipeModel{
	 let url = try getUrl()
	 //	 Request
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let prompt = generatePromptForRecommendedRecipe(user: user, userRecipeList: recipeList)
	 
	 let payload = recipePayload(prompt: prompt)
	 request.httpBody = try JSONSerialization.data(withJSONObject: payload)
	 
	 return try await apiRequest(request: request)
  }
  
//  MARK: Creating basic recipe
  func recipeRequest(userIngredients: [String], userDifficulty: Int, userTime: String, user: UserModel, userNote: String) async throws -> RecipeModel {
	 print("Started creating dish \(Date.now.formatted(.dateTime.hour().minute().second()))")
	 let url = try getUrl()
	 //	 Request
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let prompt = generatePromptForRecipe(userIngredients: userIngredients, userDifficulty: userDifficulty, userTime: userTime, user: user, userNote: userNote)
	 
	 let payload = recipePayload(prompt: prompt)
	 request.httpBody = try JSONSerialization.data(withJSONObject: payload)
	 return try await apiRequest(request: request)
  }
  
//  MARK: Creating Quick Idea recipe
  func quickIdeaRequest(user: UserModel, prompt: String, recipeList: [String]) async throws -> RecipeModel {
	 let url = try getUrl()
	 
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let prompt = generatePromptForquickIdea(user: user, prompt: prompt, userRecipeList: recipeList)
	 let payload = recipePayload(prompt: prompt)
	 request.httpBody = try JSONSerialization.data(withJSONObject: payload)
	 
	 return try await apiRequest(request: request)
  }
  
  
  
//  MARK: URLSession-Request
  func apiRequest(request: URLRequest) async throws -> RecipeModel{
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
		throw URLError(.badServerResponse)
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
  private func recipePayload(prompt: String) -> [String: Any] {
	 [
		"contents": [[
		  "parts": [["text": prompt]]
		]],
		"generationConfig": [
		  "temperature": 0.45,
		  "maxOutputTokens": recipeMaxOutputTokens,
		  "response_mime_type": "application/json",
		  "thinkingConfig": [
			 "thinkingBudget": recipeThinkingBudget
		  ]
		]
	 ]
  }
  
  //  For Recipe creation
  private func generatePromptForRecipe(userIngredients: [String], userDifficulty: Int, userTime: String, user: UserModel, userNote: String) -> String{
	 let ingredients = userIngredients.joined(separator: " ")
	 
	 return """
	 Create one Ukrainian recipe.
	 
	 Inputs:
	 ingredients: \(ingredients)
	 time preference: \(userTime)
	 difficulty preference: \(userDifficulty)
	 allergies: \(user.alergieIngredients)
	 avoid ingredients: \(user.avoidIngredients)
	 user note: \(userNote)
	 
	 Return valid JSON only. No markdown, comments, nulls, extra text, or trailing commas.
	 
	 Schema:
	 {
	   "name": "short Ukrainian title",
	   "time": 35,
	   "difficulty": 3,
	   "description": "Ukrainian description, max 2 sentences",
	   "macros": "kcal, proteins, fats, carbs",
	   "tip": "short Ukrainian cooking tip",
	   "ingredients": {
	     "Ingredient Name - amount": "category"
	   },
	   "instructions": ["step - Ukrainian instruction sentence"],
	   "search": "short English food image keywords"
	 }
	 
	 Rules:
	 - difficulty is an integer from 1 to 5.
	 - macros example: "420, 24, 18, 38".
	 - ingredients is a JSON object. Each key must be "Ingredient Name - amount".
	 - ingredient category must be one of: vegetables, fruits, protein, dairy, grains, spices, sauces, other.
	 - protein = meat, fish, seafood, eggs, tofu, legumes. sauces = oil, vinegar, dressings, condiments. other = only when nothing fits.
	 - instructions items must start with one step from: wash, cut, peel, mix, bake, boil, fry, add, season, serve.
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
  
//  For recomended Recepi
  private func generatePromptForRecommendedRecipe(user: UserModel, userRecipeList: [String]) -> String {
	 let recipes = userRecipeList.joined(separator: "\n")
	 
	 return """
	 Create one Ukrainian recommended recipe: trendy, cozy, tasty, realistic for home cooking, and fresh for today.
	 
	 User context:
	 allergies: \(user.alergieIngredients)
	 avoid ingredients: \(user.avoidIngredients)
	 saved recipes:
	 \(recipes.isEmpty ? "No saved recipes yet." : recipes)
	 
	 Use saved recipes only as taste context. Do not create the exact same recipe.
	 
	 Return valid JSON only. No markdown, comments, nulls, extra text, or trailing commas.
	 
	 Schema:
	 {
	   "name": "short Ukrainian title",
	   "time": 35,
	   "difficulty": 3,
	   "description": "Ukrainian description, max 2 sentences",
	   "macros": "kcal, proteins, fats, carbs",
	   "tip": "short Ukrainian cooking tip",
	   "ingredients": {
	     "Ingredient Name - amount": "category"
	   },
	   "instructions": ["step - Ukrainian instruction sentence"],
	   "search": "short English food image keywords"
	 }
	 
	 Rules:
	 - difficulty is an integer from 1 to 5.
	 - macros example: "420, 24, 18, 38".
	 - ingredients is a JSON object. Each key must be "Ingredient Name - amount".
	 - ingredient category must be one of: vegetables, fruits, protein, dairy, grains, spices, sauces, other.
	 - protein = meat, fish, seafood, eggs, tofu, legumes. sauces = oil, vinegar, dressings, condiments. other = only when nothing fits.
	 - instructions items must start with one step from: wash, cut, peel, mix, bake, boil, fry, add, season, serve.
	 """
  }

  
//  MARK: For Quick Idea Recipe
  private func generatePromptForquickIdea(user: UserModel, prompt: String, userRecipeList: [String]) -> String{
	 let recipes = userRecipeList.joined(separator: "\n")
	 
	 return """
	 Create one Ukrainian recipe for this quick idea: \(prompt)
	 
	 User context:
	 allergies: \(user.alergieIngredients)
	 avoid ingredients: \(user.avoidIngredients)
	 saved recipes:
	 \(recipes.isEmpty ? "No saved recipes yet." : recipes)
	 
	 Use saved recipes only as taste context. Do not create the exact same recipe.
	 
	 Return valid JSON only. No markdown, comments, nulls, extra text, or trailing commas.
	 
	 Schema:
	 {
	   "name": "short Ukrainian title",
	   "time": 35,
	   "difficulty": 3,
	   "description": "Ukrainian description, max 2 sentences",
	   "macros": "kcal, proteins, fats, carbs",
	   "tip": "short Ukrainian cooking tip",
	   "ingredients": {
	     "Ingredient Name - amount": "category"
	   },
	   "instructions": ["step - Ukrainian instruction sentence"],
	   "search": "short English food image keywords"
	 }
	 
	 Rules:
	 - difficulty is an integer from 1 to 5.
	 - macros example: "420, 24, 18, 38".
	 - ingredients is a JSON object. Each key must be "Ingredient Name - amount".
	 - ingredient category must be one of: vegetables, fruits, protein, dairy, grains, spices, sauces, other.
	 - protein = meat, fish, seafood, eggs, tofu, legumes. sauces = oil, vinegar, dressings, condiments. other = only when nothing fits.
	 - instructions items must start with one step from: wash, cut, peel, mix, bake, boil, fry, add, season, serve.
	 """
  }
}
