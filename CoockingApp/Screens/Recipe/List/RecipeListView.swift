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
				  Text("No Recipe Found")
				  Image(systemName: "leaf")
				}
				.font(.title)
				.fontDesign(.serif)
				.fontWeight(.semibold)
				.foregroundStyle(.herbalGreen)
				.frame(maxHeight: .infinity)
			 }else{
				ScrollView{
				  LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 100, maximum: 250), spacing: 14), count: 2), spacing: 16) {
					 ForEach(vm.recipes, id: \.name){recipe in
						  RecipeCardView(recipe: recipe)
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
			 .font(.title.bold())
		  Text("\(vm.recipes.count) recipes saved")
			 .font(.footnote)
			 .opacity(0.8)
		}
		.fontDesign(.serif)
		Spacer()
		
		HStack{
		  Button{}label:{
			 Image(systemName: "pencil")
				.font(.headline)
				.foregroundStyle(.mossGreen)
				.padding(8)
				.background(
				  Circle()
					 .fill(.sageMist)
				)
		  }
		  Button{}label:{
			 Image(systemName: "plus.circle")
				.font(.headline)
				.foregroundStyle(.mossGreen)
				.padding(8)
				.background(
				  Circle()
					 .fill(.sageMist)
				)
		  }
		}
	 }
  }
}

#Preview {
    RecipeListView()
}
