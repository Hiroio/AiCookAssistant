//
//  ProfileViewModel.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI
import Combine


class ProfileViewModel: ObservableObject{
  @Published var user: UserModel
  @Published var selectedLanguage: AppLanguageEnum
  @Published var activeSheet: PreferenceTagType? = nil
  @Published var sheetText: String = ""
  
  var storedLanguage: String{
	 get{
		UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguageEnum.system.rawValue
	 }
	 set{
		UserDefaults.standard.set(newValue, forKey: "appLanguage")
	 }
  }
  
  private let userManager = UserManager.shared
  init() {
	 self.user = userManager.user
	 let language = UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguageEnum.system.rawValue
	 self.selectedLanguage = AppLanguageEnum(rawValue: language) ?? .system
  }
  
  func fetchUser(){
	 userManager.fetchUser()
	 self.user = userManager.user
	 self.selectedLanguage = AppLanguageEnum(rawValue: storedLanguage) ?? .system
  }
  
  func cancel() {
	 fetchUser()
	 activeSheet = nil
	 sheetText.removeAll()
  }
  
  func save() {
	 userManager.user = user
	 userManager.save()
	 storedLanguage = selectedLanguage.rawValue
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
  
  
  var recipes: [UIRecipeModel]{
	 RecipesManager.shared.recipes
  }
  
  var ingredientsCount: Int{
	 IngredientsManager.shared.ingredients.count
  }
}
