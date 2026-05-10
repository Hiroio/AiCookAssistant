//
//  FavoriteIngredientCard.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct FavoriteIngredientCard: View {
    var body: some View {
		HStack(alignment: .top){
		Image(systemName: "leaf")
		  .badgeIcon(color: .primaryAction.opacity(0.5))
		VStack(alignment: .leading){
		  HStack{
			 VStack(alignment: .leading){
				Text("Favorites Ingredients")
				  .font(.subheadline.bold())
				Text("Your favorites")
				  .font(.caption2)
				  .opacity(0.6)
			 }
			 Spacer()
			 Button{}label: {
				Image(systemName: "chevron.right")
				  .font(.subheadline)
				  .foregroundStyle(.primaryAction)
			 }
		  }
		  
		  //		  LIST
		  HStack{
			 ForEach(["onion", "olives"], id: \.self){item in
				Text(item.capitalized)
				  .font(.caption)
				  .padding(5)
				  .padding(.horizontal, 5)
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.white)
						.shadow(radius: 1)
				  )
				  .foregroundStyle(.primarytext)
			 }
		  }
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
	 }
	 .padding(12)
	 .background(
		RoundedRectangle(cornerRadius: 15)
		  .fill(.primaryAction.opacity(0.05))
		  .shadow(radius: 1)
	 )
  }
}

#Preview {
    FavoriteIngredientCard()
}
