//
//  NavigationEnum.swift
//  CoockingApp
//
//  Created by user on 05.05.2026.
//

import Foundation



// Profile sheet
enum PreferenceTagType {
	 case avoidIngredients
	 case allergies
}

extension PreferenceTagType{
  var title: String{
	 switch self {
	 case .avoidIngredients:
		"Avoid Ingredients"
	 case .allergies:
		"Alergies/Restrictions"
	 }
  }
  
  var array: [String]{
	 switch self {
	 case .avoidIngredients:
		[
		"Onion",
		"Garlic",
		"Mushrooms",
		"Olives",
		"Seafood",
		"Eggplant",
		"Cilantro",
		"Peppers",
		"Tomatoes",
		"Beans",
		"Broccoli",
		"Spinach",
		"Zucchini",
		"Corn",
		"Cheese"
		]
	 case .allergies:
		[
		"Gluten",
		"Dairy",
		"Eggs",
		"Peanuts",
		"Tree Nuts",
		"Soy",
		"Fish",
		"Shellfish",
		"Sesame",
		"Lactose",
		"Vegan",
		"Vegetarian",
		"Pork Free",
		"Low Carb",
		"Spicy Free"
		]
	 }
  }
}
