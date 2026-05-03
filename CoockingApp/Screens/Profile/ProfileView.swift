//
//  ProfileView.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
		ZStack{
		  Color.softIvory.ignoresSafeArea()
		  ScrollView{
			 VStack{
				UserBanner()
				
				
				VStack(alignment: .leading){
//				  MARK: User Preference
				  Text("User Preference")
					 .headline()
				  
				  FavoriteIngredientCard(ingreedients: [])
				}
			 }
			 .padding()
		  }
		}
    }
}

#Preview {
    ProfileView()
}
