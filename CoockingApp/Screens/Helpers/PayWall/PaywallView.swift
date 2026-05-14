//
//  PaywallView.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
  @State private var loaded: Bool = false
    var body: some View {
		ZStack{
		  Color.background.ignoresSafeArea()
		  SubscriptionStoreView(groupID: "22087473"){
			 VStack(spacing: 25){
				if UIDevice.isIPad{
				  Image("ChefCooking")
					 .resizable()
					 .scaledToFit()
				}
				HStack(alignment: .bottom){
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
				  if UIDevice.isIPhone{
					 Image("ChefCooking")
						.resizable()
						.scaledToFit()
						.padding(15)
				  }
				}
				.frame(alignment: .bottom)
				
				PaywallFeaturesCard()
				  .frame(maxHeight: .infinity)
				
			 }
		  }
		  .subscriptionStoreControlBackground(Color.background)
		  .subscriptionStoreControlStyle(.compactPicker, placement: .bottomBar)
		  .tint(.primaryAction)
		  .subscriptionStorePolicyForegroundStyle(.accentCard, .primaryAction)
		  .background(
				Color.background
		  )
		}
		.safeAreaInset(edge: .bottom, content: {
		  Button{
			 Task{
				await StoreManager.shared.restorePurchases()
			 }
		  }label:{
			 Text("Restore Purchases")
				.font(.caption)
				.foregroundStyle(.primarytext)
				.opacity(0.7)
		  }
		})
		.animation(.easeOut(duration: 1), value: loaded)
    }
}

#Preview {
  PaywallView()
	 .environmentObject(StoreManager.shared)
}
