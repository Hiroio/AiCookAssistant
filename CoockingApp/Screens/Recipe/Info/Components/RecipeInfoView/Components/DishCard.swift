//
//  DishCard.swift
//  CoockingApp
//
//  Created by user on 01.05.2026.
//

import SwiftUI

struct DishCard: View {
  let recipe: UIRecipeModel
    var body: some View {
		VStack(alignment: .leading, spacing: 20){
		  Text(recipe.name)
			 .font(.largeTitle)
			 .multilineTextAlignment(.leading)
			 .fontDesign(.serif)
			 .fontWeight(.bold)
			 .padding(.trailing, 80)
			 .foregroundStyle(.primarytext)
			 .fixedSize(horizontal: false, vertical: true)
		  
		  VStack(alignment: .leading, spacing: 10){
			 statText(icon: "clock", value: "35 min")
			 
			 let difficulty = RecipeDifficulty.getDifficulty(recipe.difficulty)
			 statText(icon: "\(difficulty.icon).fill", value: difficulty.text)
				.foregroundStyle(difficulty.color)
		  }
		  
		  Text(recipe.description)
			 .multilineTextAlignment(.leading)
	 
		}
	 .padding()
	 .padding(.vertical)
	 .padding(.trailing, 50)
	 .background(
		ZStack{
		  Rectangle()
			 .fill(
				RadialGradient(colors: [Color.background, .clear], center: .trailing, startRadius: 300, endRadius: 70)
			 )
		  RoundedRectangle(cornerRadius: 20)
			 .stroke(.accentCard.opacity(0.5), lineWidth: 1)
			 .shadow(radius: 1)
		}
	 )
	 .background(
		HStack(alignment: .top){
		  if let url = URL(string: recipe.imageUrl){
			 AsyncImage(url: url){ image in
					image
					  .resizable()
					  .scaledToFit()
					  .clipShape(.rect(cornerRadius: 20))
			 }placeholder: {
				Rectangle()
			 }
			 .scaledToFill()
		  }else{
				 Image("test")
					.resizable()
					.scaledToFill()
					.clipShape(.rect(cornerRadius: 20))
		  }
		}
	 )
	 .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
  DishCard(recipe: .preview)
}
