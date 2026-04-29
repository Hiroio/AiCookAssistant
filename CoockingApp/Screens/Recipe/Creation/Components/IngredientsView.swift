//
//  IngredientsView.swift
//  CoockingApp
//
//  Created by user on 29.04.2026.
//

import SwiftUI

struct IngredientsView: View {
  @State private var text: String = ""
  @Binding var selectedIngredient: [String]
  @Binding var showCamera: Bool
  var body: some View {
	 VStack(alignment: .leading){
		Text("Ingredients")
		  .headline()
		
		HStack(spacing: 2){
		  HStack{
			 TextField("", text: $text, prompt: Text("Potato Chicken Herbs"))
				.shadow(radius: 2)
				.padding()
			 HStack(spacing: 0){
				Button{
				  addIngredient(text: text)
				}label:{
				  Image(systemName: "plus")
					 .padding()
					 .fontWeight(.black)
					 .foregroundStyle(Color.background)
					 .background(
						RoundedRectangle(cornerRadius: 20)
						  .fill(.accent)
						  .shadow(radius: 2, x: -2, y: 1)
					 )
					 .padding(4)
				}
			 }
		  }
		  .background(
			 RoundedRectangle(cornerRadius: 25)
				.fill(.secondory2.opacity(0.35))
		  )
		  Button{
			 showCamera.toggle()
		  }label:{
			 Image(systemName: "camera")
				.padding()
				.fontWeight(.black)
				.foregroundStyle(Color.background)
				.background(
				  RoundedRectangle(cornerRadius: 22)
					 .fill(.accent)
				)
				.padding(4)
		  }
		}
		.shadow(radius: 2, y: 2)
		
		ScrollView(showsIndicators: false){
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), alignment: .leading) {
				ForEach(selectedIngredient, id: \.self){text in
				  Button{
					 selectedIngredient.removeAll(where: {$0.lowercased() == text.lowercased()})
				  }label: {
					 HStack{
						Text(text)
						Image(systemName: "xmark")
					 }
					 .fontWeight(.black)
					 .foregroundStyle(.general)
					 .padding(7)
					 .background(
						RoundedRectangle(cornerRadius: 15)
						  .fill(Color.card.opacity(0.7))
					 )
					 .contentShape(.rect)
				  }
				  .transition(.scale)
				  .allowsHitTesting(selectedIngredient.contains(where: {$0.lowercased() == text.lowercased()}))
				}
			 }
				.padding(.horizontal)
		}
		  .frame(maxWidth: .infinity)
	 }
	 .animation(.easeInOut, value: selectedIngredient)
  }
  
  func addIngredient(text: String){
	 if !selectedIngredient.contains(where: {$0.lowercased() == text.lowercased()}){
		selectedIngredient.insert(text.capitalized, at: 0)
	 }
	 self.text.removeAll()
  }
}

#Preview {
  ZStack{
	 Color.background
	 IngredientsView(selectedIngredient: .constant([]), showCamera: .constant(false))
  }
}
