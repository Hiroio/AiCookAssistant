//
//  IngredientsGridView.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import SwiftUI

struct IngredientsGridView: View {
  @EnvironmentObject var vm: IngredientsViewModel
  let ingredients: [IngredientModel]
    var body: some View {
		ScrollView{
		  if ingredients.isEmpty{
			 VStack{
				Image("noIngredient")
				  .resizable()
				  .scaledToFit()
				  .padding(50)
				Text("Whoops there's nothing here!")
				  .font(.title2.weight(.black))
				  .foregroundStyle(.accentCard)
				Text("Create some recipes to find new ingredients")
				  .font(.footnote.weight(.light))
				  .foregroundStyle(.primarytext.opacity(0.7))
			 }
			 .padding()
			 .multilineTextAlignment(.center)
		  }else{
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
				ForEach(ingredients){item in
				  Button{
					 if vm.selection{
						vm.selectIngredient(item)
					 }else{
						vm.toggleFavorite(item)
					 }
				  }label:{
					 IngredientCardView(ingredient: item, selected: vm.selectedIngredients.contains(where: {$0.id == item.id}), selection: vm.selection)
						.transition(.scale)
						.zIndex(1)
				  }
				}
				
			 }
			 .animation(.bouncy, value: ingredients.count)
		  }
		}
    }
}

#Preview {
    IngredientsGridView(ingredients: [])
	 .environmentObject(IngredientsViewModel())
}
