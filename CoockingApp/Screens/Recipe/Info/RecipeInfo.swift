//
//  RecipeInfo.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI

struct RecipeInfo: View {
  @StateObject private var vm: RecipeInfoViewModel
  
  init(recipe: RecipeModel) {
	 self._vm = StateObject(wrappedValue: RecipeInfoViewModel(recipe: recipe))
  }
  var body: some View {
	 VStack{
		Text(vm.recipe.name)
		  .titleStyle()
		HStack{
		  ForEach(1..<6){i in
			 Image(systemName: "star.fill")
				.foregroundStyle(i <= vm.recipe.difficulty ? .yellow : .gray)
		  }
		}
		
		Text(vm.recipe.description)
		  .multilineTextAlignment(.center)
		
		VStack{
		  ForEach(vm.recipe.ingredients, id: \.self){ingreedient in
			 Text(ingreedient)
		  }
		}
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.secondory2)
		)
		
		ScrollView{
		  VStack(spacing: 15){
			 ForEach(vm.recipe.instructions, id: \.self){inst in
				Text("-" + inst.trimmingCharacters(in: .whitespacesAndNewlines))
				  .frame(maxWidth: .infinity, alignment: .leading)
				  .multilineTextAlignment(.leading)
			 }
		  }
		  .padding()
		  .background(
			 RoundedRectangle(cornerRadius: 20)
				.fill(.secondory2)
		  )
		}
		
		
	 }
	 .foregroundStyle(.general)
  }
}



#Preview {
  RecipeInfo(recipe: RecipeModel(name: "", difficulty: 2, description: "", ingredients: [], instructions: []))
}
