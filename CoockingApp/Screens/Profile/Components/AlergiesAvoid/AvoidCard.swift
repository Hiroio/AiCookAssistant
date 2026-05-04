//
//  AvoidCard.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI

struct AvoidCard: View {
  var body: some View {
	 HStack(alignment: .top){
		Image(systemName: "xmark")
		  .badgeIcon(color: .red.opacity(0.3))
		VStack(alignment: .leading){
		  HStack{
			 VStack(alignment: .leading){
				Text("Avoid Ingreedients")
				  .font(.subheadline.bold())
				Text("Ingredient you prefer to avoid")
				  .font(.caption2)
				  .opacity(0.6)
			 }
			 Spacer()
			 Button{}label: {
				Image(systemName: "chevron.right")
				  .font(.subheadline)
				  .foregroundStyle(.charcoal)
			 }
		  }
		  
		  //		  LIST
		  HStack{
			 ForEach(["onion", "olives"], id: \.self){item in
				Text(item.capitalized)
				  .font(.caption)
				  .padding(5)
				  .padding(.horizontal, 5)
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.white)
						.shadow(radius: 1)
				  )
				  .foregroundStyle(.charcoal)
			 }
		  }
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		
	 }
	 .padding(12)
	 .background(
		RoundedRectangle(cornerRadius: 15)
		  .fill(.warmBeige.opacity(0.2))
	 )
  }
  }
  
  #Preview {
	 AvoidCard()
  }
