//
//  SearchBarList.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI

struct SearchBarList: View {
  @Namespace var nameSpace
  @Binding var ingredientsSearch: Bool
  @Binding var searchText: String
    var body: some View {
		HStack{
		  HStack{
			 Button{
				ingredientsSearch = false
			 }label: {
				ZStack{
				  if !ingredientsSearch{
					 RoundedRectangle(cornerRadius: 15)
						.fill(.mossGreen)
						.frame(height: 40)
						.matchedGeometryEffect(id: "switch", in: nameSpace)
				  }
				  Text("Name")
					 .foregroundStyle(ingredientsSearch ? .charcoal : .softIvory)
				}
				.frame(maxWidth: .infinity)
				.contentShape(.rect)
			 }.buttonStyle(.plain)
			 
			 Button{
				ingredientsSearch = true
			 }label: {
				ZStack{
				  if ingredientsSearch{
					 RoundedRectangle(cornerRadius: 15)
						.fill(.mossGreen)
						.frame(height: 40)
						.matchedGeometryEffect(id: "switch", in: nameSpace)
				  }
				  Text("Ingredient")
					 .foregroundStyle(!ingredientsSearch ? .charcoal : .softIvory)
				}
				.frame(maxWidth: .infinity)
				.contentShape(.rect)
			 }.buttonStyle(.plain)
			 
		  }
		  .font(.footnote)
		  .fontWeight(.semibold)
		  .scaledToFit()
		  .padding(5)
		  .background(
			 RoundedRectangle(cornerRadius: 15)
				.fill(.sageMist)
		  )
		  HStack{
			 Image(systemName: "magnifyingglass")
			 let search = "\(ingredientsSearch ? "Ingredient" : "Name")"
			 TextField("", text: $searchText, prompt: Text("Search by \(search)"))
		  }
		  .frame(maxWidth: .infinity)
		}
		.animation(.bouncy, value: ingredientsSearch)
		.padding(5)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(.white)
			 .shadow(radius: 1)
		)
    }
}

#Preview {
  SearchBarList(ingredientsSearch: .constant(false), searchText: .constant(""))
}
