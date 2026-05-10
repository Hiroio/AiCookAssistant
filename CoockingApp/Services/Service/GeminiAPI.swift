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
	 
	 let payload: [String: Any] = [
		"contents": [[
		  "parts": [["text" : prompt]]
		]],
		"generationConfig": [
		  "temperature": 0.5,
		  "maxOutputTokens": 1800,
		  "response_mime_type": "application/json"
		]
	 ]
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
	 
	 let payload: [String: Any] = [
		"contents": [[
		  "parts": [["text" : prompt]]
		]],
		"generationConfig": [
		  "temperature": 0.5,
		  "maxOutputTokens": 1800,
		  "response_mime_type": "application/json"
		]
	 ]
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
	 let payload: [String: Any] = [
		"contents": [[
		  "parts": [["text" : prompt]]
		]],
		"generationConfig": [
		  "temperature": 0.5,
		  "maxOutputTokens": 1800,
		  "response_mime_type": "application/json"
		]
	 ]
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
  //  For Recipe creation
  private func generatePromptForRecipe(userIngredients: [String], userDifficulty: Int, userTime: String, user: UserModel, userNote: String) -> String{
	 let ingredients = userIngredients.joined(separator: " ")
	 
	 return """
  Create one cooking recipe based on:
  
  Ingredients: \(ingredients)
  Cooking Time Preference: \(userTime)
  Difficulty Preference: \(userDifficulty)
  User Alergies (optional): \(user.alergieIngredients)
  User Avoid ingredients (optional): \(user.avoidIngredients)
  User Preferences regarding the dish (optional): \(userNote)
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
  "macros": "String",
  "tip": "String",
  "ingredients": {
    "Ingredient Name - amount": "category"
  },
  "instructions": ["String", "String", "String"],
  "search": "String"
  }
  
  Strict rules:
  
  1. "name" = short attractive User Language recipe title.
  2. "time" = cooking time. Example: 120
  3. "difficulty" = integer only from 1 to 5.
  4. "description" = short tasty User Language description, max 2 sentences.
  5. "macros" = kcal, Proteins, Fats, Carbs (numbers separated with comma). example: "300, 12, 5, 26" 
  6. "tip" = a short tip about the dish how to cook or good knowledge about cooking dish.
  7. "ingredients" = JSON object only.
  Each key must be a recipe ingredient using this exact pattern:
  "Ingredient Name - amount"
  Each value must be one category from this exact list:
  [vegetables, fruits, protein, dairy, grains, spices, sauces, other]
  Category meaning:
  - protein = meat, fish, seafood, eggs, tofu, legumes used as the main protein.
  - sauces = sauces, paste, dressing, oil, vinegar, condiments.
  - other = water, stock, yeast, gelatin, starch, breadcrumbs, or anything that does not fit clearly.
  Example:
  {
    "Chicken - 300 g.": "protein",
    "Potato - 4 pcs.": "vegetables",
    "Salt - to taste": "spices"
  }
  8. "instructions" = JSON array only. Each item must be one User Language `sentence` of step and `cookingStep` from this list [wash, cut, peel, mix, bake, boil, fry, add, season, serve], I'm using it only for icons. You don't have to be too strict—just pick the best option from the list. 
  example:
  ["cookingStep - Sentance", ...].
  9. "search" = short English keywords for searching a food image.
  
  
  Important:
  - JSON must be syntactically valid.
  - Do not leave trailing commas.
  - Do not change key names.
  - Do not return null.
  - Do not add categories outside the allowed category list.
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
	 Create one recommended cooking recipe for the user.
	 
	 Recommendation direction:
	 Suggest something trendy, cozy, tasty, and realistic for home cooking.
	 The dish should feel like a fresh idea for today.
	 Not super delusional
	 
	 User Alergies (optional): \(user.alergieIngredients)
	 User Avoid ingredients (optional): \(user.avoidIngredients)
	 
	 User Recipe List (optional):
	 \(recipes.isEmpty ? "No saved recipes yet." : recipes)
	 
	 Use the User Recipe List only as taste context:
	 - Avoid creating the exact same recipe.
	 - You may recommend something similar in mood, cuisine, ingredients, or cooking style.
	 - Keep the recommendation fresh and slightly different from what the user already has.
	 
	 User Language: Ukrainian
	 
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
	 "macros": "String",
	 "tip": "String",
	 "ingredients": {
	   "Ingredient Name - amount": "category"
	 },
	 "instructions": ["String", "String", "String"],
	 "search": "String"
	 }
	 
	 Strict rules:
	 
	 1. "name" = short attractive User Language recipe title.
	 2. "time" = realistic cooking time in minutes. Example: 35
	 3. "difficulty" = integer only from 1 to 5.
	 4. "description" = short tasty User Language description, max 2 sentences.
	 5. "macros" = kcal, Proteins, Fats, Carbs numbers separated with comma. Example: "420, 24, 18, 38"
	 6. "tip" = one short useful cooking tip about the dish.
	 7. "ingredients" = JSON object only.
	 Each key must be a recipe ingredient using this exact pattern:
	 "Ingredient Name - amount"
	 Each value must be one category from this exact list:
	 [vegetables, fruits, protein, dairy, grains, spices, sauces, other]
	 Category meaning:
	 - protein = meat, fish, seafood, eggs, tofu, legumes used as the main protein.
	 - sauces = sauces, paste, dressing, oil, vinegar, condiments.
	 - other = water, stock, yeast, gelatin, starch, breadcrumbs, or anything that does not fit clearly.
	 Example:
	 {
	   "Chicken - 300 g.": "protein",
	   "Potato - 4 pcs.": "vegetables",
	   "Salt - to taste": "spices"
	 }
	 8. "instructions" = JSON array only. Each item must be one User Language sentence of step and cookingStep from this list [wash, cut, peel, mix, bake, boil, fry, add, season, serve].
	 Example:
	 ["cut - Cut the vegetables into small pieces.", "fry - Brown the chicken until golden brown."]
	 9. "search" = short English keywords for searching a food image.
	 
	 Important:
	 - JSON must be syntactically valid.
	 - Do not leave trailing commas.
	 - Do not change key names.
	 - Do not return null.
	 - Do not add categories outside the allowed category list.
	 """
  }

  
//  MARK: For Quick Idea Recipe
  private func generatePromptForquickIdea(user: UserModel, prompt: String, userRecipeList: [String]) -> String{
	 let recipes = userRecipeList.joined(separator: "\n")
	 
	 return """
	 Create one recommended cooking recipe for the user.
	 
	 Recommendation direction:
	 \(prompt)
	 
	 User Alergies (optional): \(user.alergieIngredients)
	 User Avoid ingredients (optional): \(user.avoidIngredients)
	 
	 User Recipe List (optional):
	 \(recipes.isEmpty ? "No saved recipes yet." : recipes)
	 
	 Use the User Recipe List only as taste context:
	 - Avoid creating the exact same recipe.
	 - You may recommend something similar in mood, cuisine, ingredients, or cooking style.
	 - Keep the recommendation fresh and slightly different from what the user already has.
	 
	 User Language: Ukrainian
	 
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
	 "macros": "String",
	 "tip": "String",
	 "ingredients": {
	   "Ingredient Name - amount": "category"
	 },
	 "instructions": ["String", "String", "String"],
	 "search": "String"
	 }
	 
	 Strict rules:
	 
	 1. "name" = short attractive User Language recipe title.
	 2. "time" = realistic cooking time in minutes. Example: 35
	 3. "difficulty" = integer only from 1 to 5.
	 4. "description" = short tasty User Language description, max 2 sentences.
	 5. "macros" = kcal, Proteins, Fats, Carbs numbers separated with comma. Example: "420, 24, 18, 38"
	 6. "tip" = one short useful cooking tip about the dish.
	 7. "ingredients" = JSON object only.
	 Each key must be a recipe ingredient using this exact pattern:
	 "Ingredient Name - amount"
	 Each value must be one category from this exact list:
	 [vegetables, fruits, protein, dairy, grains, spices, sauces, other]
	 Category meaning:
	 - protein = meat, fish, seafood, eggs, tofu, legumes used as the main protein.
	 - sauces = sauces, paste, dressing, oil, vinegar, condiments.
	 - other = water, stock, yeast, gelatin, starch, breadcrumbs, or anything that does not fit clearly.
	 Example:
	 {
	   "Chicken - 300 g.": "protein",
	   "Potato - 4 pcs.": "vegetables",
	   "Salt - to taste": "spices"
	 }
	 8. "instructions" = JSON array only. Each item must be one User Language sentence of step and cookingStep from this list [wash, cut, peel, mix, bake, boil, fry, add, season, serve].
	 Example:
	 ["cut - Cut the vegetables into small pieces.", "fry - Brown the chicken until golden brown."]
	 9. "search" = short English keywords for searching a food image.
	 
	 Important:
	 - JSON must be syntactically valid.
	 - Do not leave trailing commas.
	 - Do not change key names.
	 - Do not return null.
	 - Do not add categories outside the allowed category list.
	 """
  }
}
