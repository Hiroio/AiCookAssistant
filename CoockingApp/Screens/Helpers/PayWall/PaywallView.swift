//
//  PaywallView.swift
//  CoockingApp
//
//  Created by user on 06.05.2026.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
  @EnvironmentObject private var storeManager: StoreManager
  private let privacyURL = URL(string: "https://deli-note.netlify.app/privacy/")!
  private let termsURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!

  var body: some View {
    ZStack {
      Color.background.ignoresSafeArea()
      SubscriptionStoreView(productIDs: StoreManager.subscriptionProductIDs) {
        VStack(spacing: 25) {
          if UIDevice.isIPad {
            Image("ChefCooking")
              .resizable()
              .scaledToFit()
          }
          HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
              Text("Unlock your full cooking potential")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primaryAction)
                .fontDesign(.serif)
              Text("Create more recipes, scan ingredients, and get help while cooking")
                .font(.footnote)
                .opacity(0.6)
            }
            .frame(maxWidth: .infinity)
            if UIDevice.isIPhone {
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
      VStack {
        HStack(spacing: 8) {
          Link("Privacy Policy", destination: privacyURL)
          Text("•")
          Link("Terms of Use", destination: termsURL)
        }
        Button {
          Task {
            await storeManager.restorePurchases()
          }
        } label: {
          Text("Restore Purchases")
        }
      }
      .font(.caption)
      .foregroundStyle(.primarytext)
      .opacity(0.7)
    })
    .onAppear {
      Task {
        await storeManager.refreshAccess()
      }
    }
    .onChange(of: storeManager.hasFullAccess) { _, hasAccess in
      if hasAccess {
        storeManager.showingSheet = false
      }
    }
  }
}

#Preview {
  PaywallView()
    .environmentObject(StoreManager.shared)
}
