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
  @Published var activeSheet: PreferenceTagType? = nil
  @Published var sheetText: String = ""
  
  private let coreDataManager = CoreDataManager.shared
  init() {
	 self.user = UserModel(entity: coreDataManager.fetchUser())
  }
  
  func fetchUser(){
	 let entity = coreDataManager.fetchUser()
	 self.user = UserModel(entity: entity)
  }
  
  func cancel() {
	 fetchUser()
	 activeSheet = nil
  }
  
  func save() {
	 coreDataManager.editUser(user: user)
	 activeSheet = nil
  }
  
  func sheetAction(item: String){
	 switch activeSheet {
	 case .avoidIngredients:
		addAvoid(item)
	 case .allergies:
		addAllegrie(item)
	 case nil:
		activeSheet = nil
	 }
  }
  
  func textAction(){
	 sheetAction(item: sheetText)
	 sheetText.removeAll()
  }
  
  func addAllegrie(_ alergie: String){
	 if user.alergieIngredients.contains(where: {$0.lowercased() == alergie.lowercased()}){
		user.alergieIngredients.removeAll(where: {$0.lowercased() == alergie.lowercased()})
	 }else{
		user.alergieIngredients.insert(alergie.capitalized, at: 0)
	 }
  }
  
  
  func addAvoid(_ avoid: String){
	 if user.avoidIngredients.contains(where: {$0.lowercased() == avoid.lowercased()}){
		user.avoidIngredients.removeAll(where: {$0.lowercased() == avoid.lowercased()})
	 }else{
		user.avoidIngredients.insert(avoid.capitalized, at: 0)
	 }
  }
  
  func getListOfPreferences() -> [String]{
	 switch activeSheet {
	 case .avoidIngredients:
		PreferenceTagType.avoidIngredients.array.filter({item in !user.avoidIngredients.contains(where: {$0.lowercased() == item.lowercased()})})
	 case .allergies:
		PreferenceTagType.allergies.array.filter({item in !user.alergieIngredients.contains(where: {$0.lowercased() == item.lowercased()})})
	 case nil:
		[]
	 }
  }
  
  
}
