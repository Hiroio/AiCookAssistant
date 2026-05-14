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
				  segmentedPicker
			  HStack{
				 Image(systemName: "magnifyingglass")
					 let search = "\(ingredientsSearch ? "Ingredient" : "Name")"
					 TextField("", text: $searchText, prompt: Text("Search by \(search)").font(.footnote))
						.submitLabel(.search)
						.padding(.vertical, 12)
			  }
		  .padding(.horizontal)
		  .frame(maxWidth: .infinity)
		  .background(
			 RoundedRectangle(cornerRadius: 20)
				.fill(Color.background)
				.shadow(color:.black.opacity(0.105),radius: 1)
		  )
				}
				.animation(.bouncy, value: ingredientsSearch)
				.padding(5)
		    }
  
//  MARK: Segmented Picker for search options
  private var segmentedPicker: some View{
	 HStack(spacing: 0){
				Button{
				  ingredientsSearch = false
				}label: {
		  ZStack(alignment: .bottom){
			 if !ingredientsSearch{
				RoundedRectangle(cornerRadius: 15)
				  .fill(.primaryAction)
				  .frame(width: 35, height: 3)
				  .matchedGeometryEffect(id: "switch", in: nameSpace)
				  .padding(.horizontal, 0)
			 }
			 Text("Name")
				.foregroundStyle(.primaryAction)
				.font(.caption)
				.padding(.vertical, 15)
		  }
		  .contentShape(.rect)
		  .frame(maxWidth: .infinity)
		}.buttonStyle(.plain)
		
		
		Rectangle()
		  .fill(Color.rareCard)
		  .frame(width: 0.5, height: 15)
				Button{
				  ingredientsSearch = true
				}label: {
		  ZStack(alignment: .bottom){
			 if ingredientsSearch{
				RoundedRectangle(cornerRadius: 15)
				  .fill(.primaryAction)
				  .frame(height: 3)
				  .matchedGeometryEffect(id: "switch", in: nameSpace)
				  .padding(.horizontal, 20)
			 }
			 Text("Ingredient")
				.foregroundStyle(.primaryAction)
				.font(.caption)
				.padding(.vertical, 15)
		  }
		  .frame(maxWidth: .infinity)
		  .contentShape(.rect)
		  
		}.buttonStyle(.plain)
		
	 }
	 .font(.footnote)
	 .fontWeight(.semibold)
	 .background(
		ZStack{
		  RoundedRectangle(cornerRadius: 20)
			 .fill(Color.background)
			 .shadow(color:.black.opacity(0.105),radius: 1)
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.rareCard.opacity(0.1))
		}
	 )
	 .compositingGroup()
  }
}

#Preview {
  @Previewable @State var test: Bool = false
  SearchBarList(ingredientsSearch: $test, searchText: .constant(""))
}
