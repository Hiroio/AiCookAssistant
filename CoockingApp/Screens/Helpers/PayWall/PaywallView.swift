//
//  PaywallView.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    var body: some View {
		ZStack{
		  Color.background.ignoresSafeArea()
		  HStack{
			 Spacer()
				.frame(maxWidth: .infinity)
			 Image("ChefCooking")
				.resizable()
				.scaledToFit()
				.frame(maxWidth: .infinity)
				.padding(15)
		  }
		  .frame(maxHeight: .infinity, alignment: .top)
		  .padding(.top, 25)
		  
		  SubscriptionStoreView(groupID: "237F9169"){
			 VStack(spacing: 25){
				HStack{
				  VStack(alignment: .leading, spacing: 10){
					 Text("Unlock your full cooking potential")
						.font(.title)
						.fontWeight(.semibold)
						.foregroundStyle(.primaryAction)
						.fontDesign(.serif)
					 Text("Create more recipes, scan ingredients, and get help while cooking")
						.font(.footnote)
						.opacity(0.6)
				  }.frame(maxWidth: .infinity)
				  Spacer()
					 .frame(maxWidth: .infinity)
				}
				
				PaywallFeaturesCard()
			 }
		  }
		  .subscriptionStoreControlBackground(.gradientMaterialOnScroll)
		  .subscriptionStoreControlStyle(.compactPicker, placement: .bottomBar)
		  .tint(.primaryAction)
		}
    }
}

#Preview {
  PaywallView()
	 .environmentObject(StoreManager.shared)
}
