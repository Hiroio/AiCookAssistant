//
//  UserManager.swift
//  CoockingApp
//
//  Created by user on 08.05.2026.
//

import Foundation
import Combine

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
	 
	 if Date() >= refreshDate {
		user.freeGenerationsUsed = 0
		user.freeScanUses = 0
		user.freeIdeasUsed = 0
		user.latestRefreshDate = Date()
		save()
	 }
  }
  
}
