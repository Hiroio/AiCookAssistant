//
//  RecipeInfoNavigation.swift
//  CoockingApp
//
//  Created by user on 30.04.2026.
//

import SwiftUI

struct RecipeInfoNavigation: View {
  @Namespace var nameSpace
  @StateObject private var vm: RecipeInfoViewModel
  init(recipe: UIRecipeModel) {
	 self._vm = StateObject(wrappedValue: RecipeInfoViewModel(recipe: recipe))
  }
    var body: some View {
		ZStack{
		  Color.softIvory.ignoresSafeArea()
		  VStack{
			 topBar
			 
			 TabView(selection: $vm.screenState){
				RecipeInfo()
				  .tag(InfoScreenEnum.info)
				
				InstructionView(instructions: vm.recipe.instructions)
				  .tag(InfoScreenEnum.instructions)
				
				AssistanceView()
				  .tag(InfoScreenEnum.aiassistance)
			 }
			 .tabViewStyle(.page)
			 .environmentObject(vm)
		  }
		}
    }
  
  
  
  var topBar: some View {
	 HStack {
		ForEach(InfoScreenEnum.allCases){ item in
		  let active = vm.screenState == item
		  Button{
			 withAnimation(.bouncy){
				vm.screenState = item
			 }
		  }label: {
			 ZStack(alignment: .bottom){
				Text(item.text)
				  .foregroundStyle(active ? .mossGreen : .charcoal)
				  .padding(.vertical)
				  .shadow(color: .mossGreen, radius: active ? 1 : 0)
				if active{
				  Rectangle()
					 .fill(.mossGreen)
					 .matchedGeometryEffect(id: "active", in: nameSpace)
					 .frame(height: 3)
					 .padding(.horizontal)
				}
			 }
			 .frame(maxWidth: .infinity)
			 }
		  
		}
	 }
	 .background(
		VStack(){
		  Spacer()
		  Rectangle()
			 .frame(height: 0.5)
			 .opacity(0.4)
		}
	 )
	 .animation(.bouncy, value: vm.screenState)
  }
}

#Preview {
  RecipeInfoNavigation(recipe: UIRecipeModel(name: "Creamy Herb Chicken with Potato",time: "35", difficulty: 2, description: "A cozy and flavorful one-pan dish with tender chicken, golden potatoes, and aromatic herbs in a creamy sauce", ingredients: [], instructions: [], imageUrl: "Creamy Chicken Potato", chatHistory: []))
}
