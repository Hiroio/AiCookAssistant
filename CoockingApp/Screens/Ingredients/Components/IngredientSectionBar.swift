//
//  IngredientSectionBar.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import SwiftUI

struct IngredientSectionBar: View {
  @Namespace var nameSpace
  @Binding var currentSection: CategoriesEnum
    var body: some View {
		HStack(spacing: 15){
		  Button{
			 currentSection = .favorite
		  }label: {
			 Image(systemName: currentSection == .favorite ? "heart.fill" : "heart")
				.foregroundStyle(.primaryAction)
				.padding(.leading)
		  }
		  ScrollView(.horizontal){
			 HStack(spacing: 10){
				ForEach(CategoriesEnum.allCases){section in
				  let active = currentSection == section
				  if section != .favorite{
					 Button{
						currentSection = section
					 }label:{
						VStack{
						  ZStack(alignment: .bottom){
							 Text(section.rawValue.capitalized)
								.foregroundStyle(active ? .primaryAction : Color.primarytext )
								.padding(.vertical, 12)
//							 if active{
//								Rectangle()
//								  .fill(.primaryAction)
//								  .frame(height: 3)
//								  .matchedGeometryEffect(id: "Category", in: nameSpace)
//							 }
						  }
						}
						.padding(.horizontal, 15)
						.background(
						  RoundedRectangle(cornerRadius: 20)
							 .fill(Color.accentCard.opacity(active ? 0.7 : 0.3))
						)
					 }
				  }
				}
			  }
			  .scrollIndicators(.hidden)
			}
		}
		.padding(5)
		.background(
			 Color.secondaryCard
				.opacity(0.3)
		)
			.clipShape(.rect(cornerRadius: 15))
	    }
}

#Preview {
  IngredientSectionBar(currentSection: .constant(.dairy))
}
