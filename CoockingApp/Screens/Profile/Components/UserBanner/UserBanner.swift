//
//  UserBanner.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct UserBanner: View {
  let user: UserModel
  let editAction: () -> Void
  
    var body: some View {
		VStack{
		  HStack{
			 Image("profilePic")
				.resizable()
				.scaledToFit()
				.shadow(radius: 1)
				.background(
				  Circle()
					 .fill(.rareCard.opacity(0.5))
		  )
				.frame(width: 85)
			 VStack(alignment: .leading){
				Text(user.username)
				  .font(.headline)
				Text("Cooking explorer")
				  .font(.footnote)
			 }
			 .frame(maxWidth: .infinity, alignment: .leading)
			 
			 Button {
				editAction()
			 } label: {
				HStack{
				  Text("Edit")
				  Image(systemName: "pencil")
				}
				.foregroundStyle(.primarytext.opacity(0.7))
				.padding(15)
				.background(
				  RoundedRectangle(cornerRadius: 20)
					 .fill(Color.background.opacity(0.5))
				)
			 }
		  }
		}
    }
}

#Preview {
  UserBanner(user: UserModel(entity: CoreDataManager.shared.fetchUser())) {}
}
