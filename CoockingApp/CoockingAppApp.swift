//
//  CoockingAppApp.swift
//  CoockingApp
//
//  Created by user on 28.04.2026.
//

import SwiftUI

@main
struct CoockingAppApp: App {
  init(){
	 let _ = CoreDataManager.shared
	 let _ = UserManager.shared
	 let _ = RecipesManager.shared
	 let _ = IngredientsManager.shared
  }
  @StateObject private var storeManager = StoreManager.shared
  @StateObject private var navigationManager = NavigationManager.shared
  @AppStorage("appLanguage") private var appLanguage = AppLanguageEnum.system.rawValue
  
  var body: some Scene {
	 WindowGroup {
		NavigationView()
		  .environmentObject(navigationManager)
		  .environmentObject(storeManager)
		  .environment(\.locale, currentLocale)
	 }
  }
  
  private var currentLocale: Locale {
	 let language = AppLanguageEnum(rawValue: appLanguage) ?? .system
	 if let identifier = language.localeIdentifier {
		return Locale(identifier: identifier)
	 } else {
		return .autoupdatingCurrent
	 }
  }
}
