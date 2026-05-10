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
		  LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
			 ForEach(ingredients){item in
				Button{
				  if vm.selection{
					 vm.selectIngredient(item)
				  }else{
//					 TODO: Toggle Favorite
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

#Preview {
    IngredientsGridView(ingredients: [])
	 .environmentObject(IngredientsViewModel())
}
