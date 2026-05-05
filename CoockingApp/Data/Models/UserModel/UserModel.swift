//
//  UserModel.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import Foundation



struct UserModel{
  var username: String
  var alergieIngredients: [String]
  var avoidIngredients: [String]
  
  init(entity: UserEntity){
	 self.username = entity.username ?? "New Chef"
	 self.alergieIngredients = entity.allergies.getArray()
	 self.avoidIngredients = entity.avoid.getArray()
  }
  
}



extension String? {
  func getArray() -> [String]{
	 if let string = self, !string.isEmpty{
		return string.components(separatedBy: "|")
	 }else{
		return []
	 }
  }
}
