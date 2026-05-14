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
			 .foregroundStyle(.primaryAction)
		  HStack{
			 preferenceCard(icon: "clock", title: "Cooking Time", value: nil)
			 Rectangle()
				.fill(.primarytext.opacity(0.5))
				.frame(width: 0.5, height: 35)
			 preferenceCard(icon: "align.vertical.bottom", title: "Difficulty", value: nil)
		  }
		  
		  .padding()
		  .background(
			 RoundedRectangle(cornerRadius: 20)
				.fill(.secondaryCard.opacity(0.5))
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
		.foregroundStyle(.primaryAction)
	 VStack{
		Text(LocalizedStringKey(title))
		  .font(.footnote)
		  .fontDesign(.rounded)
		Text(value ?? "____")
	 }
	 .foregroundStyle(.primarytext)
  }
  .font(.headline)
  
  .padding(8)
  .frame(maxWidth: .infinity, alignment: .leading)
}
