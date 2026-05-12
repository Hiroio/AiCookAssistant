//
//  OnBoardingSetUp.swift
//  CoockingApp
//
//  Created by user on 11.05.2026.
//

import SwiftUI

struct OnBoardingSetUp: View {
  @AppStorage("appLanguage") private var storedLanguage = AppLanguageEnum.system.rawValue
  @State private var cookingIdentity: CookingIdentityEnum = .homeCook
  @State private var selectedLanguage: AppLanguageEnum = .system
  @State private var cookingState: Bool = true
  @State private var languageState: Bool = false
  
  init() {
	 let language = UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguageEnum.system.rawValue
	 
	 self._selectedLanguage = State(initialValue: AppLanguageEnum(rawValue: language) ?? .system)
  }
  
  var body: some View {
	 VStack(spacing: 18){
		//		  TOP
		VStack(spacing: 6){
		  Image("Personolize")
			 .resizable()
			 .scaledToFit()
			 .clipShape(.circle)
		  Text("Personalize your cooking")
			 .font(.title.weight(.black))
			 .fontDesign(.rounded)
			 .foregroundStyle(.primaryAction)
			 .multilineTextAlignment(.center)
		  
		  Text("DeliNote will lightly adapt recipes to your style and language.")
			 .font(.footnote.weight(.medium))
			 .foregroundStyle(Color.primarytext.opacity(0.58))
			 .multilineTextAlignment(.center)
			 .padding(.horizontal, 34)
		}
		.frame(maxHeight: .infinity)
		.padding(.top, 15)
		.padding(.bottom)
		//		  Bottom
		ScrollView{
		  VStack(spacing: 16) {
//			 MARK: IDENTITY
			 VStack{
				Button{
				  withAnimation(.bouncy){
					 cookingState.toggle()
				  }
				}label:{
				  PersonalizationRow(title: "Cooking identity", subtitle: cookingIdentity.text, icon: "fork.knife", state: cookingState)
				}
				
				if cookingState{
				  ProfileOptionPicker(selection: $cookingIdentity)
					 .frame(height: 142)
				}
			 }
			 .cardForPersonalization()
			 
			 //				MARK: Language
			 VStack{
				Button{
				  withAnimation(.bouncy) {
					 languageState.toggle()
				  }
				}label:{
				  PersonalizationRow(title: "Language",
											subtitle: selectedLanguage.text,
											icon: "globe",
											state: languageState)
				}
				if languageState {
				  ProfileOptionPicker(selection: $selectedLanguage)
					 .frame(height: 142)
				}
			 }
			 .cardForPersonalization()
		  }
		  .frame(maxHeight: .infinity)
		  
		}
		.onDisappear {
		  storedLanguage = selectedLanguage.rawValue
		  UserManager.shared.changeCookingIdentity(identity: cookingIdentity)
		}
	 }
  }
}

#Preview {
  ZStack{
	 Color.background.ignoresSafeArea()
	 OnBoardingSetUp()
  }
}

