//
//  FavoriteIngredientCard.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct FavoriteIngredientCard: View {
  let ingreedients: [String]
    var body: some View {
		VStack{
		  HStack{
			 Image(systemName: "leaf")
				.foregroundStyle(.sageMist)
				.padding()
				.background(
				  Circle()
					 .fill(.mossGreen)
				)
			 VStack(alignment: .leading){
				Text("Favorites Ingredients")
				  .font(.headline)
				Text("The Ingredients you love")
				  .font(.subheadline)
			 }
			 .frame(maxWidth: .infinity, alignment: .leading)
			 
			 Button{}label: {
				Image(systemName: "chevron.right")
				  .foregroundStyle(.charcoal)
				  .padding()
				  .background(
					 Circle()
						.fill(.softIvory)
						.shadow(radius: 2)
				  )
			 }
		  }
		  if ingreedients.isEmpty{
			 Text("Your list is empty, create or add")
				.font(.caption)
				.padding(.vertical, 7)
				.foregroundStyle(.charcoal.opacity(0.6))
		  }else{
			 HStack{
				ForEach(ingreedients.prefix(3), id: \.self){item in
				  Text(item)
					 .padding(8)
					 .background(
						RoundedRectangle(cornerRadius: 20)
						  .fill(.softIvory)
						  .shadow(radius: 1)
					 )
				}
				if ingreedients.count > 3 {
				  Text("+\(ingreedients.count - 3) more")
					 .foregroundStyle(.softIvory)
					 .padding(8)
					 .background(
						RoundedRectangle(cornerRadius: 20)
						  .fill(.mossGreen)
						  .shadow(radius: 1)
					 )
				}
			 }
			 .font(.footnote)
		  }
		}
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(.sageMist)
		)
    }
}

#Preview {
    FavoriteIngredientCard(ingreedients: ["🥔Potato", "🥬Cabbage", "🍅Tomato", "🍚Rice", "🍗Chicken"])
}
