//
//  NavigationView.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI

struct NavigationView: View {
  @EnvironmentObject private var storeManager: StoreManager
  @EnvironmentObject private var navigationManager: NavigationManager
    var body: some View {
		ZStack(alignment: .bottom){
		  Color.background.ignoresSafeArea()
		  VStack{
			 switch navigationManager.mainNavigation {
			 case .main:
				MainView()
			 case .recipes:
				RecipeListView()
			 case .products:
				IngredientsSectionView()
			 case .profile:
				ProfileView()
			 }
		  }
		  .safeAreaInset(edge: .bottom) {
			 MainNavigationBar()
		  }
		  
		  SecondaryScreensView()
		  
		  if let popup = navigationManager.popup {
			 ZStack{
				Color.black.opacity(0.18)
				  .ignoresSafeArea()
				  .onTapGesture {
					 navigationManager.popup = nil
				  }
			 NavigationPopUpView(
				popup: popup,
				primaryAction: {
				  navigationManager.popup = nil
				  storeManager.showingSheet = true
				},
				secondaryAction: {
				  navigationManager.popup = nil
				}
			 )
			 .transition(.opacity.combined(with: .scale(scale: 0.96)))
		  }
			 .zIndex(2)
			 .allowsHitTesting(navigationManager.popup != nil)
		  }
//		  MARK: Error PopUp
		  if let error = navigationManager.error {
			 ZStack{
				Color.black.opacity(0.08)
				  .ignoresSafeArea()
				  .onTapGesture {
					 navigationManager.error = nil
				  }
				ErrorPopUpView(error: error) {
				  navigationManager.error = nil
				}
				  .transition(.opacity.combined(with: .scale(scale: 0.96)))
			 }
			 .zIndex(1)
			 .allowsHitTesting(navigationManager.error != nil)
		  }
		}
//		MARK: Paywall
		.sheet(isPresented: $storeManager.showingSheet){
		  PaywallView()
		}
		.animation(.easeInOut(duration: 0.2), value: navigationManager.popup != nil)
		
		.ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    NavigationView()
	 .environmentObject(NavigationManager.shared)
	 .environmentObject(StoreManager.shared)
}
