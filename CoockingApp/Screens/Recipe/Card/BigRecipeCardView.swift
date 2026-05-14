//
//  BigRecipeCardView.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI
import Kingfisher

struct BigRecipeCardView: View {
  let recipe: UIRecipeModel
  let info: Bool
  
  init(recipe: UIRecipeModel, info: Bool = false) {
	 self.recipe = recipe
	 self.info = info
  }
  var body: some View {
		HStack{
		  VStack(alignment: .leading, spacing: 20){
			 Text(recipe.name)
				.title(weight: .bold, color: .primarytext)
				.font(UIDevice.isIPad ? .title : .title3)
				.multilineTextAlignment(.leading)
				.lineLimit(nil)
				.minimumScaleFactor(0.65)
				.allowsTightening(true)
			 
			 Text(recipe.description)
				.font(.caption)
				.fontDesign(.rounded)
				.lineLimit(info ? nil : 2)
				
			 
			 VStack(alignment: .leading, spacing: 5){
				statText(icon: "clock", value: "35 min")
				statText(icon: "align.vertical.bottom", value: RecipeDifficulty.getDifficulty(recipe.difficulty).text)
			 }
			 .font(.subheadline)
			 .fontDesign(.rounded)
		  }
		  .frame(maxWidth: .infinity)
		  Spacer()
			 .frame(maxWidth: .infinity)
		}
		.frame(maxHeight: .infinity)
	 .padding()
	 .padding(.vertical)
	 .background(
		ZStack{
		  Rectangle()
			 .fill(
				LinearGradient(colors: [Color.background, Color.background.opacity(0.9), .clear], startPoint: .leading, endPoint: .trailing)
			 )
		  RoundedRectangle(cornerRadius: 20)
			 .stroke(Color.primaryAction.opacity(0.5), lineWidth: 1)
//			 .shadow(radius: 1)
		}
	 )
	 .background(
		HStack(alignment: .top){
			 KFImage(URL(string: recipe.imageUrl))
				.placeholder {
				  RoundedRectangle(cornerRadius: 0)
					 .fill(Color.accentCard.opacity(0.15))
					 .overlay {
						ProgressView()
					 }
				}
				.retry(maxCount: 2, interval: .seconds(1))
				.cancelOnDisappear(true)
				.fade(duration: 0.25)
				.resizable()
				.scaledToFill()
				.clipped()
		}
	 )
		 .clipShape(RoundedRectangle(cornerRadius: 20))
		 .compositingGroup()
		 .shadow(radius: 3, y: 3)
		 .recipeCardAccessibility(recipe, action: info ? "Recipe summary" : "Open recipe details")
			 
	  }
}

#Preview {
  BigRecipeCardView(recipe: .preview, info: true)
}
