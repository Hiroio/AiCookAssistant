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
		  case .creation:
			 CreationView()
				.transition(.move(edge: .bottom).combined(with: .opacity))
				.zIndex(1)
		  case .info(let recipe):
			 RecipeInfoNavigation(recipe: recipe)
		  default:
			 EmptyView()
		  }
		}
		.allowsHitTesting(navigationManager.secondaryScreens != nil)
		
		if navigationManager.isLoading{
		  LoadingScreen()
			 .transition(.move(edge: .bottom))
			 .zIndex(1)
			 .allowsHitTesting(false)
		}
	 }
	 .animation(.bouncy, value: navigationManager.isLoading)
	 .animation(.bouncy, value: navigationManager.secondaryScreens == nil)
	
  }
}

#Preview {
    SecondaryScreensView()
	 .environmentObject(NavigationManager.shared)
}
