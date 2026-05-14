//
//  NavigationPopUpView.swift
//  CoockingApp
//
//  Created by Codex on 08.05.2026.
//

import SwiftUI

struct NavigationPopUpView: View {
  let popup: NavigationPopup
  let primaryAction: () -> Void
  let secondaryAction: () -> Void
  
  var body: some View {
		
		VStack(spacing: 0) {
			  Image("dirtyDishes")
				 .resizable()
				 .scaledToFit()
				 .accessibilityHidden(true)
		  
		  VStack{
			 VStack(spacing: 8) {
				Text(popup.title)
				  .font(.headline)
				  .foregroundStyle(Color.primarytext)
				  .multilineTextAlignment(.center)
				
				Text(popup.message)
				  .font(.footnote)
				  .foregroundStyle(Color.primarytext.opacity(0.62))
				  .multilineTextAlignment(.center)
				  .fixedSize(horizontal: false, vertical: true)
			 }
			 
			 VStack(spacing: 12) {
				Button {
				  primaryAction()
				} label: {
				  Text(popup.primaryButtonTitle)
					 .font(.subheadline.weight(.semibold))
					 .foregroundStyle(Color.background)
					 .padding(.vertical, 12)
					 .frame(maxWidth: .infinity)
					 .background(
						RoundedRectangle(cornerRadius: 16)
						  .fill(Color.primaryAction)
					 )
				}
				
				Button {
				  secondaryAction()
				} label: {
				  Text(popup.secondaryButtonTitle)
					 .font(.subheadline.weight(.semibold))
					 .foregroundStyle(Color.primaryAction)
					 .padding(.vertical, 10)
					 .frame(maxWidth: .infinity)
					 .background(
						RoundedRectangle(cornerRadius: 16)
						  .fill(Color.rareCard.opacity(0.3))
					 )
				}
			 }
			 .buttonStyle(.plain)
		  }
		  .padding()
		}
		.frame(maxWidth: 310)
		.background(
		  RoundedRectangle(cornerRadius: 24)
			 .fill(Color.background)
			 .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
			)
			.padding(.vertical, 28)
			.modalAccessibility(popup.title)
	  }
}

#Preview {
  NavigationPopUpView(
	 popup: .weeklyLimit(.recipeGeneration),
	 primaryAction: {},
	 secondaryAction: {}
  )
}
