//
//  RecipeCardView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI
import Kingfisher
struct RecipeCardView: View {
	 let recipe: UIRecipeModel
	 let recipeList: Bool

	 init(recipe: UIRecipeModel, recipeList: Bool = true) {
		  self.recipe = recipe
		  self.recipeList = recipeList
	 }

	 var body: some View {
		  VStack(spacing: 0) {
			 GeometryReader{ geo in
				KFImage(URL(string: recipe.imageUrl))
				  .placeholder {
					 RoundedRectangle(cornerRadius: 0)
						.fill(.herbalGreen.opacity(0.15))
						.overlay {
						  ProgressView()
						}
				  }
				  .retry(maxCount: 2, interval: .seconds(1))
				  .cancelOnDisappear(true)
				  .fade(duration: 0.25)
				  .resizable()
				  .scaledToFill()
				  .frame(width: geo.size.width, height: 120)
				  .clipped()
			 }
			 .frame(height: 120)
			 Spacer()
				VStack(alignment: .leading, spacing: 10) {
					 Text(recipe.name)
					 .font(recipeList ? .caption.bold() : .headline)
						  .lineLimit(2)
						  .multilineTextAlignment(.leading)
						  .frame(maxWidth: .infinity, alignment: .leading)

					 HStack(spacing: 12) {
						  HStack(spacing: 4) {
								Image(systemName: "clock")
								Text("\(recipe.time) min")
						  }

						  Rectangle()
								.frame(width: 1, height: 14)
								.foregroundStyle(.gray.opacity(0.3))

						  let difficulty = RecipeDifficulty.getDifficulty(recipe.difficulty)

						  HStack(spacing: 4) {
								Image(systemName: difficulty.icon)
								Text(difficulty.text)
						  }
						  .foregroundStyle(difficulty.color)
					 }
					 .font(recipeList ? .caption2 : .caption)
					 .foregroundStyle(.charcoal)
				}
				.padding(12)
				.background(.white)
		  }
		  .frame(maxHeight: .infinity)
		  .background(.white)
		  .clipShape(RoundedRectangle(cornerRadius: 18))
		  .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
		  .overlay(alignment: .topTrailing) {
				if recipeList {
					 Button {} label: {
						  Image(systemName: "heart")
								.foregroundStyle(.charcoal)
								.font(.subheadline)
								.padding(10)
								.background(Circle().fill(.white))
					 }
					 .padding(8)
				}
		  }
	 }
}


#Preview {
  RecipeCardView(recipe: .preview)
}
