//
//  SecretsDecoder.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation


enum Secrets{
  static var geminiAPI: String{
	 guard let key = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String else {
		fatalError("Gemini API Key not found")
	 }
	 
	 return key
  }
  
  static var pexelsAPI: String{
	 guard let key = Bundle.main.infoDictionary?["PEXELS_API_KEY"] as? String else {
		fatalError("Gemini API Key not found")
	 }
	 
	 return key
  }
}
