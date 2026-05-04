//
//  UserModel.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import Foundation



struct UserModel{
  let username: String
  let alergieIngredients: [String]
  let avoidIngredients: [String]
  
  init(entity: UserEntity){
	 self.username = entity.username ?? "New Chef"
	 self.alergieIngredients = (entity.allergies ?? "").components(separatedBy: "\n")
	 self.avoidIngredients = (entity.avoid ?? "").components(separatedBy: "\n")
  }
}
