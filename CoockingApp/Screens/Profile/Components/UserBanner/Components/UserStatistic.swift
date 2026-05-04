//
//  UserStatistic.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct UserStatistic: View {
    var body: some View {
		HStack(){
		  statCard(title: "Created", value: "12", icon: "books.vertical", color: .orange)
			 .frame(maxWidth: .infinity)
		  Rectangle()
			 .fill(.herbalGreen.opacity(0.6))
			 .frame(width: 1, height: 25)
			 .padding(.vertical)
		  statCard(title: "Cooked", value: "5", icon: "frying.pan", color: .brown)
			 .frame(maxWidth: .infinity)
		  Rectangle()
			 .fill(.herbalGreen.opacity(0.6))
			 .frame(width: 1, height: 25)
			 .padding(.vertical)
		  statCard(title: "Favorites", value: "16", icon: "heart", color: .red)
			 .frame(maxWidth: .infinity)
		  Rectangle()
			 .fill(.herbalGreen.opacity(0.6))
			 .frame(width: 1, height: 25)
			 .padding(.vertical)
		  statCard(title: "Ingredients", value: "36", icon: "leaf", color: .herbalGreen)
			 .frame(maxWidth: .infinity, alignment: .bottom)
		}
		.padding(12)
		.background(
		  RoundedRectangle(cornerRadius: 15)
			 .fill(.white)
			 .shadow(radius: 1)
		)
		.opacity(0.7)
    }
}



#Preview {
    UserStatistic()
}


@ViewBuilder
func statCard(title: String, value: String, icon: String, color: Color) -> some View{
  VStack(spacing: 5){
	 Image(systemName: icon)
		.font(.title2)
		.frame(width: 45)
		.foregroundStyle(color)
	 Text(value)
		.font(.headline)
	 Text(title)
		.font(.caption)
		.opacity(0.6)
  }
  .frame(height: 65, alignment: .bottom)
}
