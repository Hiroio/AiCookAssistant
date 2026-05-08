//
//  PaywallFeaturesCard.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI

struct PaywallFeaturesCard: View {
  private let paywallFeatures: [(icon: String, title: String, description: String)] = [
	 ("infinity", "Unlimited Recipes", "Get unlimited access to AI-generated recipes with no limits."),
	 ("camera", "Photo Ingredient Analysis", "Snap a photo and AI will instantly detect ingredients for you."),
	 ("square.and.pencil", "Edit Your RecipeList", "Add, edit, delete and organize your personal recipe collections."),
	 ("frying.pan", "AI Cook Assistant", "Get step-by-step guidance, tips and answers to all your cooking questions.")
  ]
  var body: some View {
	 VStack{
		ForEach(paywallFeatures, id: \.title){(icon, title, desc) in
		  featureCard(icon: icon, title: title, desc: desc)
		  if paywallFeatures.last?.title != title{
			 Divider()
		  }
		}
	 }
	 .padding()
	 .background(
		RoundedRectangle(cornerRadius: 20)
		  .fill(.sageMist.opacity(0.6))
	 )
  }
}

#Preview {
  PaywallFeaturesCard()
}
