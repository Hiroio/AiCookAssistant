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
			 .foregroundStyle(.charcoal)
			 .fixedSize(horizontal: false, vertical: true)
		  
		  VStack(alignment: .leading, spacing: 10){
			 statText(icon: "clock", value: "35 min")
			 statText(icon: "fork.knife.circle", value: "3")
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
				RadialGradient(colors: [.softIvory, .clear], center: .trailing, startRadius: 300, endRadius: 70)
			 )
		  RoundedRectangle(cornerRadius: 20)
			 .stroke(.mossGreen.opacity(0.5), lineWidth: 1)
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
				  .cornerRadius(20)
			 }placeholder: {
				Rectangle()
			 }
			 .scaledToFill()
		  }else{
			 Image("test")
				.resizable()
				.scaledToFill()
				.cornerRadius(20)
		  }
		}
	 )
	 .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
  DishCard(recipe: UIRecipeModel(name: "", time: "", difficulty: 2, description: "", ingredients: [], instructions: [], imageUrl: "https://images.pexels.com/photos/34326260/pexels-photo-34326260.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200", chatHistory: []))
}
