//
//  RecipeInfoViewModel.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import Foundation
import Combine

class RecipeInfoViewModel: ObservableObject{
  let recipe: UIRecipeModel
  @Published var screenState: InfoScreenEnum = .info
  
  init(recipe: UIRecipeModel) {
	 self.recipe = recipe
  }
  
}


enum InfoScreenEnum: String, CaseIterable, Identifiable{
  case info, instructions, aiassistance
  
  var id: String{self.rawValue}
  
  var text: String{
	 switch self {
	 case .info:
		"Info"
	 case .instructions:
		"Instructions"
	 case .aiassistance:
		"AIAssistance"
	 }
  }
}
