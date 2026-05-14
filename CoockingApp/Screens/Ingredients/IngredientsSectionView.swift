//
//  IngredientsSectionView.swift
//  CoockingApp
//
//  Created by user on 09.05.2026.
//

import SwiftUI

struct IngredientsSectionView: View {
  @StateObject private var vm = IngredientsViewModel()
  @State private var deletePopUp: Bool = false
  var body: some View {
	 ZStack{
		Color.background.ignoresSafeArea()
		VStack{
		  header
		  
		  VStack{
//			 Section bar
			 IngredientSectionBar(currentSection: $vm.category)
//			 Grid
			 IngredientsGridView(ingredients: vm.categorizedIngredients)
				.environmentObject(vm)
			 
		  }
		  .animation(.bouncy, value: vm.category)
		  
		}
		.padding()
		.safeAreaInset(edge: .bottom) {
		  selection
			 .padding(.bottom)
		}
		.animation(.bouncy(duration: 0.6), value: vm.selection)
		
			if deletePopUp{
			  ZStack{
				 Color.black.opacity(0.2)
					.ignoresSafeArea()
					.onTapGesture {
					  withAnimation(.easeInOut(duration: 0.2)) {
						 deletePopUp = false
					  }
					}
				 
				 DeletePopUpConfirmation(
				  cancel: {
					 withAnimation(.easeInOut(duration: 0.2)) {
						deletePopUp = false
					 }
				  },
				  confirm: {
					 vm.deleteSelected()
					 withAnimation(.easeInOut(duration: 0.2)) {
						deletePopUp = false
					 }
				  }
				 )
				 .transition(.opacity.combined(with: .scale(scale: 0.96)))
			  }
			  .zIndex(2)
			  .allowsHitTesting(deletePopUp)
			}
	 }
  }

  private var header: some View{
	 HStack{
		Text("Ingredients")
		  .font(.title)
		  .title(weight: .semibold)
		  .frame(maxWidth: .infinity, alignment: .leading)
	 }
  }
  
  private var selection: some View{
	 HStack{
		if !vm.selection{
		  Button{
			 if vm.ingredients.isEmpty{
				NavigationManager.shared.secondaryScreens = .creation()
			 }else{
				vm.selection = true
			 }
		  }label: {
			 Text("Start \(vm.ingredients.isEmpty ? "Creation" : "Selection")")
				.font(.headline.weight(.light))
				.foregroundStyle(Color.background)
				.padding(15)
				.padding(.horizontal)
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.accentCard)
					 .shadow(radius: 3, y: 1)
				)
		  }
		  .transition(.move(edge: .trailing).combined(with: .opacity))
		}else{
		  HStack{
			 Button{
				vm.selection = false
			 }label:{
				Image(systemName: "xmark")
				  .foregroundStyle(Color.background)
				  .padding(15)
				  .background(
					 RoundedRectangle(cornerRadius: 20)
						.fill(.avoid)
				  )
			 }
			 .iconButtonAccessibility("Cancel selection")
			 ScrollView(.horizontal){
				HStack{
				  ForEach(vm.selectedIngredients){item in
					 Image(item.category.icon)
						.resizable()
						.scaledToFit()
				  }
				}
				.padding(5)
				.frame(maxHeight: .infinity)
			 }
			 .padding(5)
				 .background(
					Color.secondaryCard
				 )
				 .clipShape(.rect(cornerRadius: 20))
				 .compositingGroup()
					 .shadow(radius: 1)
			 
			 let active = !vm.selectedIngredients.isEmpty
				 //		  Delete
				 Button{
					if active{
					  withAnimation(.easeInOut(duration: 0.2)) {
						 deletePopUp = true
					  }
					}
				 }label: {
					Image(systemName: "trash.fill")
				  .foregroundStyle(Color.background)
				  .padding(15)
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.avoid)
				  )
				 }
				 .iconButtonAccessibility("Delete selected ingredients", hint: "Shows delete confirmation")
					 .opacity(active ? 1 : 0.6)
			 //		  Generate
			 Button{
				NavigationManager.shared.secondaryScreens = .creation(ingredients: vm.selectedIngredients.map({$0.name}))
			 }label: {
				Image(systemName: "bubbles.and.sparkles.fill")
				  .foregroundStyle(Color.background)
				  .padding(15)
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.accentCard)
				  )
			 }
			 .iconButtonAccessibility("Generate recipe", hint: "Creates a recipe from selected ingredients")
		  }
		  .transition(.move(edge: .leading).combined(with: .opacity))
		}
	 }
	 .padding(.horizontal, 15)
	 .frame(height: 55)
  }
}


#Preview {
  IngredientsSectionView()
}
