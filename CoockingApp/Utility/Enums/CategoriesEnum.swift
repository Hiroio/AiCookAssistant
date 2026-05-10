//
//  CategoriesEnum.swift
//  CoockingApp
//
//  Created by user on 09.05.2026.
//

import Foundation


enum CategoriesEnum: String, Identifiable, CaseIterable{
  case favorite, vegetables, fruits, protein, dairy, grains, spices, sauces, other

  
  var id: String { self.rawValue }
  
  var icon: String{
	 self.rawValue.capitalized
  }
  
  var background: String{
	 switch self {
	 case .favorite:
		"heart"
	 case .vegetables:
		"VegetablesBackground"
	 case .fruits:
		"FruitsBackground"
	 case .protein:
		"ProteinBackground"
	 case .dairy:
		"DairyBackground"
	 case .grains:
		"GrainsBackground"
	 case .spices:
		"SpicesBackground"
	 case .sauces:
		"SaucesBackground"
	 case .other:
		"OtherBackground"
	 }
  }
  
  var opacity: Double{
	 switch self {
	 case .favorite:
		1.0
	 case .vegetables:
		0.5
	 case .fruits:
		0.3
	 case .protein:
		0.3
	 case .dairy:
		0.2
	 case .grains:
		0.7
	 case .spices:
		0.5
	 case .sauces:
		0.6
	 case .other:
		0.4
	 }
  }
}
