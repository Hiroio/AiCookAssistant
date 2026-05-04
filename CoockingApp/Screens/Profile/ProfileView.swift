//
//  ProfileView.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct ProfileView: View {
  @StateObject private var vm = ProfileViewModel()
  var body: some View {
	 ZStack{
		Color.softIvory.ignoresSafeArea()
		ScrollView{
		  VStack(spacing: 15){
			 Text("Profile")
				.font(.title)
				.frame(maxWidth: .infinity, alignment: .leading)
				.fontDesign(.serif)

			 UserBanner()
				.padding(.vertical)
			 
			 UserStatistic()
			 
			 VStack(alignment: .leading){
				//				  MARK: User Preference
				Text("Preferences")
				  .headline()
				VStack(spacing: 10){
				
				
				//				FavoriteIngredientCard(ingreedients: [])
				AvoidCard()
				AlergiesCard()
			 }
				CookingPreferenceCard()
			 }
		  }
		  .padding()
		}
		.safeAreaInset(edge: .bottom) {
		  Text("Version 1.0.1")
			 .font(.caption)
			 .opacity(0.5)
		}
		
	 }
	 
	 .environmentObject(vm)
  }
}

#Preview {
  ProfileView()
}
