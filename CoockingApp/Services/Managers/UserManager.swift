//
//  UserManager.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation
import Combine

@MainActor
class UserManager: ObservableObject{
  static let shared = UserManager()
  
  @Published var user: UserModel
  
  let coreDataManager = CoreDataManager.shared
  private init() {
	 user = UserModel(entity: coreDataManager.fetchUser())
	 refreshWeeklyLimitsIfNeeded()
  }
  
  func save() {
	 coreDataManager.editUser(user: user)
  }
  
  
  func fetchUser() {
	 let entity = coreDataManager.fetchUser()
	 self.user = UserModel(entity: entity)
	 refreshWeeklyLimitsIfNeeded()
  }
  
  func refreshWeeklyLimitsIfNeeded() {
	 let calendar = Calendar.current
	 guard let refreshDate = calendar.date(byAdding: .day, value: 7, to: user.latestRefreshDate) else { return }

	 guard Date() >= refreshDate else { return }

	 var updatedUser = user
	 updatedUser.freeGenerationsUsed = 0
	 updatedUser.freeScanUses = 0
	 updatedUser.freeIdeasUsed = 0
	 updatedUser.latestRefreshDate = Date()
	 user = updatedUser
	 save()
  }
  
  func changeCookingIdentity(identity: CookingIdentityEnum){
	 user.cookingIdentity = identity
	 save()
  }
  
//  Free functionality for user
  func addCameraUser(){
	 user.freeScanUses += 1
	 
	 coreDataManager.addCameraUse()
  }
  func addGenerationUser(){
	 user.freeGenerationsUsed += 1
	 coreDataManager.addGenerationUse()
  }
  func addIdeaGenerationUser(){
	 user.freeIdeasUsed += 1
	 coreDataManager.addIdeaGenerationUse()
  }
  
}
