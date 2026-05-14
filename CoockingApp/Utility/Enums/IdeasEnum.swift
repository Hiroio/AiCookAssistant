//
//  IdeasEnum.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import Foundation


enum IdeasEnum: String, Identifiable, CaseIterable{
  case under20Min
  case easyDinner
  case breakfastIdea
  case comfortFood
  case onePanMeal
  case randomSurprise
  case chickenBased
  case potatoBased
  case pastaNight
  case cozySoup
  case budgetMeal
  case ovenDish
  case lunchBox
  case familyMeal
  case lightMeal
  case snackIdea
  case mamaRecipe
  
  
  var id: String {self.rawValue}
  
  static func getRandom() -> [IdeasEnum]{
	 Array(self.allCases.shuffled().prefix(4))
  }
}


// MARK: Design
extension IdeasEnum{
  
  var title: String {
	 switch self {
	 case .under20Min: return String(localized: "Under 20 min")
	 case .easyDinner: return String(localized: "Easy Dinner")
	 case .breakfastIdea: return String(localized: "Breakfast")
	 case .comfortFood: return String(localized: "Comfort Food")
	 case .onePanMeal: return String(localized: "One Pan")
	 case .randomSurprise: return String(localized: "Surprise Me")
	 case .chickenBased: return String(localized: "Chicken Dish")
	 case .potatoBased: return String(localized: "Potato Idea")
	 case .pastaNight: return String(localized: "Pasta Night")
	 case .cozySoup: return String(localized: "Warm Soup")
	 case .budgetMeal: return String(localized: "Budget Meal")
	 case .ovenDish: return String(localized: "Oven Recipe")
	 case .lunchBox: return String(localized: "Lunch Idea")
	 case .familyMeal: return String(localized: "Family Meal")
	 case .lightMeal: return String(localized: "Light Dish")
	 case .snackIdea: return String(localized: "Snack")
	 case .mamaRecipe: return String(localized: "Mama's Food")
	 }
  }
  
  var icon: String {
	 switch self {
	 case .under20Min: return "timer"
	 case .easyDinner: return "sparkles"
	 case .breakfastIdea: return "sunrise"
	 case .comfortFood: return "fork.knife"
	 case .onePanMeal: return "frying.pan"
	 case .randomSurprise: return "dice"
	 case .chickenBased: return "arcade.stick"
	 case .potatoBased: return "leaf"
	 case .pastaNight: return "takeoutbag.and.cup.and.straw"
	 case .cozySoup: return "drop"
	 case .budgetMeal: return "banknote"
	 case .ovenDish: return "flame"
	 case .lunchBox: return "briefcase"
	 case .familyMeal: return "person.3"
	 case .lightMeal: return "hare"
	 case .snackIdea: return "birthday.cake"
		case .mamaRecipe: return "oven"
	 }
  }
}



// MARK: Prompts

extension IdeasEnum {
  var prompt: String {
			switch self {
			case .under20Min:
				 return "Generate a quick and simple homemade recipe that can be cooked in under 20 minutes."
				 
			case .easyDinner:
				 return "Generate an easy dinner recipe with simple ingredients and beginner friendly instructions."
				 
			case .breakfastIdea:
				 return "Generate a tasty breakfast recipe that feels homemade and not too complicated."
				 
			case .comfortFood:
				 return "Generate a warm cozy comfort food recipe that feels satisfying and homemade."
				 
			case .onePanMeal:
				 return "Generate a practical one pan recipe with minimal cleanup and simple ingredients."
				 
			case .randomSurprise:
				 return "Generate a random delicious homemade dish idea. Surprise the user with something interesting."
				 
			case .chickenBased:
				 return "Generate a flavorful chicken based homemade recipe suitable for lunch or dinner."
				 
			case .potatoBased:
				 return "Generate a creative homemade dish where potatoes are one of the main ingredients."
				 
			case .pastaNight:
				 return "Generate a comforting pasta recipe that is easy to cook at home."
				 
			case .cozySoup:
				 return "Generate a warm homemade soup recipe that feels cozy and delicious."
				 
			case .budgetMeal:
				 return "Generate an affordable homemade meal using common low cost ingredients."
				 
			case .ovenDish:
				 return "Generate a tasty oven baked homemade dish with simple preparation."
				 
			case .lunchBox:
				 return "Generate a practical lunch recipe that is suitable for daytime and easy to prepare."
				 
			case .familyMeal:
				 return "Generate a homemade family style meal that feels filling and universally liked."
				 
			case .lightMeal:
				 return "Generate a lighter homemade dish that is not too heavy but still tasty."
			case .snackIdea:
				 return "Generate a quick snack or small bite recipe that is fun and easy to make."
			case .mamaRecipe:
			  return "Genarate a homemade recipe which can be named mama's."
			}
  
	  }
}
