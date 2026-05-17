//
//  PexelsAPI.swift
//  CoockingApp
//
//  Created by user on 30.04.2026.
//

import Foundation


class PexelsAPI{
  let apiKey = Secrets.pexelsAPI
  
  func searchImage(query: String) async throws -> String? {
//	 Print for time testing
//	 print("Started creating image \(Date.now.formatted(.dateTime.hour().minute().second()))")
		let urlString = "https://api.pexels.com/v1/search?query=\(query)&per_page=1"
		guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return nil }
		
		var request = URLRequest(url: url)
		request.setValue(apiKey, forHTTPHeaderField: "Authorization")
		
		let (data, _) = try await URLSession.shared.data(for: request)
		let result = try JSONDecoder().decode(PexelsResponse.self, from: data)
		
	 return result.photos.first?.src.large
  }
}
