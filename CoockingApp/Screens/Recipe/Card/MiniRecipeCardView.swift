//
//  RecipeCardView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI
import Kingfisher
struct MiniRecipeCardView: View {
  let recipe: UIRecipeModel
  
  init(recipe: UIRecipeModel) {
	 self.recipe = recipe
  }
  
  var body: some View {
	 VStack(spacing: 10){
		Text(recipe.name)
		  .font(.footnote.weight(.medium))
		  .foregroundStyle(Color.primaryAction)
		  .fontDesign(.serif)
		  .multilineTextAlignment(.center)
		  .lineLimit(2)
		HStack(spacing: 5){
		  HStack(spacing: 4) {
			 Image(systemName: "clock")
			 Text("\(recipe.time)")
		  }
		  
		  Circle()
			 .fill(Color.primarytext.opacity(0.22))
			 .frame(width: 3, height: 3)
		  
		  let difficulty = RecipeDifficulty.getDifficulty(recipe.difficulty)
		  
		  HStack(spacing: 4) {
			 Image(systemName: "\(difficulty.icon).fill")
				.foregroundStyle(difficulty.color)
			 Text(difficulty.text.prefix(1))
		  }
		  
		}
		.font(.caption2)
		.foregroundStyle(Color.primarytext.opacity(0.62))
	 }
	 .latestCard()
  }
}


#Preview {
  MiniRecipeCardView(recipe: .preview)
}
