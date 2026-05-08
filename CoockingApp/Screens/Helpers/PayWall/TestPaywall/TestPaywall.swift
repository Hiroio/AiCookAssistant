//
//  TestPaywall.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI
import StoreKit

struct TestPaywall: View {
    var body: some View {
		ZStack{
		  Color.softIvory.ignoresSafeArea()
		  HStack{
			 Spacer()
				.frame(maxWidth: .infinity)
			 Circle()
				.fill(.herbalGreen.opacity(0.3))
		  }
		  .frame(maxHeight: .infinity, alignment: .top)
		  
		  SubscriptionStoreView(groupID: "237F9169"){
			 VStack{
				HStack{
				  VStack(alignment: .leading, spacing: 10){
					 Text("Unlock your full cooking potential")
						.font(.title)
						.fontWeight(.semibold)
						.foregroundStyle(.mossGreen)
						.fontDesign(.serif)
					 Text("Upgrade to Premium and get the most of AI-powered cooking")
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
		  .tint(.herbalGreen)
		}
    }
}

#Preview {
    TestPaywall()
	 .environmentObject(StoreManager.shared)
}
