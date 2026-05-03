//
//  RecipeListView.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct RecipeListView: View {
  @State private var recipesManager = RecipesManager.shared
    var body: some View {
		ZStack{
		  Color.softIvory.ignoresSafeArea()
		  ScrollView{
			 LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
				ForEach(recipesManager.recipes, id: \.name){recipe in
				  RecipeCardView(recipe: recipe)
					 .frame(height: 105)
				}
			 }
			 .padding()
		  }
		}
    }
}

#Preview {
    RecipeListView()
}
