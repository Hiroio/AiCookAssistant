//
//  GeminiResponse.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation


struct GeminiResponse: Codable {
	 let candidates: [Candidate]
}

struct Candidate: Codable {
	 let content: ContentGeminiResponse
}

struct ContentGeminiResponse: Codable {
	 let parts: [Part]
}

struct Part: Codable {
	 let text: String
}
