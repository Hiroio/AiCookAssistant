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
  init(recipe: UIRecipeModel, fromCreation: Bool = false) {
	 self._vm = StateObject(wrappedValue: RecipeInfoViewModel(recipe: recipe, fromCreation: fromCreation))
  }
    var body: some View {
		ZStack{
		  Color.softIvory.ignoresSafeArea()
		  VStack{
			 header
			 topBar
			 
			 TabView(selection: $vm.screenState){
				RecipeInfo()
				  .tag(InfoScreenEnum.info)
				
				InstructionView(instructions: vm.recipe.instructions)
				  .tag(InfoScreenEnum.instructions)
				
				if vm.cooking{
				  AssistanceView()
					 .tag(InfoScreenEnum.aiassistance)
				}
			 }
			 .tabViewStyle(.page(indexDisplayMode: .never))
		  }
		}
		.environmentObject(vm)
    }
  
  var header: some View{
	 HStack{
		Button{
		  NavigationManager.shared.secondaryScreens = nil
		}label: {
		  Image(systemName: "chevron.left")
		}
		Spacer()
		Button{}label: {
		  Image(systemName: "square.and.arrow.up")
		}
	 }
	 .font(.headline)
	 .fontWeight(.light)
	 .foregroundStyle(.primarytext)
	 .padding(.horizontal)
  }
  
  var topBar: some View {
	 HStack {
		ForEach(InfoScreenEnum.allCases){ item in
		  if item != .aiassistance && !vm.cooking{
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
  RecipeInfoNavigation(recipe: .preview)
}
