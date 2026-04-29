//
//  RecipeInfoViewModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import Combine

class RecipeInfoViewModel: ObservableObject{
  let recipe: RecipeModel
  
  
  init(recipe: RecipeModel) {
	 self.recipe = recipe
  }
  
}
