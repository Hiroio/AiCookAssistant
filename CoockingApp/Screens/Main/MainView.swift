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
		ScrollView(showsIndicators: false) {
		  VStack(alignment: .leading, spacing: 28){
			 header
			 recommendedSection
			 quickIdeasSection
			 latestRecipesSection
		  }
		  .padding(.horizontal, 20)
		  .padding(.top, 12)
		  .padding(.bottom, 36)
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
		  }
		  .padding(.horizontal, 20)
		  .padding(.top, 20)
		  ScrollView{
			 LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 12), count: 3), spacing: 18) {
				ForEach(IdeasEnum.allCases){idea in
				  IdeaCard(idea)
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
		  .frame(width: 50, height: 50)
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

  private var recommendedSection: some View {
	 VStack(alignment: .leading, spacing: 12) {
		sectionHeader("Recommended for you")
		if let error = vm.recomendedError{
		  VStack{
			 Image(error.icon)
				.resizable()
				.scaledToFit()
			 Text(error.title)
				.font(.headline.weight(.medium))
			 Text(error.message)
				.font(.caption)
			 Button{
				vm.recomendedLoading = true
				vm.recomendedError = nil
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
		  }
		  .frame(maxWidth: .infinity)
		  .padding()
		  .background(
			 RoundedRectangle(cornerRadius: 20)
				.fill(.rareCard.opacity(0.4))
		  )
		}else{
		  if vm.recomendedLoading{
			 LoadingCard()
				.frame(maxWidth: .infinity)
				.padding(50)
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.rareCard.opacity(0.4))
				)
		  }else{
			 BigRecipeCardView(recipe: .preview)
		  }
		}
	 }
	 .animation(.easeInOut, value: vm.recomendedLoading)
	 .animation(.easeInOut, value: vm.recommendedRecipe != nil)
	 .animation(.easeInOut, value: vm.recomendedError)
	 .frame(height: 245)
  }

  private var quickIdeasSection: some View {
	 VStack(alignment: .leading, spacing: 14) {
		HStack {
		  sectionHeader("Quick Ideas")
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

		IdeasView()
	 }
  }

  private var latestRecipesSection: some View {
	 VStack(alignment: .leading, spacing: 14) {
		sectionHeader("Latest Recipes")
		ScrollView(.horizontal, showsIndicators: false) {
		  LazyHStack(spacing: 14) {
			 ForEach(vm.latestRecipes){item in
				MiniRecipeCardView(recipe: item)
				
			 }
		  }
		  .padding(.vertical, 4)
		  .padding(.trailing, 20)
		}
		.contentMargins(.horizontal, 0, for: .scrollContent)
	 }
  }

  private func sectionHeader(_ title: String) -> some View {
	 Text(title)
		.section(weight: .semibold, color: Color.primarytext)
  }
}

#Preview {
  MainView()
}
