//
//  LoadingScreen.swift
//  CoockingApp
//
//  Created by user on 28.04.2026.
//

import SwiftUI

struct LoadingScreen: View {
  let type: LoadingScreenType
  @State private var startTime: Date = .now
  @State private var sprite: Int = 0
  
  init(type: LoadingScreenType = .recipeCreation) {
	 self.type = type
  }
  
  var body: some View {
	 ZStack{
		Color.background.ignoresSafeArea()
		
		TimelineView(.animation(minimumInterval: 1 / 30)) { context in
		  let elapsed = context.date.timeIntervalSince(startTime)
		  let messageIndex = Int(elapsed / 3) % type.messages.count
		  let dots = String(repeating: ".", count: Int(elapsed / 0.75) % 4)
		  let sprite = Int(elapsed * 8) % 13
		  ZStack {
			 VStack(spacing: 0) {
				
				Spacer()
				Text(type.messages[messageIndex] + dots)
				  .font(.title.weight(.black))
				  .foregroundStyle(Color.primaryAction)
				  .contentTransition(.opacity)
				  .animation(.easeInOut(duration: 0.25), value: messageIndex)
				
				Text("This usually takes a few seconds")
				  .font(.footnote)
				  .foregroundStyle(Color.primarytext.opacity(0.52))
				Spacer()
				Image("wating\(sprite)")
				  .resizable()
				  .scaledToFit()
			 }
			 .multilineTextAlignment(.center)
		  }
		}
	 }
  }
  
  private func floatingCircle(size: CGFloat, color: Color, x: CGFloat, y: CGFloat) -> some View {
	 Circle()
		.fill(color)
		.frame(width: size, height: size)
		.blur(radius: 4)
		.offset(x: x, y: y)
  }
}

#Preview {
    LoadingScreen(type: .recipeCreation)
}
