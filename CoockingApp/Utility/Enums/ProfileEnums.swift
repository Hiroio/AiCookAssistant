//
//  ProfileEnums.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import Foundation

protocol ProfilePickerOption: CaseIterable, Identifiable, Hashable {
  var text: String { get }
}

enum CookingIdentityEnum: String, ProfilePickerOption {
	 case homeCook
	 case curiousCook
	 case quickMeals
	 case baker
	 case familyCook
	 case healthyCook
	 case comfortCook
	 case proChef
  
  var id: String{ self.rawValue }
  
  var text: String{
	 switch self {
	 case .homeCook:
		"Home cook"
	 case .curiousCook:
		"Curious Cook"
	 case .quickMeals:
		"Quick Mealer"
	 case .baker:
		"Baker"
	 case .familyCook:
		"Family Chef"
	 case .healthyCook:
		"Healthy Chef"
	 case .comfortCook:
		"Comfort Chef"
	 case .proChef:
		"Michelin Chef"
	 }
  }
}

enum AppLanguageEnum: String, ProfilePickerOption {
  case system
  case english = "en"
  case ukrainian = "uk"
  case polish = "pl"
  case german = "de"
  case french = "fr"
  case spanish = "es"
  case italian = "it"
  case portugueseBrazil = "pt-BR"
  
  var id: String { self.rawValue }
  
  var text: String {
	 switch self {
	 case .system:
		"System"
	 case .english:
		"English"
	 case .ukrainian:
		"Українська"
	 case .polish:
		"Polski"
	 case .german:
		"Deutsch"
	 case .french:
		"Français"
	 case .spanish:
		"Español"
	 case .italian:
		"Italiano"
	 case .portugueseBrazil:
		"Português (Brasil)"
	 }
  }
  
  var localeIdentifier: String? {
	 switch self {
	 case .system:
		nil
	 default:
		rawValue
	 }
  }
}
