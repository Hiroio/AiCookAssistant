//
//  OnBoardingTabView.swift
//  CoockingApp
//
//  Created by user on 11.05.2026.
//

import SwiftUI

struct OnBoardingTabView: View {
  @State private var selection: Int = 0
  let complete: () -> ()
  var body: some View {
	 ZStack{
		Color.background.ignoresSafeArea()
		TabView(selection: $selection) {
		  OnBoardingSetUp()
			 .tag(0)
		  
		  PaywallView()
			 .tag(1)
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
	 }
	 .animation(.bouncy, value: selection)
	 .overlay(alignment: .topTrailing) {
		Button{
		  if selection == 1{
			 complete()
		  }else{
			 selection = 1
		  }
		}label: {
		  Text("Continue")
			 .foregroundStyle(Color.primaryAction)
			 .font(.subheadline.weight(.semibold))
			 .padding()
		}
	 }
  }
}

#Preview {
  OnBoardingTabView(){}
}
