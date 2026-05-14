//
//  ProfileEditView.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import SwiftUI

struct ProfileEditView: View {
  @EnvironmentObject private var vm: ProfileViewModel
  @EnvironmentObject private var storeManager: StoreManager
  @Environment(\.openURL) private var openURL
  @State private var cookingState: Bool = false
  @State private var languageState: Bool = false
  let cancelAction: () -> Void
  let saveAction: () -> Void
  
  private let privacyURL = URL(string: "https://deli-note.netlify.app/privacy/")!
  private let supportURL = URL(string: "https://deli-note.netlify.app/support/")!
  private let termsURL = URL(string: "https://deli-note.netlify.app/terms/")!
  private let subscriptionURL = URL(string: "https://apps.apple.com/account/subscriptions")!
  
    var body: some View {
		ZStack {
			  Color.background
				 .ignoresSafeArea()
		  
		  VStack(spacing: 0) {
			 topBar
			 
				 ScrollView {
					VStack(spacing: 24) {
				  avatarSection
				  nameSection
				  personalizationSection
				  settingsSection
				}
				.padding(.horizontal, 22)
					.padding(.top, 18)
					.padding(.bottom, 18)
				 }
				 .scrollDismissesKeyboard(.interactively)
				 
				 legalCaption
				.padding(.bottom, 18)
		  }
		}
    }
  
  private var topBar: some View {
	 HStack {
			Button("Cancel") {
			  cancelAction()
			}
		.font(.subheadline.weight(.medium))
		.foregroundStyle(Color.primarytext.opacity(0.68))
		
		Spacer()
		
		Text("Edit Profile")
		  .font(.headline.weight(.semibold))
		  .foregroundStyle(Color.primarytext)
		
		Spacer()
		
			Button("Save") {
			  saveAction()
			}
		.font(.subheadline.weight(.semibold))
		.foregroundStyle(Color.primaryAction)
	 }
	 .padding(.horizontal, 20)
	 .padding(.top, 18)
	 .padding(.bottom, 14)
	 .background(Color.background)
  }
  
  private var avatarSection: some View {
	 VStack(spacing: 12) {
		Image("profilePic")
		  .resizable()
		  .scaledToFit()
		  .frame(width: 92, height: 92)
		  .padding(18)
		  .background(
			 Circle()
				.fill(Color.rareCard.opacity(0.42))
		  )
//		  .overlay(alignment: .bottomTrailing) {
//			 Button {
//			 } label: {
//				Image(systemName: "plus")
//				  .font(.system(size: 15, weight: .bold))
//				  .foregroundStyle(Color.background)
//				  .frame(width: 34, height: 34)
//				  .background(Circle().fill(Color.primaryAction))
//				 }
//				 .buttonStyle(.plain)
//				 .iconButtonAccessibility("Change photo")
//			  }
		
//		Text("Change photo")
//		  .font(.footnote.weight(.medium))
//		  .foregroundStyle(Color.primaryAction)
	 }
	 .frame(maxWidth: .infinity)
  }
  
  private var nameSection: some View {
	 VStack(alignment: .leading, spacing: 10) {
		Text("Name")
		  .font(.subheadline.weight(.semibold))
		  .foregroundStyle(Color.primarytext)
		
			TextField("UserName", text: $vm.user.username)
			  .submitLabel(.done)
			  .font(.body.weight(.medium))
		  .foregroundStyle(Color.primarytext)
		  .textInputAutocapitalization(.words)
		  .padding(.horizontal, 16)
		  .frame(height: 54)
		  .background(
			 RoundedRectangle(cornerRadius: 18)
				.fill(Color.secondaryCard.opacity(0.58))
		  )
			  .overlay(
				 RoundedRectangle(cornerRadius: 18)
					.stroke(Color.primarytext.opacity(0.08), lineWidth: 1)
			  )
		 }
	  }
  
  private var personalizationSection: some View {
	 VStack(alignment: .leading, spacing: 12) {
		Text("Personalization")
		  .font(.subheadline.weight(.semibold))
		  .foregroundStyle(Color.primarytext)
		
		VStack(spacing: 15) {
		  VStack{
			 Button{
				withAnimation(.bouncy(duration: 0.6)){
				  cookingState.toggle()
				}
			 }label:{
				PersonalizationRow(
				  title: "Cooking identity",
				  subtitle: "\(vm.user.cookingIdentity.text)",
				  icon: "fork.knife",
				  state: cookingState
				)
				.contentShape(.rect)
			 }
			 .buttonStyle(.plain)
			 
			 if cookingState{
				ProfileOptionPicker(selection: $vm.user.cookingIdentity)
			 }
			 
			 Text("Assistant will use this lightly to personalize recipes.")
				.font(.caption)
				.foregroundStyle(Color.primarytext.opacity(0.52))
				.padding(.horizontal, 4)
		  }
		  .padding(.horizontal, 14)
		  .padding(.vertical, 12)
		  .background(
			 RoundedRectangle(cornerRadius: 22)
				.fill(Color.secondaryCard.opacity(0.48))
		  )
		  .overlay(
			 RoundedRectangle(cornerRadius: 22)
				.stroke(Color.primarytext.opacity(0.07), lineWidth: 1)
		  )
		  
		  VStack{
			 Button{
				withAnimation(.bouncy(duration: 0.8)){
				  languageState.toggle()
				}
			 }label: {
				PersonalizationRow(title: "Language",
										 subtitle: vm.selectedLanguage.text,
										 icon: "globe",
										 state: languageState)
				.contentShape(.rect)
			 }
			 .buttonStyle(.plain)
			 if languageState{
				ProfileOptionPicker(selection: $vm.selectedLanguage)
			 }
		  }
		  .padding(.horizontal, 14)
		  .padding(.vertical, 12)
		  .background(
			 RoundedRectangle(cornerRadius: 22)
				.fill(Color.secondaryCard.opacity(0.48))
		  )
		  .overlay(
			 RoundedRectangle(cornerRadius: 22)
				.stroke(Color.primarytext.opacity(0.07), lineWidth: 1)
		  )
		}
		
		
		
	 }
  }
  
  private var settingsSection: some View {
	 VStack(alignment: .leading, spacing: 12) {
		Text("Settings")
		  .font(.subheadline.weight(.semibold))
		  .foregroundStyle(Color.primarytext)
		
		VStack(spacing: 0) {
		  Button {
			 Task {
				await storeManager.restorePurchases()
			 }
		  } label: {
			 settingsRow(
				title: "Restore Purchases",
				subtitle: "Recover active subscriptions",
				icon: "arrow.clockwise"
			 )
		  }
		  
		  Divider()
			 .padding(.leading, 58)
		  
		  Button {
			 openURL(subscriptionURL)
		  } label: {
			 settingsRow(
				title: "Manage Subscription",
				subtitle: "Open Apple subscription settings",
				icon: "creditcard"
			 )
		  }
		}
		.buttonStyle(.plain)
		.background(
		  RoundedRectangle(cornerRadius: 22)
			 .fill(Color.secondaryCard.opacity(0.48))
		)
		.overlay(
		  RoundedRectangle(cornerRadius: 22)
			 .stroke(Color.primarytext.opacity(0.07), lineWidth: 1)
		)
	 }
  }
  
  private var legalCaption: some View {
		 HStack(spacing: 8) {
			Link("Privacy Policy", destination: privacyURL)
			Text("•")
			Link("Support", destination: supportURL)
			Text("•")
			Link("Terms of Use", destination: termsURL)
		 }
	 .font(.caption.weight(.medium))
	 .foregroundStyle(Color.primarytext.opacity(0.52))
	 .frame(maxWidth: .infinity)
  }
  
  private func settingsRow(title: String, subtitle: String, icon: String) -> some View {
	 HStack(spacing: 14) {
		Image(systemName: icon)
		  .font(.system(size: 16, weight: .semibold))
		  .foregroundStyle(Color.primaryAction)
		  .frame(width: 38, height: 38)
		  .background(Circle().fill(Color.background.opacity(0.72)))
		
		VStack(alignment: .leading, spacing: 3) {
		  Text(title)
			 .font(.subheadline.weight(.semibold))
			 .foregroundStyle(Color.primarytext)
		  
		  Text(subtitle)
			 .font(.caption)
			 .foregroundStyle(Color.primarytext.opacity(0.55))
		}
		
		Spacer()
		
		Image(systemName: "chevron.right")
		  .font(.caption.weight(.semibold))
		  .foregroundStyle(Color.primarytext.opacity(0.35))
	 }
	 .padding(.horizontal, 14)
	 .padding(.vertical, 12)
	 .contentShape(.rect)
  }
}

#Preview {
  ProfileEditView(cancelAction: {}, saveAction: {})
	 .environmentObject(ProfileViewModel())
	 .environmentObject(StoreManager.shared)
}
