//
//  RecipeListView.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct RecipeListView: View {
  @StateObject private var vm = RecipeListViewModel()
    var body: some View {
		ZStack{
		  Color.softIvory.ignoresSafeArea()
		  VStack(spacing: 20){
			 header
			 
			 SearchBarList(ingredientsSearch: $vm.searchType, searchText: $vm.searchText)
			 
			 if vm.recipes.isEmpty{
				VStack(spacing: 15){
				  Image("NoRecipe")
					 .resizable()
					 .scaledToFit()
				  Text("No Recipe Found")
					 .font(.title)
					 .fontDesign(.rounded)
					 .fontWeight(.light)
					 .foregroundStyle(.primaryAction)
				  
				  Button{}label: {
					 Text("Ready to create?")
						.font(.headline.weight(.semibold))
						.fontDesign(.rounded)
						.foregroundStyle(Color.background)
						.padding()
						.background(
						  RoundedRectangle(cornerRadius: 20)
							 .fill(Color.primaryAction.opacity(0.7))
						)
				  }
				}
				
				.frame(maxHeight: .infinity)
				
			 }else{
				ScrollView{
				  LazyVStack{
					 ForEach(vm.filteredRecipes){recipe in
						WideRecipeCardView(recipe: recipe, toggleFavorite: {vm.toggleFavorite(recipe.id)})
					 }
				  }
				}
			 }
		  }.padding()
		}
    }
  
  private var header: some View{
	 HStack{
		VStack(alignment: .leading){
		  Text("Recipes")
			 .font(.title)
			 .title(weight: .semibold)
		  Text("\(vm.recipes.count) Recipes saved")
			 .font(.subheadline)
			 .fontDesign(.rounded)
			 .opacity(0.8)
		}
		Spacer()
		
		HStack{
		  Button{}label:{
			 Image(systemName: "pencil")
				.font(.title2)
				.foregroundStyle(.primarytext)
				.padding(8)
				.background(
				  Circle()
					 .fill(.secondaryCard)
				)
		  }
		  Button{}label:{
			 Image(systemName: "plus")
				.font(.title2)
				.foregroundStyle(.primarytext)
				.padding(8)
				.background(
				  Circle()
					 .fill(.secondaryCard)
				)
		  }
		}
	 }
  }
}

#Preview {
    RecipeListView()
}
