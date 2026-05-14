//
//  IngredientCardView.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import SwiftUI

struct IngredientCardView: View {
  let ingredient: IngredientModel
  let selected: Bool
  let selection: Bool
    var body: some View {
		ZStack{
		  Text(ingredient.name)
			 .font(.subheadline.weight(.black))
			 .foregroundStyle(.primaryAction)
			 .multilineTextAlignment(.center)
			 .minimumScaleFactor(0.7)
		}
		.padding()
		.padding(.vertical, 30)
		.frame(maxWidth: .infinity)
		.aspectRatio(2.5, contentMode: .fit)
		.background(
		  ZStack{
			 Color.rareCard.opacity(0.2)
			 Image("\(ingredient.category.background)")
				.resizable()
				.scaledToFit()
				.opacity(ingredient.category.opacity)
		  }
		)
		.overlay(alignment: .top){
		  HStack{
			 if selection{
				Image(systemName: selected ? "checkmark.circle.fill" : "circle")
				  .foregroundStyle(selected ? .accentCard : .primarytext)
			 }
			 Spacer()
			 
			 if !selection{
				Image(systemName: ingredient.isFavorite ? "heart.fill" : "heart")
				  .foregroundStyle(.accentCard)
			 }
		  }
		  .font(.title2)
		  .padding(10)
		  .animation(.easeInOut, value: selected)
		}
			.clipShape(.rect(cornerRadius: 20))
			.animation(.easeInOut, value: ingredient.isFavorite)
			.accessibilityElement(children: .ignore)
			.accessibilityLabel(Text(ingredient.name))
			.accessibilityValue(Text(selection ? (selected ? "Selected" : "Not selected") : (ingredient.isFavorite ? "Favorite" : "Not favorite")))
	    }
}

#Preview {
  IngredientCardView(ingredient: .other, selected: true, selection: false)
}
