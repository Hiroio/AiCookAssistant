//
//  IngredientsSectionView.swift
//  CoockingApp
//
//  Created by user on 09.05.2026.
//

import SwiftUI

struct IngredientsSectionView: View {
  @StateObject private var vm = IngredientsViewModel()
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
		}
		.animation(.bouncy(duration: 0.6), value: vm.selection)
	 }
  }

  private var header: some View{
	 HStack{
		Text("DeliNote")
		  .font(.title)
		  .title(weight: .semibold)
		  .frame(maxWidth: .infinity, alignment: .leading)
	 }
  }
  
  private var selection: some View{
	 HStack{
		if !vm.selection{
		  Button{
				vm.selection = true
		  }label: {
			 Text("Start selection")
				.font(.headline.weight(.light))
				.foregroundStyle(.softIvory)
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
			 .cornerRadius(20)
			 .compositingGroup()
			 .shadow(radius: 1)
			 //		  Delete
			 Button{}label: {
				Image(systemName: "trash.fill")
				  .foregroundStyle(Color.background)
				  .padding(15)
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.avoid)
				  )
			 }
			 //		  Generate
			 Button{}label: {
				Image(systemName: "bubbles.and.sparkles.fill")
				  .foregroundStyle(Color.background)
				  .padding(15)
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.accentCard)
				  )
			 }
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
