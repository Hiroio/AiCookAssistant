//
//  CookingPreferenceCard.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI

struct CookingPreferenceCard: View {
    var body: some View {
		VStack(alignment: .leading){
		  Text("Cooking Style")
			 .font(.headline)
			 .foregroundStyle(.mossGreen)
		  HStack{
			 preferenceCard(icon: "clock", title: "Cooking Time", value: nil)
			 Rectangle()
				.fill(.charcoal.opacity(0.5))
				.frame(width: 0.5, height: 35)
			 preferenceCard(icon: "align.vertical.bottom", title: "Difficulty", value: nil)
		  }
		  
		  .padding()
		  .background(
			 RoundedRectangle(cornerRadius: 20)
				.fill(.sageMist.opacity(0.5))
		  )
		}
		}
		
}

#Preview {
    CookingPreferenceCard()
}


@ViewBuilder
func preferenceCard(icon: String, title: String, value: String?) -> some View{
  HStack(){
	 Image(systemName: icon)
		.font(.title)
		.foregroundStyle(.mossGreen)
	 VStack{
		Text(title)
		  .font(.footnote)
		Text(value ?? "____")
	 }
	 .foregroundStyle(.charcoal)
  }
  .font(.headline)
  
  .padding(8)
  .frame(maxWidth: .infinity, alignment: .leading)
}
