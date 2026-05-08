//
//  RecipesExtension.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation


extension Array where Element == UIRecipeModel{
  var recipeList: [String]{
	 self.map({$0.name})
  }
}
