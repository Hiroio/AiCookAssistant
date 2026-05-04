//
//  RecipeListViewModel.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import Foundation
import Combine


class RecipeListViewModel: ObservableObject{
  @Published var recipes: [UIRecipeModel] = [.preview, .preview2]
  @Published var searchType: Bool = false
  @Published var searchText: String = ""
  
  private let recipesManager = RecipesManager.shared
  
  init(){
//	 self.recipes = recipesManager.recipes
  }
  
  
}
