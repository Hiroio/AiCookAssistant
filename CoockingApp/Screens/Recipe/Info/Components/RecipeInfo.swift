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
		ZStack{
		  VStack(alignment: .leading, spacing: 20){
			 Text(vm.recipe.name)
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
			 
			 Text(vm.recipe.description)
		
		  }
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
			 if let url = URL(string: "https://images.pexels.com/photos/34326260/pexels-photo-34326260.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200"){
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
		
		
		Spacer()
		
		VStack(alignment: .leading){
		  Text("Ingredients")
			 .frame(maxWidth: .infinity, alignment: .leading)
			 .headline()
		  VStack{
			 ForEach(vm.recipe.ingredients, id: \.self){ item in
				HStack{
				  Image(systemName: "circle.fill")
				  Text(item)
				}
				.foregroundStyle(.charcoal)
				.fontDesign(.rounded)
			 }
		  }
		  .frame(maxHeight: .infinity)
		  
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
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
		.environmentObject(RecipeInfoViewModel(recipe: UIRecipeModel(name: "Creamy Herb Chicken with Potato",time: "35", difficulty: 2, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", ingredients: [], instructions: [], imageUrl: "Creamy Chicken Potato")))
  }
}


@ViewBuilder
func statText(icon: String, value: String) -> some View{
  HStack{
	 Image(systemName: icon)
	 Text(value)
  }
}
