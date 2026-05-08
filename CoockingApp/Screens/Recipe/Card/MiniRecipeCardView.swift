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
	 .frame(width: 90)
	 .padding()
	 .background(
		ZStack{
		  Color.background
		  Color.rareCard.opacity(0.1)
		}
	 )
	 .clipShape(
		UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 15, bottomTrailing: 15, topTrailing: 0))
	 )
	 .padding(.top, 10)
	 .overlay(alignment: .top) {
		Image("pin")
		  .resizable()
		  .scaledToFit()
		  .frame(height: 24)
		  .blur(radius: 0.5)
	 }
	 .compositingGroup()
	 .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
  }
}


#Preview {
  MiniRecipeCardView(recipe: .preview)
}
