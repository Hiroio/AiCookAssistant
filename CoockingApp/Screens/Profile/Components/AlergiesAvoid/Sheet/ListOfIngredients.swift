//
//  ListOfIngredients.swift
//  CoockingApp
//
//  Created by user on 05.05.2026.
//

import SwiftUI

struct ListOfIngredients: View {
  let current: Bool
  let array: [String]
  let add: (String) -> ()
  var body: some View {
		 ScrollView(.horizontal){
		LazyHGrid(rows: [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)], spacing: 15) {
		  ForEach(array, id: \.self){item in
			 Button{
				add(item)
			 }label: {
				HStack{
				  Text(item)
				  if current{
					 Image(systemName: "xmark")
				  }
				}
				.font(.footnote)
				.foregroundStyle(.primarytext)
				.padding(8)
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(Color.background)
					 .shadow(radius: 1)
				)
			 }
		  }
		}
		 }
		 .scrollIndicators(.hidden)
		 .frame(height: 85)
  }
}

#Preview {
  ListOfIngredients(current: true,array: []){a in }
}
