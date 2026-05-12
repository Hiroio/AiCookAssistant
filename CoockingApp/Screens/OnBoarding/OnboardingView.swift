//
//  OnboardingView.swift
//  CoockingApp
//
//  Created by user on 10.05.2026.
//

import SwiftUI

struct OnboardingView: View {
  @State private var animationDone: Bool = false
  let complete: () -> ()
    var body: some View {
		ZStack{
		  Color.background.ignoresSafeArea()
		  if !animationDone{
			 OnBoardingAnimation(){animationDone.toggle()}
				.transition(.opacity)
				.zIndex(1)
				.allowsHitTesting(!animationDone)
		  }else{
			 OnBoardingTabView(complete: complete)
		  }
		}
		.animation(.easeInOut(duration: 1.5), value: animationDone)
    }
}

#Preview {
  OnboardingView(){}
}
