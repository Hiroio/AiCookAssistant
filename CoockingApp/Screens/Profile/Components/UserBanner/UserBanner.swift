//
//  UserBanner.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct UserBanner: View {
    var body: some View {
		VStack{
		  HStack{
			 Circle()
				.fill(.herbalGreen.opacity(0.5))
				.frame(height: 105)
			 VStack(alignment: .leading){
				Text("UserName")
				  .font(.headline)
				Text("Cooking explorer")
				  .font(.footnote)
			 }
			 .frame(maxWidth: .infinity, alignment: .leading)
			 
			 Button{}label: {
				HStack{
				  Text("Edit")
				  Image(systemName: "pencil")
				}
				.padding()
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.warmBeige.opacity(0.5))
				)
			 }
		  }
		  Divider()
		  UserStatistic()
		}
		.padding()
		.background(
		  RoundedRectangle(cornerRadius: 20)
			 .fill(.softIvory)
		)
		.compositingGroup()
		.shadow(radius: 2)
    }
}

#Preview {
    UserBanner()
}
