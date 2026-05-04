//
//  ProfileViewModel.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import Foundation
import Combine


class ProfileViewModel: ObservableObject{
  @Published var user: UserModel
  
  private let coreDataManager = CoreDataManager.shared
  init() {
	 self.user = UserModel(entity: coreDataManager.fetchUser())
  }
  
  
}
