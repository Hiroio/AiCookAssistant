//
//  RecipeInfoNavigation.swift
//  CoockingApp
//
//  Created by user on 30.04.2026.
//

import SwiftUI

struct RecipeInfoNavigation: View {
  @EnvironmentObject private var storeManager: StoreManager
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
				
				  AssistanceView()
				  .allowsHitTesting(isAIAssistanceAvailable)
					 .blur(radius: isAIAssistanceAvailable ? 0 : 12)
					 .overlay(
						Group{
						  if !isAIAssistanceAvailable {
							 VStack{
								Text("Premium Access")
								  .font(.title.weight(.black))
								  .foregroundStyle(.primaryAction)
								Image("assist")
								  .resizable()
								  .scaledToFit()
								  .frame(width: 250, height: 250)
								Button{
								  storeManager.showingSheet = true
								}label: {
								  Text("Get Premium")
									 .font(.headline.weight(.black))
									 .foregroundStyle(Color.background)
									 .padding()
									 .background(
										RoundedRectangle(cornerRadius: 15)
										  .fill(.primaryAction)
									 )
								}
							 }
						  }
						}
					 )
					 .tag(InfoScreenEnum.aiassistance)
					 
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
				 .padding(10)
				 .background(
					Circle()
					  .fill(Color.rareCard.opacity(0.1))
					  .shadow(radius: 1)
				 )
			}
			.iconButtonAccessibility("Back", hint: "Closes recipe details")
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
			.iconButtonAccessibility("Share recipe", hint: "Creates and opens a share image")
		 }
	 .font(.headline)
	 .fontWeight(.light)
	 .foregroundStyle(.primarytext)
	 .padding(.horizontal)
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
				 .accessibilityLabel(Text(item.text))
				 .accessibilityAddTraits(active ? [.isButton, .isSelected] : .isButton)
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

  private var isAIAssistanceAvailable: Bool {
    AccessPolicy.canUse(.aiAssistance, isPremium: storeManager.hasFullAccess)
  }
}

#Preview {
  RecipeInfoNavigation(recipe: .preview)
	 .environmentObject(StoreManager.shared)
}
