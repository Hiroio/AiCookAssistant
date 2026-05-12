//
//  OnBoardingAnimation.swift
//  CoockingApp
//
//  Created by user on 11.05.2026.
//

import SwiftUI

struct OnBoardingAnimation: View {
  @State private var startTime: Date = .now
  @State private var completed: Bool = false
  let complete: () -> ()
  var body: some View {
	 ZStack{
		Color.background.ignoresSafeArea()
		
		TimelineView(.animation(minimumInterval: 0.5, paused: completed)) { context in
		  let elapsed = context.date.timeIntervalSince(startTime)
		  let index = Int(elapsed / 1.5)
		  
		  ZStack(alignment: .center){
			 Image("OnBoarding\(index)")
				.resizable()
				.scaledToFill()
				.animation(.easeInOut, value: index)
				.drawingGroup()
//				.blur(radius: 1)
			 
			 if completed{
				Button{
				  complete()
				}label: {
				  Text("Continue")
					 .foregroundStyle(Color.background)
					 .font(.headline.weight(.black))
					 .padding()
					 .frame(maxWidth: .infinity)
					 .background(
						RoundedRectangle(cornerRadius: 15)
						  .fill(.primaryAction)
					 )
				}
				.frame(maxHeight: .infinity, alignment: .bottom)
				.transition(.opacity)
				.padding()
			 }
		  }
		  .onChange(of: index) { oldValue, newValue in
			 if newValue == 8{
				completed.toggle()
			 }
		  }
		}
	 }
	 .overlay(alignment: .topTrailing){
		if !completed{
		  Button{
			 complete()
		  }label:{
			 Text("Skip")
				.foregroundStyle(Color.primaryAction)
				.font(.subheadline.weight(.semibold))
				.padding()
		  }
		}
	 }
	 .animation(.easeInOut(duration: 1.5), value: completed)
  }
}

#Preview {
  OnBoardingAnimation(){}
}
