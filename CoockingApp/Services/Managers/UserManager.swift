//
//  UserManager.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation
import Combine

class UserManager{
  static let shared = UserManager()
  
  @Published var user: UserModel
  
  let coreDataManager = CoreDataManager.shared
  private init() {
	 user = UserModel(entity: coreDataManager.fetchUser())
  }
  
  func save() {
	 coreDataManager.editUser(user: user)
  }
  
  
  func fetchUser() {
	 let entity = coreDataManager.fetchUser()
	 self.user = UserModel(entity: entity)
  }
  
}
