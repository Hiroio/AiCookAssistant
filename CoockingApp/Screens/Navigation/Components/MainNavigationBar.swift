//
//  MainNavigationBar.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct MainNavigationBar: View {
  @Namespace var nameSpace
  @EnvironmentObject private var navigationManager: NavigationManager
    var body: some View {
		HStack{
		  ForEach(MainNavigationEnum.allCases){item in
			 let selected = navigationManager.mainNavigation == item
			 Button{
				navigationManager.mainNavigation = item
			 }label:{
				ZStack(alignment: .top){
				  if selected {
					 Rectangle()
						.frame(height: 5)
						.opacity(0.4)
						.padding(.horizontal, 5)
						.shadow(radius: 6, y: 5)
						.matchedGeometryEffect(id: "Navigation", in: nameSpace)
				  }
				  VStack{
					 Image(systemName: "\(item.icon)\(selected ? ".fill" : "")")
						.font(.title2)
					 Text(item.title)
						.font(.caption)
				  }
				  .padding()
				}
				.foregroundStyle(Color.primaryAction)
				.frame(maxWidth: .infinity)
				
				
				
				 }
				 .accessibilityLabel(Text(item.title))
				 .accessibilityHint(Text("Switches to \(item.title) tab"))
				 .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
			  }
		}
		.background(
		  Color.rareCard.opacity(0.5)
		)
		.overlay(
		  Button{
			 navigationManager.secondaryScreens = .creation()
		  }label: {
			 Image(systemName: "plus")
				.font(.title2)
				.foregroundStyle(Color.background)
				.padding(20)
				.background(
				  Circle()
					 .fill(Color.accentCard)
				)
				.contentShape(.circle)
			  }
			  .iconButtonAccessibility("Create recipe", hint: "Opens recipe creation")
				 .offset(y: -35)
		  ,
			 alignment: .top
		)
		.animation(.bouncy, value: navigationManager.mainNavigation)
    }
}

#Preview {
    MainNavigationBar()
	 .environmentObject(NavigationManager.shared)
}
