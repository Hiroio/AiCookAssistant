//
//  LoadingScreen.swift
//  CoockingApp
//
//  Created by user on 28.04.2026.
//

import SwiftUI

struct LoadingScreen: View {
  @State private var startTime: Date = .now
    var body: some View {
		ZStack{
		  Color.background.ignoresSafeArea()
		  
		  TimelineView(.animation(minimumInterval: 1)) { context in
			 
			 let interval = Int(context.date.timeIntervalSince(startTime))
			 let firstOffset = CGFloat(Int.random(in: -350...350))
			 let secondOffset = CGFloat(Int.random(in: -350...350))
			 ZStack(){
				Circle()
				  .fill(.card.opacity(0.8))
				  .offset(x: firstOffset, y: secondOffset)
				  .scaleEffect(1.6)
				
				
				Circle()
				  .fill(.card.opacity(0.7))
				  .offset(x: secondOffset, y: firstOffset)
				  .scaleEffect(1.4)
				
				
				let loading: String = String(repeating: ".", count: interval % 4)
				Text("Loading" + loading)
				  .font(.title.bold())
				  .fontDesign(.rounded)
				  .fontWeight(.black)
				  .shadow(radius: 2)
				  .foregroundStyle(.card)
				  .contentTransition(.numericText())
				  .animation(.easeInOut, value: interval)
				  .frame(maxHeight: .infinity, alignment: .bottom)
				
			 }
			 .animation(.easeInOut(duration: 10), value: firstOffset)
			 .animation(.easeInOut(duration: 10), value: secondOffset)
			 
//			 .blur(radius: 2)
			 
		  }
		  
		  
		}
    }
}

#Preview {
    LoadingScreen()
}
