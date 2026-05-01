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
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.background(
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.herbalGreen.opacity(0.2))
		)
	 }
	 
	 .padding(.horizontal, 15)
	 
	 
	 
  }
}



#Preview {
  ZStack{
	 Color.softIvory.ignoresSafeArea()
	 RecipeInfo()
		.environmentObject(RecipeInfoViewModel(recipe: UIRecipeModel(name: "Creamy Herb Chicken with Potato",time: "35", difficulty: 2, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", ingredients: ["asdasd", "dqwd", "qwdqwd", "qdwqd", "qwdqwd"], instructions: [], imageUrl: "https://images.pexels.com/photos/34326260/pexels-photo-34326260.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200", chatHistory: [])))
  }
}


@ViewBuilder
func statText(icon: String, value: String) -> some View{
  HStack{
	 Image(systemName: icon)
	 Text(value)
  }
}
