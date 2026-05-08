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
  var body: some View {
		HStack{
		  VStack(alignment: .leading, spacing: 20){
			 Text(recipe.name)
				.title(weight: .bold, color: .primarytext)
				.font(.title2)
				.multilineTextAlignment(.leading)
				.fixedSize(horizontal: false, vertical: true)
			 
			 Text(recipe.description)
				.font(.caption)
				.fontDesign(.rounded)
				
			 
			 VStack(alignment: .leading, spacing: 5){
				statText(icon: "clock", value: "35 min")
				statText(icon: "align.vertical.bottom", value: RecipeDifficulty.getDifficulty(recipe.difficulty).text)
			 }
			 .font(.subheadline)
			 .fontDesign(.rounded)
		  }
		  .frame(maxWidth: .infinity)
		  Spacer()
			 .frame(maxWidth: 200)
		}
	 .padding()
	 .padding(.vertical)
	 .background(
		ZStack{
		  Rectangle()
			 .fill(
				LinearGradient(colors: [Color.background, Color.background.opacity(0.9), .clear], startPoint: .topLeading, endPoint: .trailing)
			 )
		  RoundedRectangle(cornerRadius: 20)
			 .stroke(Color.primaryAction.opacity(0.5), lineWidth: 1)
			 .shadow(radius: 1)
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
	 
  }
}

#Preview {
  BigRecipeCardView(recipe: .preview)
}
