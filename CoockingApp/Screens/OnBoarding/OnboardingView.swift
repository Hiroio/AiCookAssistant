//
//  OnboardingView.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
		ZStack{
		  Color.background.ignoresSafeArea()
		  
		  Image("comix")
			 .resizable()
			 .scaledToFit()
			 .padding()
		  
		}
    }
}

#Preview {
    OnboardingView()
}
