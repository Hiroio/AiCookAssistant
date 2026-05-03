//
//  RecipeCardView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct RecipeCardView: View {
  let recipe: UIRecipeModel
  var body: some View {
	 VStack(spacing: 0){
		AsyncImage(url: URL(string: recipe.imageUrl)){ image in
		  image
			 .resizable()
			 .scaledToFit()
			 .cornerRadius(20)
		}placeholder: {
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.herbalGreen)
			 .scaledToFit()
		}
		VStack(alignment: .leading, spacing: 25){
		  Text(recipe.name)
			 .font(.headline)
		  
		  HStack{
			 Image(systemName: "clock")
			 Text("\(recipe.time) min  ")
			 
			 Image(systemName: "fork.knife")
			 Text("\(recipe.difficulty)")
			 
			 Spacer()
			 Button{}label: {
				Image(systemName: "heart")
				  .font(.title2	)
				  
			 }
		  }
		  .foregroundStyle(.herbalGreen)
		  .padding(.horizontal)
		}
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.white)
		)
		.offset(y: -30)
	 }
	 .shadow(radius: 5)
  }
}

#Preview {
  RecipeCardView(recipe: .preview)
}
