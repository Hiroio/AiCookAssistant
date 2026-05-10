//
//  UserModel.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import Foundation



struct UserModel{
  var username: String
  var cookingIdentity: CookingIdentityEnum
  var alergieIngredients: [String]
  var avoidIngredients: [String]
  var freeGenerationsUsed: Int
  var freeScanUses: Int
  var freeIdeasUsed: Int
  var latestRefreshDate: Date
  
  init(entity: UserEntity){
	 self.username = entity.username ?? "New Chef"
	 self.cookingIdentity = CookingIdentityEnum(rawValue: entity.cookingIdentity ?? "") ?? .comfortCook
	 self.alergieIngredients = entity.allergies.getArray()
	 self.avoidIngredients = entity.avoid.getArray()
	 self.freeGenerationsUsed = Int(entity.freeGenerationsUsed)
	 self.freeScanUses = Int(entity.freeScanUses)
	 self.freeIdeasUsed = Int(entity.freeIdeasUsed)
	 self.latestRefreshDate = entity.latestRefreshDate ?? Date()
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
