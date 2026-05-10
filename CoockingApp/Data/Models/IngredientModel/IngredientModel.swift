//
//  IngredientModel.swift
//  CoockingApp
//
//  Created by user on 09.05.2026.
//

import Foundation

struct IngredientModel: Identifiable{
  var id: UUID
  var name: String
  var category: CategoriesEnum
  var isFavorite: Bool
  
  static let vegi = IngredientModel(id: UUID(), name: "Potato", category: .vegetables, isFavorite: false)
  static let fruit = IngredientModel(id: UUID(), name: "Apple", category: .fruits, isFavorite: false)
  static let chicken = IngredientModel(id: UUID(), name: "Chicken breast", category: .protein, isFavorite: false)
  static let dairy = IngredientModel(id: UUID(), name: "Milk", category: .dairy, isFavorite: false)
  static let spices = IngredientModel(id: UUID(), name: "Paper", category: .spices, isFavorite: false)
  static let sauce = IngredientModel(id: UUID(), name: "Ketchup", category: .sauces, isFavorite: false)
  static let grain = IngredientModel(id: UUID(), name: "Oatmeal", category: .grains, isFavorite: false)
  static let other = IngredientModel(id: UUID(), name: "SMTH", category: .other, isFavorite: false)
}


extension IngredientModel{
  init(entity: IngredientsEntity){
	 self.id = entity.id ?? UUID()
	 self.name = entity.name ?? ""
	 self.category = CategoriesEnum(rawValue: entity.category ?? "other") ?? .other
	 self.isFavorite = entity.isFavorite
  }
}
