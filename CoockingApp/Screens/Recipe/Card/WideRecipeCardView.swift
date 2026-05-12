//
//  WideRecipeCardView.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI
import Kingfisher

struct WideRecipeCardView: View {
  let recipe: UIRecipeModel
  let toggleFavorite: () -> ()
  @State private var expanded: Bool = false
  let isEditing: Bool
  @Binding var selectedForDelete: UIRecipeModel?
  var body: some View {
	 HStack(spacing: 0){
		Button{
		  withAnimation(.bouncy(duration: 0.8)){
			 expanded.toggle()
		  }
		}label:{
		  HStack{
			 VStack(alignment: .leading, spacing: 20){
				VStack(alignment: .leading){
				  Text(recipe.name)
					 .title(weight: .bold, color: Color.primarytext)
					 .font(.title2)
					 .lineLimit(expanded ? 4 : 2)
					 .multilineTextAlignment(.leading)
					 .fixedSize(horizontal: false, vertical: true)
				  if expanded{
					 Text(recipe.dateCreated.formatted(.dateTime.day().month().year()))
						.font(.footnote.weight(.light))
				  }
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				
				  HStack(spacing: 15){
					 statText(icon: "clock", value: "35 min")
						.foregroundStyle(Color.primarytext)
					 let difficulty = RecipeDifficulty.getDifficulty(recipe.difficulty)
					 statText(icon: "\(difficulty.icon).fill", value: difficulty.text)
						.foregroundStyle(difficulty.color)
				  }
				.font(.footnote)
				.fontDesign(.rounded)
				
				if expanded{
				  expandedSection
				}
			 }
			 .frame(maxWidth: .infinity)
			 Spacer()
				.frame(maxWidth: .infinity)
		  }
		  .padding()
		  .padding(.vertical)
		  .background(
			 ZStack{
				Rectangle()
				  .fill(
					 LinearGradient(colors: [Color.background, Color.background.opacity(0.9), .clear], startPoint: .topLeading, endPoint: .trailing)
				  )
				RoundedRectangle(cornerRadius: 20)
				  .stroke(Color.primaryAction.opacity(0.5), lineWidth: 1)
				  .shadow(radius: 1)
			 }
		  )
		  .background(
			 backImage
		  )
		  .overlay(alignment: .topTrailing) {
			 favoriteBtn
		  }
		  .clipShape(RoundedRectangle(cornerRadius: 20))
		  .contentShape(.rect)
		  .compositingGroup()
		  .shadow(radius: 3, y: 3)
		}
		.buttonStyle(.plain)
		
		if isEditing{
		  Button{
			 selectedForDelete = recipe
		  }label:{
			 Image(systemName: "trash.fill")
				.font(.title)
				.foregroundStyle(Color.background)
				.padding()
				.padding(.vertical)
		  }
		}
	 }
	 .background(
		RoundedRectangle(cornerRadius: 20)
		  .fill(Color.avoid)
	 )
	 .animation(.bouncy, value: isEditing)
	 
	 
  }
  
  
//  MARK: Background card
  private var backImage: some View{
	 HStack(alignment: .top){
		KFImage(URL(string: recipe.imageUrl))
		  .placeholder {
			 RoundedRectangle(cornerRadius: 0)
				.fill(Color.accentCard.opacity(0.15))
				.overlay {
				  ProgressView()
				}
		  }
		  .retry(maxCount: 2, interval: .seconds(1))
		  .cancelOnDisappear(true)
		  .fade(duration: 0.25)
		  .resizable()
		  .scaledToFill()
		  .clipped()
	 }
  }
  
//  MARK: Favorite Btn
  private var favoriteBtn: some View{
	 Button {
		withAnimation(){
		  toggleFavorite()
		}
	 } label: {
		Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
		  .font(.headline.weight(.semibold))
		  .foregroundStyle(recipe.isFavorite ? Color.avoid : Color.primarytext)
		  .padding(12)
		  .background(Circle().fill(Color.background.opacity(0.92)))
	 }
	 .padding(8)
  }
  
//  MARK: Section when view expanded
  private var expandedSection: some View{
	 HStack{
		Button{
		  NavigationManager.shared.secondaryScreens = .info(recipe: recipe)
		}label: {
		  Text("Detail")
			 .padding(12)
			 .padding(.horizontal)
			 .background(
				RoundedRectangle(cornerRadius: 25)
				  .fill(Color.primaryAction)
			 )
		}
		
		Button{
		  withAnimation(.bouncy){
			 expanded = false
		  }
		}label: {
		  Image(systemName: "xmark")
			 .padding(12)
			 .background(
				Circle()
				  .fill(Color.avoid)
			 )
		}
	 }
	 .section(color: Color.background)
  }
}

#Preview {
  WideRecipeCardView(recipe: .preview, toggleFavorite: {}, isEditing: false, selectedForDelete: .constant(nil))
}
