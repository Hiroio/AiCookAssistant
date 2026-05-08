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
				VStack(spacing: 0){
				  Image("CheffsyLogo")
					 .resizable()
					 .scaledToFit()
				  Text("No Recipe Found")
				}
				.shadow(radius: 2)
				.font(.title)
				.fontDesign(.serif)
				.fontWeight(.semibold)
				.foregroundStyle(.primaryAction)
				.frame(maxHeight: .infinity)
			 }else{
				ScrollView{
				  LazyVStack{
					 ForEach(vm.recipes){recipe in
						WideRecipeCardView(recipe: recipe)
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
