//
//  AppRoute.swift
//  CoockingApp
//
//  Created by user on 11.05.2026.
//

import SwiftUI

struct AppRoute: View {
  @AppStorage("OnBoarding") var onBoarding: Bool = false
  @State private var load: Bool = false
    var body: some View {
		ZStack{
		  if load{
			 if onBoarding{
				NavigationView()
			 }else{
				OnboardingView(){
				  load.toggle()
				  onBoarding.toggle()
				}
			 }
		  }else{
			 MainLoadingScreen()
				.onAppear {
				  DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
					 load.toggle()
				  }
				}
		  }
		}
		  .animation(.easeInOut, value: load)
		  .animation(.easeInOut, value: onBoarding)
    }
	 
}

#Preview {
    AppRoute()
}
