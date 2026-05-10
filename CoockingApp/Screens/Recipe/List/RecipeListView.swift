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
		  Color.background.ignoresSafeArea()
		  VStack(spacing: 20){
			 header
			 
			 SearchBarList(ingredientsSearch: $vm.searchType, searchText: $vm.searchText)
			 
			 if vm.filteredRecipes.isEmpty{
				VStack(spacing: 15){
				  Image("NoRecipe")
					 .resizable()
					 .scaledToFit()
				  Text(vm.recipes.isEmpty ? "No Recipe Found" : "Nothing Found")
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
						WideRecipeCardView(recipe: recipe, toggleFavorite: {vm.toggleFavorite(recipe.id)}, isEditing: vm.isEditing)
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
		
		VStack(alignment: .trailing, spacing: 5){
		  HStack{
			 Button{
				vm.isEditing.toggle()
			 }label:{
				Image(systemName: "trash")
				  .font(.title3)
				  .foregroundStyle(vm.isEditing ? Color.background : Color.primaryAction)
				  .padding(8)
				  .background(
					 Circle()
						.fill(vm.isEditing ? Color.avoid : .secondaryCard)
				  )
			 }
			 Button{
				NavigationManager.shared.secondaryScreens = .creation
			 }label:{
				Image(systemName: "plus")
				  .font(.title3)
				  .foregroundStyle(.primaryAction)
				  .padding(8)
				  .background(
					 Circle()
						.fill(.secondaryCard)
				  )
			 }
		  }
		  Picker(selection: $vm.filter) {
			 ForEach(FilterRecipeEnum.allCases){item in
				HStack{
				  Text(item.text)
				  Image(systemName: item.icon)
				}
				.tag(item)
			 }
		  } label: {
			 Text("Filter")
		  }currentValueLabel: {
			 HStack(){
				Text(vm.filter.text)
				Image(systemName: vm.filter.icon)
			 }
		  }
		  .pickerStyle(.menu)
		  .foregroundStyle(.primaryAction)
		  .tint(.primaryAction)
		  .background(
			 RoundedRectangle(cornerRadius: 15)
				.fill(.secondaryCard)
		  )

		}
	 }
  }
}

#Preview {
    RecipeListView()
}
