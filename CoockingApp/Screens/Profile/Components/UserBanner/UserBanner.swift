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
			 Image("chefsHat")
				.resizable()
				.scaledToFit()
				.shadow(radius: 1)
				.background(
				  Circle()
					 .fill(.rareCard.opacity(0.5))
		  )
				.frame(width: 75)
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
				.foregroundStyle(.charcoal.opacity(0.7))
				.padding(15)
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(.sageMist.opacity(0.5))
				)
			 }
		  }
		}
    }
}

#Preview {
    UserBanner()
}
