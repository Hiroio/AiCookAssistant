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
	 ScrollView(showsIndicators: false){
		VStack(spacing: 15){
		  BigRecipeCardView(recipe: vm.recipe)
		  
		  IngredientsCard(ingredients: vm.recipe.ingredients, macros: vm.recipe.macros)
		  
		  HStack{
			 Image("chefsHat")
				.resizable()
				.scaledToFit()
				.frame(width: 45)
			 VStack(alignment: .leading){
				Text("Chef's Tip")
				  .font(.subheadline)
				  .foregroundStyle(.secondaryGeneral)
				  .fontWeight(.medium)
				Text(vm.recipe.cookingTip)
				  .font(.caption)
				  .opacity(0.6)
			 }
			 .frame(maxWidth: .infinity, alignment: .leading)
		  }
		  .padding(12)
		  .background(
			 RoundedRectangle(cornerRadius: 20)
				.fill(.warmBeige.opacity(0.4))
		  )
		  
		  
		}
		.padding(.horizontal, 15)
	 }
	 .safeAreaInset(edge: .bottom){
		if !vm.cooking{
		  bottomBar
		}
	 }
	 
	 
  }
  
  
  //  MARK: Bottom Btns
  private var bottomBar: some View {
	 HStack{
		Button{
		  NavigationManager.shared.secondaryScreens = nil
		}label: {
		  Image(systemName: "xmark")
			 .foregroundStyle(.softIvory)
			 .padding()
			 .background(
				RoundedRectangle(cornerRadius: 25)
				  .fill(.avoid)
				  .shadow(radius: 2, y: 1)
			 )
		}
		if !vm.saved{
		  Button{
			 vm.save()
		  }label: {
			 Text("Save")
				.foregroundStyle(.primaryAction)
				.padding()
				.padding(.horizontal)
				.background(
				  ZStack{
					 RoundedRectangle(cornerRadius: 25)
						.fill(Color.background)
						.shadow(color: .black.opacity(0.155),radius: 5, y: 2)
					 RoundedRectangle(cornerRadius: 25)
						.fill(.accentCard.opacity(0.7))
				  }
				)
		  }
		}
		Button{
		  withAnimation(){
			 vm.screenState = .instructions
			 vm.cooking = true
		  }
		}label: {
		  Text("Start Cooking")
			 .foregroundStyle(Color.background)
			 .padding()
			 .font(.subheadline)
			 .frame(maxWidth: .infinity)
			 .background(
				RoundedRectangle(cornerRadius: 25)
				  .fill(.primaryAction)
				  .shadow(radius: 3, y: 2)
			 )
		}
		
	 }
	 .frame(maxWidth: .infinity, alignment: .leading)
	 .padding(.horizontal)
  }
}


#Preview {
  ZStack{
	 Color.softIvory.ignoresSafeArea()
	 RecipeInfo()
		.environmentObject(RecipeInfoViewModel(recipe: .preview))
  }
}


@ViewBuilder
func statText(icon: String, value: String) -> some View{
  HStack{
	 Image(systemName: icon)
	 Text(value)
  }
}



