//
//  MainView.swift
//  CoockingApp
//
//  Created by user on 02.05.2026.
//

import SwiftUI

struct MainView: View {
  @StateObject private var vm = MainViewModel()
  @State private var showAllIdeas: Bool = false
  var body: some View {
	 ZStack{
		Color.background.ignoresSafeArea()
		VStack{
			  header
				 .padding(.horizontal)
			  GeometryReader{ geo in
				 let metrics = MainViewMetrics(width: geo.size.width)
				 ScrollView {
					VStack(alignment: .leading, spacing: 10){
					  recommendedSection(cardHeight: metrics.recommendedCardHeight)
					  quickIdeasSection(ideaSpacing: metrics.ideaSpacing, ideaIconSize: metrics.ideaIconSize)
					  latestRecipesSection(cardWidth: metrics.lastRecipeSize)
					}
					.padding(.horizontal, 20)
					.padding(.top, 12)
					.padding(.bottom, 36)
			 }
			 .scrollIndicators(.hidden)
		  }
		}
	 }
	 .sheet(isPresented: $showAllIdeas) {
		VStack(spacing: 18){
		  HStack{
			 Text("Ideas")
				.font(.title2.bold())
				.foregroundStyle(Color.primaryAction)
			 
			 Button{
				showAllIdeas = false
			 }label: {
				Image(systemName: "xmark")
				  .font(.subheadline.weight(.semibold))
				  .foregroundStyle(Color.primaryAction)
				  .frame(width: 36, height: 36)
				  .background(
					 Circle()
						.fill(Color.secondaryCard)
				  )
				
				 }
				 .frame(maxWidth: .infinity, alignment: .trailing)
				 .iconButtonAccessibility("Close ideas")
			  }
		  .padding(.horizontal, 20)
		  .padding(.top, 20)
		  ScrollView{
			 LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 12)], spacing: 18) {
				ForEach(IdeasEnum.allCases){idea in
				  Button{
					 vm.generateQuickIdeaRecipe(prompt: idea.prompt)
					 showAllIdeas = false
				  }label: {
					 IdeaCard(idea)
				 }
				 .buttonStyle(.plain)
				 .accessibilityLabel(Text(idea.title))
				 .accessibilityHint(Text("Generates a quick recipe idea"))
				}
			 }
			 .padding(.horizontal, 20)
			 .padding(.bottom, 20)
		  }
		}
		.background(Color.background)
	 }
  }
  
  private var header: some View{
	 HStack{
		Image("CheffsyLogo")
		  .resizable()
		  .scaledToFit()
		  .frame(width: UIDevice.isIPad ? 100 : 50)
		VStack(alignment: .leading, spacing: 3){
		  Text("DeliNote")
			 .font(.title)
			 .title(weight: .semibold)
		  
		  
		  Text("What shall we cook today?")
			 .foregroundStyle(Color.primarytext.opacity(0.68))
			 .font(.subheadline)
			 .fontWeight(.regular)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
	 }
  }
  
  private func recommendedSection(cardHeight: CGFloat) -> some View {
	 VStack(alignment: .leading, spacing: 15) {
		Text("Recommended for you")
		  .section(weight: .semibold, color: Color.primarytext)
		VStack{
		  if let recipe = vm.recommendedRecipe{
			 Button{
				NavigationManager.shared.secondaryScreens = .info(recipe: recipe, creation: true)
			 }label: {
					BigRecipeCardView(recipe: recipe)
				 }
				 .buttonStyle(.plain)
				 .accessibilityHint(Text("Opens recommended recipe"))
			  }else{
			 if let error = vm.recomendedError{
				VStack{
					  Image(error.icon)
						 .resizable()
						 .scaledToFit()
						 .accessibilityHidden(true)
				  Text(error.title)
					 .font(.headline.weight(.medium))
				  Text(error.message)
					 .font(.caption)
				  Button{
					 vm.initializeRecomendedRecipe()
				  }label: {
					 HStack{
						Text("Try Again")
						Image(systemName: "repeat")
					 }
					 .font(.subheadline)
					 .foregroundStyle(Color.background)
					 .padding(12)
					 .background(
						RoundedRectangle(cornerRadius: 20)
						  .fill(.primaryAction)
					 )
			  }
				  .accessibilityLabel(Text("Try again"))
				}
				.frame(maxWidth: .infinity)
				.padding()
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.rareCard.opacity(0.4))
				)
			 }else{
				LoadingCard()
				  .frame(maxWidth: .infinity)
				  .padding(50)
				  .background(
					 RoundedRectangle(cornerRadius: 20)
						.fill(.rareCard.opacity(0.4))
				  )
				  }
				}
		}
		.animation(.easeInOut, value: vm.recomendedLoading)
		.animation(.easeInOut, value: vm.recommendedRecipe != nil)
		.animation(.easeInOut, value: vm.recomendedError)
		.frame(height: cardHeight)
			  }
			  .accessibilityLabel(Text("View all quick ideas"))
			}
  
  private func quickIdeasSection(ideaSpacing: CGFloat, ideaIconSize: CGFloat) -> some View {
	 VStack(alignment: .leading, spacing: 14) {
		HStack {
		  VStack(alignment: .leading, spacing: 0){
			 Text("Quick Ideas")
				.section(weight: .semibold, color: Color.primarytext)
			 if !StoreManager.shared.hasFullAccess{
				Text("Generation left: \(max(0, 3 - vm.user.freeIdeasUsed))")
				  .font(.caption2.weight(.light))
				  .opacity(0.6)
			 }
		  }
		  Spacer()
		  Button{
			 showAllIdeas.toggle()
		  }label: {
			 HStack(spacing: 4){
				Text("View all")
				Image(systemName: "chevron.right")
				  .font(.caption.weight(.semibold))
			 }
			 .font(.footnote.weight(.semibold))
			 .foregroundStyle(Color.primaryAction)
		  }
		}
		
		IdeasView(spacing: ideaSpacing, iconSize: ideaIconSize, createRecipe: { prompt in vm.generateQuickIdeaRecipe(prompt: prompt)})
	 }
	 .padding(.top)
  }
  
  private func latestRecipesSection(cardWidth: CGFloat) -> some View {
	 VStack(alignment: .leading, spacing: 14) {
		Text("Latest Recipes")
		  .section(weight: .semibold, color: Color.primarytext)
		ScrollView(.horizontal) {
		  LazyHStack(spacing: 14) {
				Button{
				  NavigationManager.shared.secondaryScreens = .creation()
				}label:{
				  VStack{
					 Image(systemName: "plus")
						.foregroundStyle(.primaryAction)
						.font(.title.weight(.semibold))
						.fontDesign(.rounded)
						.padding()
					 Text("Create")
						.font(.caption.weight(.light))
						.foregroundStyle(.primaryAction)
						.fontDesign(.rounded)
				  }
				  .frame(width: cardWidth, height: cardWidth)
				  .padding()
				  .background(
					 ZStack{
						Color.background
						Color.rareCard.opacity(0.1)
					 }
				  )
				  .clipShape(
					 UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0, bottomLeading: 15, bottomTrailing: 15, topTrailing: 0))
				  )
				  .padding(.top, 10)
				  .overlay(alignment: .top) {
					 Image("pin")
						.resizable()
						.scaledToFit()
						.frame(height: 24)
						.blur(radius: 0.5)
				  }
				  .compositingGroup()
				  .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
					}
					.buttonStyle(.plain)
					.accessibilityLabel(Text("Create recipe"))
					.accessibilityHint(Text("Opens recipe creation"))
					ForEach(vm.latestRecipes.prefix(4)){item in
				  Button{
					 NavigationManager.shared.secondaryScreens = .info(recipe: item, creation: false)
				  }label: {
					 MiniRecipeCardView(recipe: item)
						.frame(width: cardWidth, height: cardWidth)
						.latestCard()
				  }
				  .buttonStyle(.plain)
				}
		  }
		  .padding(.vertical, 4)
		  .padding(.trailing, 20)
		}
		.scrollIndicators(.hidden)
		.contentMargins(.horizontal, 0, for: .scrollContent)
	 }
  }
  
}

private struct MainViewMetrics {
  let width: CGFloat
  
  var contentWidth: CGFloat {
	 max(0, width - 40)
  }
  var recommendedCardHeight: CGFloat {
	 min(max(contentWidth * 0.40, 250), 350)
  }
  
  var ideaSpacing: CGFloat {
	 min(max(contentWidth * 0.014, 8), 14)
  }
  
  var ideaIconSize: CGFloat {
	 min(max(contentWidth * 0.05, 34), 46)
  }
  
  var lastRecipeSize: CGFloat{
	 min(max(contentWidth * 0.2, 80), 150)
  }
}

#Preview {
  MainView()
}
