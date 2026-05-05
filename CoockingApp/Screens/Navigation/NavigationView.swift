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
		  Color.softIvory.ignoresSafeArea()
		  VStack{
			 switch navigationManager.mainNavigation {
			 case .main:
				MainView()
			 case .recipes:
				RecipeListView()
			 case .favorites:
				EmptyView()
			 case .profile:
				ProfileView()
			 }
		  }
		  .padding(.bottom, 30)
		  .safeAreaInset(edge: .bottom) {
			 MainNavigationBar()
		  }
		  
		  SecondaryScreensView()
		}
		.sheet(isPresented: $storeManager.showingSheet){
		  PaywallView()
		}
		
		.ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    NavigationView()
	 .environmentObject(NavigationManager.shared)
	 .environmentObject(StoreManager.shared)
}
