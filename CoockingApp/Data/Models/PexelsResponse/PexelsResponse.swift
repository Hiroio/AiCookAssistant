//
//  PexelsResponse.swift
//  CoockingApp
//
//  Created by user on 30.04.2026.
//

import Foundation


struct PexelsResponse: Codable {
  let photos: [PexelPhoto]
}

struct PexelPhoto: Codable {
  let id: Int
  let url: String
  let src: PexelSource
}

struct PexelSource: Codable {
  let medium: String
  let large: String
  let landscape: String
}
