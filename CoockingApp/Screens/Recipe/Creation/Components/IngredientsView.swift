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
				.foregroundStyle(Color.primaryAction)
				.padding()
			 HStack(spacing: 0){
				Button{
				  addIngredient(text: text)
				}label:{
				  Image(systemName: "plus")
					 .padding()
					 .foregroundStyle(Color.background)
					 .background(
						RoundedRectangle(cornerRadius: 22)
						  .fill(Color.accentCard)
						  .shadow(radius: 2, x: -2, y: 1)
					 )
					 .padding(4)
				}
			 }
		  }
		  .background(
			 ZStack{
				RoundedRectangle(cornerRadius: 25)
				  .fill(Color.secondaryCard.shadow(.inner(radius: 1)))
			 }
		  )
		  Button{
			 showCamera.toggle()
		  }label:{
			 Image(systemName: "camera")
				.padding()
				.foregroundStyle(Color.background)
				.background(
				  RoundedRectangle(cornerRadius: 22)
					 .fill(Color.accentCard)
				)
				.padding(4)
		  }
		}
		Text("To add multiple items, separate them with a comma")
		  .font(.caption2)
		  .foregroundStyle(Color.primarytext.opacity(0.6))
		  .padding(.horizontal, 20)
		
		ScrollView(showsIndicators: false){
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
				ForEach(selectedIngredient, id: \.self){text in
				  Button{
					 selectedIngredient.removeAll(where: {$0.lowercased() == text.lowercased()})
				  }label: {
					 HStack{
						Text(text)
						  .frame(maxWidth: .infinity, alignment: .leading)
						Image(systemName: "xmark")
					 }
					 .font(.footnote)
					 .foregroundStyle(Color.primarytext.opacity(0.8))
					 .frame(maxWidth: .infinity)
					 .padding(10)
					 .background(
						RoundedRectangle(cornerRadius: 15)
						  .fill(Color.secondaryCard.shadow(.inner(radius: 1)).opacity(0.5))
					 )
					 .contentShape(.rect)
				  }
				  .transition(.scale)
				  .allowsHitTesting(selectedIngredient.contains(where: {$0.lowercased() == text.lowercased()}))
				}
			 }
				.padding(.horizontal)
				.frame(maxWidth: .infinity)
		}
		  
	 }
	 .animation(.easeInOut, value: selectedIngredient)
  }
  
  func addIngredient(text: String){
	 if !selectedIngredient.contains(where: {$0.lowercased() == text.lowercased()}){
		if text.contains(","){
		  let multipleText = text.components(separatedBy: ",").map({$0.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)})
		  selectedIngredient.insert(contentsOf: multipleText, at: 0)
		}else{
		  selectedIngredient.insert(text.capitalized, at: 0)
		}
	 }
	 self.text.removeAll()
  }
}

#Preview {
  ZStack{
	 Color.background
	 IngredientsView(selectedIngredient: .constant(["qwerqw", "fkoreqw"]), showCamera: .constant(false))
  }
}
