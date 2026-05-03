//
//  RecipeInfo.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI

struct RecipeInfo: View {
  @EnvironmentObject private var vm: RecipeInfoViewModel
  var body: some View {
	 VStack{
		  
		DishCard(recipe: vm.recipe)
		
		Spacer()
		
		VStack(alignment: .leading, spacing: 25){
		  Text("Ingredients")
			 .frame(maxWidth: .infinity, alignment: .leading)
			 .font(.title3)
			 .headline()
		  VStack(alignment: .leading){
			 ForEach(vm.recipe.ingredients, id: \.self){ item in
				let items = item.components(separatedBy: "-").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
				HStack{
				  Image(systemName: "circle.fill")
					 .font(.caption2)
				  Text(items[0])
					 .font(.subheadline)
					 .multilineTextAlignment(.leading)
				  Spacer()
				  Text(items.last ?? "")
					 .font(.footnote)
				  
				}
				.foregroundStyle(.charcoal)
				.fontDesign(.rounded)
			 }
		  }
		  
		  
		}
		.padding()
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.background(
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.herbalGreen.opacity(0.2))
		)
		
		HStack{
		  Button{}label: {
			 Image(systemName: "xmark")
				.foregroundStyle(.softIvory)
				.padding()
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(
						.red.opacity(0.5)
					 )
				)
		  }
		  Button{
			 vm.save()
		  }label: {
			 Text("Save")
				.foregroundStyle(.softIvory)
				.padding()
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.herbalGreen.opacity(0.7))
				)
		  }
		  Button{}label: {
			 Text("Start Cooking")
				.foregroundStyle(.softIvory)
				.padding()
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.warmBeige.opacity(0.8))
				)
		  }
		}
	 }
	 
	 
	 .padding(.horizontal, 15)
	 
	 
	 
  }
}



#Preview {
  ZStack{
	 Color.softIvory.ignoresSafeArea()
	 RecipeInfo()
		.environmentObject(RecipeInfoViewModel(recipe: .preview))
  }
}


@ViewBuilder
func statText(icon: String, value: String) -> some View{
  HStack{
	 Image(systemName: icon)
	 Text(value)
  }
}
