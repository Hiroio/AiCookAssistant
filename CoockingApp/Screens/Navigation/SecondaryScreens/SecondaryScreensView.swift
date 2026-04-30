//
//  SecondaryScreensView.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI

struct SecondaryScreensView: View {
  @EnvironmentObject private var navigationManager: NavigationManager
  var body: some View {
	 ZStack{
		switch navigationManager.secondaryScreens {
		case .creation:
		  CreationView()
		case .info(let recipe):
		   RecipeInfoNavigation(recipe: recipe)
		default:
		  EmptyView()
		}
		
		if navigationManager.isLoading{
		  LoadingScreen()
			 .transition(.move(edge: .bottom))
			 .zIndex(1)
			 .allowsHitTesting(false)
		}
	 }
	 .animation(.default, value: navigationManager.isLoading)
	 .animation(.default, value: navigationManager.secondaryScreens == nil)
	
  }
}

#Preview {
    SecondaryScreensView()
	 .environmentObject(NavigationManager.shared)
}
