//
//  PaywallFeaturesCard.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI

struct PaywallFeaturesCard: View {
  private let paywallFeatures: [(icon: String, title: String, description: String)] = [
	 ("infinity", "Unlimited Recipes", "Create as many recipe ideas as you need."),
	 ("camera", "Photo Ingredient Scan", "Turn ingredients into recipe ideas."),
	 ("square.and.pencil", "Recipe Notebook", "Save, edit and organize your dishes."),
	 ("frying.pan", "Cooking Assistant", "Get tips and answers while you cook.")
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
		  .fill(Color.rareCard.opacity(0.2))
	 )
  }
}

@ViewBuilder
func featureCard(icon: String, title: String, desc: String)-> some View{
  HStack{
	 Image(systemName: icon)
		.font(.headline)
		.frame(width: 45, height: 45)
	 VStack(alignment: .leading){
		Text(title)
		  .font(.headline)
		Text(desc)
		  .font(.caption)
		  .foregroundStyle(.primarytext.opacity(0.6))
	 }
	 .frame(maxWidth: .infinity, alignment: .leading)
  }
  .foregroundStyle(.primaryAction)
}
#Preview {
  PaywallFeaturesCard()
}
