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
		Group{
		  switch navigationManager.secondaryScreens {
		  case .creation(let ingredients):
			 CreationView(ingredients: ingredients)
				.transition(.move(edge: .bottom).combined(with: .opacity))
				.zIndex(1)
		  case .info(let recipe, let fromCreation):
			 RecipeInfoNavigation(recipe: recipe, fromCreation: fromCreation)
				.transition(.move(edge: .bottom).combined(with: .opacity))
				.zIndex(1)
		  default:
			 EmptyView()
		  }
		}
		.allowsHitTesting(navigationManager.secondaryScreens != nil)
		
		if let loadingScreen = navigationManager.loadingScreen{
		  LoadingScreen(type: loadingScreen)
			 .transition(.move(edge: .bottom))
			 .zIndex(1)
			 .allowsHitTesting(true)
		}
	 }
	 .animation(.bouncy, value: navigationManager.loadingScreen != nil)
	 .animation(.bouncy, value: navigationManager.secondaryScreens == nil)
	
  }
}

#Preview {
  SecondaryScreensView()
	 .environmentObject(NavigationManager.shared)
}
