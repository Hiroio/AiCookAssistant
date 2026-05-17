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
  private let model = "gemini-3-flash-preview"
  private let recipeMaxOutputTokens = 3072
  private let photoMaxOutputTokens = 256
  private let chatMaxOutputTokens = 1024
  
  func getUrl() throws -> URL{
	 guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent") else {
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
//	 Print for time check
//	 print("Started creating dish \(Date.now.formatted(.dateTime.hour().minute().second()))")
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
	 
//	 let json = try JSONSerialization.jsonObject(with: data)
//	 print decoded data for testing
//	 print(json)
	 
	 return try data.getRecipeFromResponse()
  }
  
  //  MARK: Analyzing photo for camera
  func analyzePhoto(image: UIImage, userIngredients: [String]) async throws -> String{
	 let url = try getUrl()
	 //	 Request
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let body = try createPhotoBody(image: image, currentIngredients: userIngredients)
	 request.httpBody = try JSONSerialization.data(withJSONObject: body)
	 
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 if let response = response as? HTTPURLResponse{
//		Print status Code
//		print(response.statusCode)
	 }
	 
//	 let json = try JSONSerialization.jsonObject(with: data)
//	 Print data for testing
//	 print(json)
	 
	 
	 return try data.getContentFromResponse()
  }
  
  //  MARK: Simple chat request
  func chatRequest(message: [ChatPart]) async throws -> String{
	 let url = try getUrl()
	 
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 request.addValue(apikey, forHTTPHeaderField: "x-goog-api-key")
	 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 request.httpBody = try JSONSerialization.data(withJSONObject: createBodyForChatRequest(messages: message))
	 
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 if let response = response as? HTTPURLResponse{
//		Print status code fro testing
//		print(response.statusCode)
	 }
	 
	 return try data.getContentFromResponse()
	 
	 
  }
}





extension GeminiAPI{
  private var responseLanguage: String {
	 let storedLanguage = UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguageEnum.system.rawValue
	 let selectedLanguage = AppLanguageEnum(rawValue: storedLanguage) ?? .system
	 
	 switch selectedLanguage {
	 case .system:
		let languageCode = Locale.autoupdatingCurrent.language.languageCode?.identifier ?? "en"
		return Locale(identifier: "en").localizedString(forLanguageCode: languageCode)?.capitalized ?? "English"
	 case .english:
		return "English"
	 case .ukrainian:
		return "Ukrainian"
	 case .polish:
		return "Polish"
	 case .german:
		return "German"
	 case .french:
		return "French"
	 case .spanish:
		return "Spanish"
	 case .italian:
		return "Italian"
	 case .portugueseBrazil:
		return "Brazilian Portuguese"
	 }
  }
  
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
			 "thinkingLevel": "minimal"
		  ]
		]
	 ]
  }
  
  //  For Recipe creation
  private func generatePromptForRecipe(userIngredients: [String], userDifficulty: Int, userTime: String, user: UserModel, userNote: String) -> String{
	 let ingredients = userIngredients.joined(separator: " ")
	 
	 return """
	 Create one recipe.
	 
	 Inputs:
	 ingredients: \(ingredients)
	 time creation preference: \(userTime)
	 difficulty preference: \(userDifficulty)
	 allergies: \(user.alergieIngredients)
	 avoid ingredients: \(user.avoidIngredients)
	 user note: \(userNote)
	 response language: \(responseLanguage)
	 
	 Return valid JSON only. No markdown, comments, nulls, extra text, or trailing commas.
	 
	 Schema:
	 {
	   "name": "short recipe title in response language",
	   "time": Int,
	   "difficulty": Int,
	   "description": "description in response language, max 2 sentences",
	   "macros": "kcal, proteins, fats, carbs",
	   "tip": "short cooking tip in response language",
	   "ingredients": {
	     "Ingredient Name in response language - amount": "category"
	   },
	   "instructions": ["step - instruction sentence in response language"],
	   "search": "short English food image keywords"
	 }
	 
	 Rules:
	 - Use response language for name, description, tip, ingredient names, and instruction text.
	 - Do not force a national cuisine based on response language. Choose any cuisine or home-cooking style that fits the inputs.
	 - time must be an integer cooking time in minutes.
	 - If time preference is "< 20", choose 10-20.
	 - If time preference is "20 - 50", choose 20-50.
	 - If time preference is "> 50", choose 50-120.
	 - difficulty must be an integer from 1 to 5 and close to the user's difficulty preference.
	 - macros example: "420, 24, 18, 38".
	 - ingredients is a JSON object. Each key must be "Ingredient Name - amount".
	 - ingredient category must be one of: vegetables, fruits, protein, dairy, grains, spices, sauces, other.
	 - protein = meat, fish, seafood, eggs, tofu, legumes. sauces = oil, vinegar, dressings, condiments. other = only when nothing fits.
	 - instructions items must start with one step from: wash, cut, peel, mix, bake, boil, fry, add, season, serve, and seperate step and instruction with "-".
	 """
  }
  
  //  For image analys
  private func createPhotoBody(image: UIImage, currentIngredients: [String]) throws -> [String: Any] {
	 guard let imageData = image.jpegData(compressionQuality: 0.8) else { throw URLError(.cannotCreateFile) }
	 let ingredients = currentIngredients.joined(separator: " ")
	 
	 let base64Image = imageData.base64EncodedString()
	 let prompt = """
  Analyze the photo and return only a plain String of food ingredients you can see.
  Response language: \(responseLanguage).
  Current ingredients, if any: \(ingredients)
  
  Rules:
  - Return ingredient names in response language.
  - Include only food products, spices, herbs, sauces, or cooking ingredients.
  - Separate ingredients with one whitespace only.
  - If current ingredients are provided, keep them and add new detected ingredients.
  - If nothing useful is detected, return an empty String or the current ingredients if they were provided.
  - Do not write explanations, markdown, punctuation lists, JSON, bullets, or extra text.
  """
	 
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
		],
		"generationConfig": [
		  "temperature": 0.1,
		  "maxOutputTokens": photoMaxOutputTokens,
		  "thinkingConfig": [
			 "thinkingLevel": "low"
		  ]
		]
	 ]
	 return body
  }
  
  private func createBodyForChatRequest(messages: [ChatPart]) -> [String: Any]{
	 let systemPrompt = """
  You are a professional chef assistant.
  Answer recipe questions clearly and briefly.
  If the user asks to replace an ingredient, suggest the best practical alternative.
  Reply in the same language as the user's latest message.
  Return plain text only. Do not use markdown headings, bullets, #, **, or code formatting.
  """
	 
	 let body: [String: Any] = [
		"systemInstruction": [
		  "parts": [["text": systemPrompt]]
		],
		"contents": messages.map { [
		  "role": $0.role.rawValue,
		  "parts": $0.parts
		]},
		"generationConfig": [
		  "temperature": 0.7,
		  "maxOutputTokens": chatMaxOutputTokens,
		  "thinkingConfig": [
			 "thinkingLevel": "low"
		  ]
		]
	 ]
	 return body
  }
  
  //  For recomended Recepi
  private func generatePromptForRecommendedRecipe(user: UserModel, userRecipeList: [String]) -> String {
	 let recipes = userRecipeList.joined(separator: "\n")
	 
	 return """
	 Create one recommended recipe: trendy, cozy, tasty, realistic for home cooking, and fresh for today.
	 
	 User context:
	 allergies: \(user.alergieIngredients)
	 avoid ingredients: \(user.avoidIngredients)
	 response language: \(responseLanguage)
	 saved recipes:
	 \(recipes.isEmpty ? "No saved recipes yet." : recipes)
	 
	 Use saved recipes only as taste context. Do not create the exact same recipe.
	 
	 Return valid JSON only. No markdown, comments, nulls, extra text, or trailing commas.
	 
	 Schema:
	 {
	   "name": "short recipe title in response language",
	   "time": Int,
	   "difficulty": Int,
	   "description": "description in response language, max 2 sentences",
	   "macros": "kcal, proteins, fats, carbs",
	   "tip": "short cooking tip in response language",
	   "ingredients": {
	     "Ingredient Name in response language - amount": "category"
	   },
	   "instructions": ["step - instruction sentence in response language"],
	   "search": "short English food image keywords"
	 }
	 
	 Rules:
	 - Use response language for name, description, tip, ingredient names, and instruction text.
	 - Do not force a national cuisine based on response language. Choose any trendy home-cooking idea.
	 - time must be an integer cooking time in minutes, usually 15-75 depending on the dish.
	 - difficulty must be an integer from 1 to 5.
	 - macros example: "420, 24, 18, 38".
	 - ingredients is a JSON object. Each key must be "Ingredient Name - amount".
	 - ingredient category must be one of: vegetables, fruits, protein, dairy, grains, spices, sauces, other.
	 - protein = meat, fish, seafood, eggs, tofu, legumes. sauces = oil, vinegar, dressings, condiments. other = only when nothing fits.
	 - instructions items must start with one step from: wash, cut, peel, mix, bake, boil, fry, add, season, serve, and seperate step and instruction with "-".
	 """
  }
  
  
  //  MARK: For Quick Idea Recipe
  private func generatePromptForquickIdea(user: UserModel, prompt: String, userRecipeList: [String]) -> String{
	 let recipes = userRecipeList.joined(separator: "\n")
	 
	 return """
	 Create one recipe for this quick idea: \(prompt)
	 
	 User context:
	 allergies: \(user.alergieIngredients)
	 avoid ingredients: \(user.avoidIngredients)
	 response language: \(responseLanguage)
	 saved recipes:
	 \(recipes.isEmpty ? "No saved recipes yet." : recipes)
	 
	 Use saved recipes only as taste context. Do not create the exact same recipe.
	 
	 Return valid JSON only. No markdown, comments, nulls, extra text, or trailing commas.
	 
	 Schema:
	 {
	   "name": "short recipe title in response language",
	   "time": Int,
	   "difficulty": Int,
	   "description": "description in response language, max 2 sentences",
	   "macros": "kcal, proteins, fats, carbs",
	   "tip": "short cooking tip in response language",
	   "ingredients": {
	     "Ingredient Name in response language - amount": "category"
	   },
	   "instructions": ["step - instruction sentence in response language"],
	   "search": "short English food image keywords"
	 }
	 
	 Rules:
	 - Use response language for name, description, tip, ingredient names, and instruction text.
	 - Do not force a national cuisine based on response language. Follow the quick idea instead.
	 - time must be an integer cooking time in minutes, usually 10-75 depending on the quick idea.
	 - difficulty must be an integer from 1 to 5.
	 - macros example: "420, 24, 18, 38".
	 - ingredients is a JSON object. Each key must be "Ingredient Name - amount".
	 - ingredient category must be one of: vegetables, fruits, protein, dairy, grains, spices, sauces, other.
	 - protein = meat, fish, seafood, eggs, tofu, legumes. sauces = oil, vinegar, dressings, condiments. other = only when nothing fits.
	 - instructions items must start with one step from: wash, cut, peel, mix, bake, boil, fry, add, season, serve.
	 """
  }
}
