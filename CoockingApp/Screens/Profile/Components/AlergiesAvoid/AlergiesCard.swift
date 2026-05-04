//
//  AlergiesCard.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI

struct AlergiesCard: View {
    var body: some View {
		HStack(alignment: .top){
		Image(systemName: "exclamationmark.shield")
		  .badgeIcon(color: .indigo.opacity(0.3))
		VStack(alignment: .leading){
		  HStack{
			 VStack(alignment: .leading){
				Text("Allergies / Restrictions")
				  .font(.subheadline.bold())
				Text("Your dietary restrictions")
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
    AlergiesCard()
}
