//
//  UserStatistic.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct UserStatistic: View {
    var body: some View {
		HStack{
		  statCard(title: "Recipe\ncreated", value: "12", icon: "books.vertical", color: .orange)
			 .frame(maxWidth: .infinity)
		  Rectangle()
			 .fill(.herbalGreen.opacity(0.6))
			 .frame(width: 1)
			 .padding(.vertical)
		  statCard(title: "Dishes\ncooked", value: "5", icon: "frying.pan", color: .brown)
			 .frame(maxWidth: .infinity)
		  Rectangle()
			 .fill(.herbalGreen.opacity(0.6))
			 .frame(width: 1)
			 .padding(.vertical)
		  statCard(title: "Favoriets", value: "16", icon: "heart", color: .red)
			 .frame(maxWidth: .infinity)
		  Rectangle()
			 .fill(.herbalGreen.opacity(0.6))
			 .frame(width: 1)
			 .padding(.vertical)
		  statCard(title: "Ingredients\nused", value: "36", icon: "leaf", color: .herbalGreen)
			 .frame(maxWidth: .infinity, alignment: .bottom)
		}
		.scaledToFit()
    }
}



#Preview {
    UserStatistic()
}


@ViewBuilder
func statCard(title: String, value: String, icon: String, color: Color) -> some View{
  VStack(spacing: 0){
	 Image(systemName: icon)
		.font(.title)
		.foregroundStyle(color)
	 Text(value)
		.padding(.vertical, 5)
	 Text(title)
		.font(.caption)
		.multilineTextAlignment(.center)
  }
  .frame(alignment: .bottom)
}
