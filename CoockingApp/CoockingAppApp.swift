//
//  CoockingAppApp.swift
//  CoockingApp
//
//  Created by user on 28.04.2026.
//

import SwiftUI

@main
struct CoockingAppApp: App {
  @StateObject private var navigationManager = NavigationManager.shared
  var body: some Scene {
	 WindowGroup {
		SecondaryScreensView()
		  .environmentObject(navigationManager)
	 }
  }
}
