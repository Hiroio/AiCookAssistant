//
//  RecipeEnum.swift
//  CoockingApp
//
//  Created by user on 01.05.2026.
//

import Foundation
import SwiftUI

enum RecipeChatRoleEnum: String, Codable{
  case user, model
}


enum RecipeDifficulty: String{
  case easy, medium, hard
  
  var text: String {self.rawValue.capitalized}
  
  var color: Color{
	 switch self {
	 case .easy:
		  .mossGreen
	 case .medium:
		  .orange
	 case .hard:
		  .red
	 }
  }
  
  
  var icon: String {"align.vertical.bottom"}
  
  static func getDifficulty(_ num: Int) -> RecipeDifficulty{
	 switch num{
	 case 1...2:
		return .easy
	 case 3:
		return .medium
	 default:
		return .hard
	 }
  }
  
}
