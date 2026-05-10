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
  
  var totalCookedTimes: Int{
	 filter({$0.timesCooked > 0}).reduce(0) { partialResult, recipe in
		partialResult + recipe.timesCooked
	 }
  }
  
  var totalFavorites: Int{
	 filter({ $0.isFavorite }).count
  }
  
  var totalSaved: Int{
	 filter{!$0.isRecommended}.count
  }
  
  var avarageCookingTime: String{
	 return "20"
  }
  
  var avarageDifficulty: RecipeDifficulty{
	 return .easy
  }
}
