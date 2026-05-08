//
//  PaywallView.swift
//  CoockingApp
//
//  Created by user on 05.05.2026.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
  @EnvironmentObject private var storeManager: StoreManager
  @State private var selected: Product? = nil
    var body: some View {
		ZStack(alignment: .top){
		  Color.softIvory
			 .ignoresSafeArea()
		  HStack{
			 Spacer()
				.frame(maxWidth: .infinity)
			 Circle()
				.fill(.accentCard.opacity(0.3))
		  }
		  
//		  MARK: HEADER
		  VStack(spacing: 25){
			 Button{
				StoreManager.shared.showingSheet = false
			 }label: {
				Image(systemName: "xmark")
				  .foregroundStyle(.primarytext)
			 }
			 .frame(maxWidth: .infinity, alignment: .leading)
			 HStack{
				VStack(alignment: .leading, spacing: 10){
				  Text("Unlock your full cooking potential")
					 .font(.title)
					 .fontWeight(.semibold)
					 .foregroundStyle(.primaryAction)
					 .fontDesign(.serif)
				  Text("Upgrade to Premium and get the most of AI-powered cooking")
					 .font(.footnote)
					 .opacity(0.6)
				}.frame(maxWidth: .infinity)
				Spacer()
				  .frame(maxWidth: .infinity)
			 }
//			 MARK: Features
			 VStack{
				ForEach(paywallFeatures, id: \.title){(icon, title, desc) in
				  featureCard(icon: icon, title: title, desc: desc)
				  if paywallFeatures.last?.title != title{
					 Divider()
				  }
				}
			 }
			 .padding()
			 .background(
				RoundedRectangle(cornerRadius: 20)
				  .fill(.secondaryCard.opacity(0.6))
			 )
			 
//			 VStack{
//				//			 MARK: Sections
//				if storeManager.products.isEmpty {
//				  RoundedRectangle(cornerRadius: 20)
//					 .fill(.herbalGreen.opacity(0.4))
//					 .frame(height: 120)
//					 .blur(radius: 5)
//					 .task {
//						await storeManager.fetchProducts()
//					 }
//				}else{
//				  ForEach(storeManager.products, id: \.id){item in
//					 subscriptionCard(name: item.displayName, price: item.displayPrice, type: item.subscription?.subscriptionPeriod, selected: selected == item)
//						.onTapGesture {
//						  selected = item
//						}
//				  }
//				  .onAppear{
//					 selected = storeManager.products.first
//				  }
//				}
//			 }
//			 .animation(.easeInOut, value: selected == storeManager.products.first)
//			 VStack{
//				Button{
//				  
//				}label: {
//				  Text("Start free trial")
//					 .foregroundStyle(.white)
//					 .padding(12)
//					 .frame(maxWidth: .infinity)
//					 .background(
//						RoundedRectangle(cornerRadius: 15)
//						  .fill(.mossGreen)
//					 )
//				}
//				Text("Cancel anytime, No commitment")
//				  .font(.caption)
//				  .opacity(0.6)
//			 }
		  }
		  .padding()
		  .animation(.easeInOut, value: selected != nil)
		}
    }
  
  private let paywallFeatures: [(icon: String, title: String, description: String)] = [
	  ("infinity", "Unlimited Recipes", "Get unlimited access to AI-generated recipes with no limits."),
	  ("camera", "Photo Ingredient Analysis", "Snap a photo and AI will instantly detect ingredients for you."),
	  ("square.and.pencil", "Edit Your RecipeList", "Add, edit, delete and organize your personal recipe collections."),
	  ("frying.pan", "AI Cook Assistant", "Get step-by-step guidance, tips and answers to all your cooking questions.")
	]
}

@ViewBuilder
func featureCard(icon: String, title: String, desc: String)-> some View{
  HStack{
	 Image(systemName: icon)
		.foregroundStyle(.mossGreen)
		.frame(width: 35, height: 35)
		.padding(5)
		.background(
		  Circle()
			 .fill(.herbalGreen.opacity(0.3))
		)
	 VStack(alignment: .leading){
		Text(title)
		  .font(.subheadline)
		  .fontWeight(.medium)
		Text(desc)
		  .font(.footnote)
		  .opacity(0.7)
	 }
	 .frame(maxWidth: .infinity, alignment: .leading)
  }
}

@ViewBuilder
func subscriptionCard(name: String, price: String, type: Product.SubscriptionPeriod?, selected: Bool) -> some View{
  HStack{
	 VStack(alignment: .leading){
		HStack{
		  Text(name)
			 .font(.subheadline)
			 .fontWeight(.medium)
		  if let type, type == .yearly{
			 Text("30% off")
				.foregroundStyle(.softIvory)
				.font(.caption)
				.padding(5)
				.background(
				  RoundedRectangle(cornerRadius: 15)
					 .fill(.mossGreen)
				)
		  }
		}
		Text("3-day-free-trial")
		  .font(.caption)
		  .opacity(0.7)
	 }
	 Spacer()
	 if let type{
		  HStack{
			 Text(price)
				.font(.subheadline)
				.fontWeight(.medium)
			 Text("/ \(type == .monthly ? "month" : "year")")
				.font(.footnote)
		  }
	 }
	 Image(systemName: selected ? "checkmark.circle.fill" : "circle")
		.foregroundStyle(selected ? .herbalGreen : .black)
		.padding(.horizontal)
  }
  .padding()
  .frame(height: 55)
  .background(
	 ZStack{
		RoundedRectangle(cornerRadius: 10)
		  .fill(.softIvory)
		  .shadow(radius: 1)
		if selected{
		  RoundedRectangle(cornerRadius: 10)
			 .fill(.sageMist.opacity(0.3))
		}
	 }
  )
  .overlay {
	 Group{
		if selected{
		  RoundedRectangle(cornerRadius: 10)
			 .stroke(.mossGreen)
		}
	 }
  }
}

#Preview {
    PaywallView()
	 .environmentObject(StoreManager.shared)
}

