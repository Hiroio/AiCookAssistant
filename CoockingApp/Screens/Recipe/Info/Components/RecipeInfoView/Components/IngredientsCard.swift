//
//  IngredientsCard.swift
//  CoockingApp
//
//  Created by user on 07.05.2026.
//

import SwiftUI

struct IngredientsCard: View {
  let ingredients: [String]
  let macros: String
    var body: some View {
		VStack(alignment: .leading, spacing: 15){
		  Text("Ingredients")
			 .frame(maxWidth: .infinity, alignment: .leading)
			 .font(.title3)
			 .fontWeight(.medium)
			 .fontDesign(.rounded)
			 .foregroundStyle(.primaryAction)
		  VStack{
			 ForEach(ingredients, id: \.self){ item in
				let items = item.components(separatedBy: "-").map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
				HStack{
				  Circle()
					 .fill(.primaryAction)
					 .frame(width: 5)
				  Text(items[0])
					 .font(.subheadline)
					 .multilineTextAlignment(.leading)
					 .fontDesign(.rounded)
					 .kerning(1)
				  Spacer()
				  Text(items.last ?? "")
					 .font(.footnote)
				  
				}.fontWeight(.light)
				.foregroundStyle(.primarytext)
				.fontDesign(.rounded)
			 }
		  }
		  Divider()
			 
		  macrosText(macros)
		  
		}
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.secondaryCard)
		)
    }
}

#Preview {
    IngredientsCard(ingredients: ["qweqwe - 200g", "qweqwe - 150g", "qweqwe - 1pcs", "qweqwe - to taste"], macros: "420,30,15,25")
}


@ViewBuilder
func macrosText(_ macros: String) -> some View{
  if !macros.isEmpty{
	 let macroses = macros.components(separatedBy: ",")
	 HStack{
		Text("\(macroses[0]) kcal • P \(macroses[1])g • F \(macroses[2])g • C \(macroses[3])g")
		  .font(.caption)
		  .foregroundStyle(.primarytext.opacity(0.6))
	 }
  }else{
	 EmptyView()
  }
}
