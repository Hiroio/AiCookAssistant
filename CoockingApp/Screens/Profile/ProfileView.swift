//
//  ProfileView.swift
//  CoockingApp
//
//  Created by user on 03.05.2026.
//

import SwiftUI

struct ProfileView: View {
  @StateObject private var vm = ProfileViewModel()
  @ObservedObject private var storeManager = StoreManager.shared
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
			 
			 if !storeManager.hasFullAccess {
				premiumBanner
			 }
			 
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
		
	 }
	 .sheet(isPresented: Binding<Bool>(get: {
		vm.activeSheet != nil
	 }, set: { _ in
		vm.activeSheet = nil
	 }), content: {
		AlergiesSheet()
		  .presentationDetents([.medium])
		  .environmentObject(vm)
	 })
	 
	 .environmentObject(vm)
  }
  
  private var premiumBanner: some View {
	 Button {
		storeManager.showingSheet = true
	 } label: {
		HStack(spacing: 12) {
		  Image("serve")
			 .resizable()
			 .scaledToFit()
			 .frame(width: 38, height: 38)
			 .padding(8)
			 .background(
				Circle()
				  .fill(Color.background.opacity(0.8))
			 )
		  
		  VStack(alignment: .leading, spacing: 3) {
			 Text("DeliNote Premium")
				.font(.subheadline.weight(.semibold))
				.foregroundStyle(Color.primarytext)
			 
			 Text("Unlimited recipes, scans and cooking help")
				.font(.caption)
				.foregroundStyle(Color.primarytext.opacity(0.62))
				.lineLimit(1)
		  }
		  
		  Spacer()
		  
		  Image(systemName: "chevron.right")
			 .font(.caption.weight(.semibold))
			 .foregroundStyle(Color.primaryAction)
		}
		.padding(.horizontal)
		.background(
		  RoundedRectangle(cornerRadius: 18)
			 .fill(Color.secondaryCard.opacity(0.75))
		)
		.overlay(
		  RoundedRectangle(cornerRadius: 18)
			 .stroke(Color.accentCard.opacity(0.32), lineWidth: 1)
		)
	 }
	 .buttonStyle(.plain)
  }
}

#Preview {
  ProfileView()
}
