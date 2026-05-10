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
		  Color.background.ignoresSafeArea()
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
		.sheet(isPresented: $vm.shareIsPresented) {
		  if let image = vm.shareImage {
			 ActivityShareSheet(activityItems: [image])
		  }
		}
    }
  
  var header: some View{
	 HStack{
		Button{
		  NavigationManager.shared.secondaryScreens = nil
		}label: {
		  Image(systemName: "chevron.left")
		}
		Spacer()
		Button{
		  Task {
			 await vm.prepareShareImage()
		  }
		}label: {
		  if vm.shareIsLoading {
			 ProgressView()
				.tint(.primarytext)
		  } else {
			 Image(systemName: "square.and.arrow.up")
		  }
		}
		.disabled(vm.shareIsLoading)
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
					 .foregroundStyle(active ? Color.primaryAction : .primarytext)
					 .padding(.vertical)
				  if active{
					 Rectangle()
						.fill(.primaryAction)
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
