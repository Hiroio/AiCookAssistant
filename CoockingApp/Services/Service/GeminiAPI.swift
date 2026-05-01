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
	 
	 let body = try createPhotoBody(image: image)
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
  Склади рецепт на основі інгредієнтів: \(ingredients), затраченого часу: \(userTime) та складності: \(userDifficulty).
  Згенеруй рецепт у форматі JSON. Використовуй такі ключі: **name** (String),**time** (String), **difficulty** (Int), **description** (String), **ingredients** (Array of Strings)Для інгрідієнтів використовуй "Інгрідієнт - грамовка або к-ть або по смаку", **instructions** (Array of Strings) Для інсткурцій використовуй "Назва кроку - що потрібно зробити", **search** (String(keyword for image search)). Не додавай нічого, крім чистого JSON.
  """
  }
  
//  For image analys
  private func createPhotoBody(image: UIImage) throws -> [String: Any] {
	 guard let imageData = image.jpegData(compressionQuality: 0.8) else { throw URLError(.cannotCreateFile) }
	 
	 let base64Image = imageData.base64EncodedString()
	 let prompt = "Проаналізуй фото, і поверни список інгрідієнів що можеш побачити на фото в форматі String через 1 whitespace, Тільки продукти, або спеції, які використовуються для приготування їжі."
	 
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
	 let systemPrompt = "Ти — професійний шеф-кухар. Відповідай на уточнювальні питання по рецепту лаконічно та зрозуміло. Якщо користувач просить замінити інгредієнт, запропонуй найкращу альтернативу."
	 
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
