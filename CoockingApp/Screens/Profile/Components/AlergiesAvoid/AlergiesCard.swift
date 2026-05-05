//
//  AlergiesCard.swift
//  CoockingApp
//
//  Created by user on 04.05.2026.
//

import SwiftUI

struct AlergiesCard: View {
  @EnvironmentObject private var vm: ProfileViewModel
  var body: some View {
	 HStack(alignment: .top){
		Image(systemName: "exclamationmark.shield")
		  .badgeIcon(color: .indigo.opacity(0.3))
		VStack(alignment: .leading){
		  Button{
			 vm.activeSheet = .allergies
		  }label: {
			 HStack{
				VStack(alignment: .leading){
				  Text("Allergies / Restrictions")
					 .font(.subheadline.bold())
				  Text("Your dietary restrictions")
					 .font(.caption2)
					 .opacity(0.6)
				}
				Spacer()
				Image(systemName: "chevron.right")
				  .font(.subheadline)
			 }
			 .foregroundStyle(.charcoal)
		  }
		  
		  //		  LIST
		  
		  if vm.user.alergieIngredients.isEmpty{
			 HStack{
				Text("No information provided")
				  .font(.caption)
				  .padding(5)
				  .padding(.horizontal, 5)
				  .opacity(0.7)
				  .background(
					 RoundedRectangle(cornerRadius: 15)
						.fill(.white)
						.shadow(radius: 1)
				  )
			 }
			 .frame(maxWidth: .infinity, alignment: .trailing)
		  }else{
			 HStack{
				ForEach(vm.user.alergieIngredients.prefix(3), id: \.self){item in
				  Text(item.capitalized)
					 .font(.caption)
					 .padding(5)
					 .padding(.horizontal, 5)
					 .opacity(0.7)
					 .background(
						RoundedRectangle(cornerRadius: 15)
						  .fill(.white)
						  .shadow(radius: 1)
					 )
					 .foregroundStyle(.charcoal)
				}
			 }
			 .frame(maxWidth: .infinity, alignment: .leading)
		  }
		}
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
	 .environmentObject(ProfileViewModel())
}
