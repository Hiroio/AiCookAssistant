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
  }
  @StateObject private var storeManager = StoreManager.shared
  @StateObject private var navigationManager = NavigationManager.shared
  var body: some Scene {
	 WindowGroup {
		NavigationView()
		  .environmentObject(navigationManager)
		  .environmentObject(storeManager)
	 }
  }
}
