//
//  RecipeModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation


struct RecipeModel: Codable{
  let name: String
  let difficulty: Int
  let description: String
  let ingredients: [String]
  let instructions: [String]
}
